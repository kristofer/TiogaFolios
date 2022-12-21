//
//  Persistence.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/15/22.
//

import CoreData

import CoreData
import QuickLook
import CloudKit

final class Storage {

    static let shared = Storage()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextWillSave(_:)), name: Notification.Name.NSManagedObjectContextWillSave, object: nil)

    }
    var vc: NSManagedObjectContext {
        container.viewContext
    }

    private var _privatePersistentStore: NSPersistentStore?
    private var _sharedPersistentStore: NSPersistentStore?

    var privatePersistentStore: NSPersistentStore {
      guard let privateStore = _privatePersistentStore else {
        fatalError("Private store is not set")
      }
      return privateStore
    }

    var sharedPersistentStore: NSPersistentStore {
      guard let sharedStore = _sharedPersistentStore else {
        fatalError("Shared store is not set")
      }
      return sharedStore
    }



    lazy var container: NSPersistentCloudKitContainer = {
        NotificationCenter.default.post(name: Notification.Name("starting up NSPersistentCloudKitContainer"), object: nil, userInfo: nil)
        
        let container = NSPersistentCloudKitContainer(name: Config.containerName)

        #if DEBUG
        do {
            // Use the container to initialize the development schema.
            try container.initializeCloudKitSchema(options: [])
        } catch {
            // Handle any errors.
        }
        #endif

        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
          fatalError("Unable to get persistentStoreDescription")
        }
        let storesURL = privateStoreDescription.url?.deletingLastPathComponent()
        privateStoreDescription.url = storesURL?.appendingPathComponent("TiogaFolios.sqlite") // would be TiogaFolios.sqlite
        privateStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: Config.containerIdentifier)
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        privateStoreDescription.setOption(true as NSNumber, forKey: remoteChangeKey)

        // TODO: 1
        let sharedStoreURL = storesURL?.appendingPathComponent("TFshared.sqlite")
        guard let sharedStoreDescription = privateStoreDescription
          .copy() as? NSPersistentStoreDescription else {
          fatalError(
            "Copying the private store description returned an unexpected value."
          )
        }
        sharedStoreDescription.url = sharedStoreURL

        // TODO: 2
        guard let containerIdentifier = privateStoreDescription
          .cloudKitContainerOptions?.containerIdentifier else {
          fatalError("Unable to get containerIdentifier")
        }
        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(
          containerIdentifier: containerIdentifier
        )
        sharedStoreOptions.databaseScope = .shared
        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
        sharedStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        sharedStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        sharedStoreDescription.setOption(true as NSNumber, forKey: remoteChangeKey)

        // TODO: 3
        container.persistentStoreDescriptions.append(sharedStoreDescription)

        // TODO: 4

        
        Foundation.NSLog("KKYY Loading: container.loadPersistentStores")
        container.loadPersistentStores { loadedStoreDescription, error in
          if let error = error as NSError? {
            fatalError("KKYY Failed to load persistent stores: \(error)")
          } else if let cloudKitContainerOptions = loadedStoreDescription
            .cloudKitContainerOptions {
            guard let loadedStoreDescritionURL = loadedStoreDescription.url else {
              return
            }
            if cloudKitContainerOptions.databaseScope == .private {
              let privateStore = container.persistentStoreCoordinator
                .persistentStore(for: loadedStoreDescritionURL)
              self._privatePersistentStore = privateStore
                Foundation.NSLog("KKYY Loading: _privatePersistentStore")
            } else if cloudKitContainerOptions.databaseScope == .shared {
              let sharedStore = container.persistentStoreCoordinator
                .persistentStore(for: loadedStoreDescritionURL)
              self._sharedPersistentStore = sharedStore
                Foundation.NSLog("KKYY Loading: _sharedPersistentStore")
            }
          }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        //container.viewContext.refreshAllObjects()
        
        return container

    }()
 
    @objc func contextWillSave(_ notification: Notification) {
//        print("KKYY \(notification)")
//        let context = notification.object as? NSManagedObjectContext
//        let changes = context?.updatedObjects
//        print("KKYY changes \(changes)")
//        let saveDate = Date()
        
    }

    func save() {
        //Foundation.NSLog("KKYY Storage save()")
        let context = Storage.shared.container.viewContext

        if context.hasChanges {
            do {
                
                try context.save()
                Foundation.NSLog("KKYY did SAVE persistence context")
            } catch {
                Foundation.NSLog("Storage saving failed \(error.localizedDescription)")
            }
        }
    }


    // for preview
    static var preview: Storage = {
        let result = Storage()
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newAsset = Asset(context: viewContext)
            newAsset.title = "sample asset"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()


}


extension Storage {
  func isShared(object: NSManagedObject) -> Bool {
    return isShared(objectID: object.objectID)
  }

  private func isShared(objectID: NSManagedObjectID) -> Bool {
    var isShared = false
    if let persistentStore = objectID.persistentStore {
      if persistentStore == sharedPersistentStore {
        isShared = true
      } else {
        let container = container
        do {
          let shares = try container.fetchShares(matching: [objectID])
          if shares.first != nil {
            isShared = true
          }
        } catch {
          print("Failed to fetch share for \(objectID): \(error)")
        }
      }
    }
    return isShared
  }
  
  func isOwner(object: NSManagedObject) -> Bool {
    guard isShared(object: object) else { return false }
    guard let share = try? container.fetchShares(matching: [object.objectID])[object.objectID] else {
      print("Get ckshare error")
      return false
    }
    if let currentUser = share.currentUserParticipant, currentUser == share.owner {
      return true
    }
    return false
  }

  func canEdit(object: NSManagedObject) -> Bool {
    return container.canUpdateRecord(
      forManagedObjectWith: object.objectID
    )
  }
  func canDelete(object: NSManagedObject) -> Bool {
    return container.canDeleteRecord(
      forManagedObjectWith: object.objectID
    )
  }

  var ckContainer: CKContainer {
    let storeDescription = container.persistentStoreDescriptions.first
    guard let identifier = storeDescription?
      .cloudKitContainerOptions?.containerIdentifier else {
      fatalError("Unable to get container identifier")
    }
    return CKContainer(identifier: identifier)
  }

  func getShare(_ folio: Folio) -> CKShare? {
    guard isShared(object: folio) else { return nil }
    guard let shareDictionary = try? container.fetchShares(matching: [folio.objectID]),
      let share = shareDictionary[folio.objectID] else {
      print("Unable to get CKShare")
      return nil
    }
    share[CKShare.SystemFieldKey.title] = folio.title
    return share
  }

}
