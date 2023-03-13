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


/**
 This app doesn't necessarily post notifications from the main queue.
 */
extension Notification.Name {
    static let tfStoreDidChange = Notification.Name("tfStoreDidChange")
}

struct UserInfoKey {
    static let storeUUID = "storeUUID"
    static let transactions = "transactions"
}

struct TransactionAuthor {
    static let app = "app"
}

final class Storage: NSObject, ObservableObject  {
    
    static let shared = Storage()
    private override init() {
        super.init()
//        NotificationCenter.default.addObserver(self, selector: #selector(contextWillSave(_:)), name: Notification.Name.NSManagedObjectContextWillSave, object: self.vc)
        
    }
    var vc: NSManagedObjectContext {
        
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        return container.viewContext
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
        let cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: Config.containerIdentifier)

        cloudKitContainerOptions.databaseScope = .private
        privateStoreDescription.cloudKitContainerOptions = cloudKitContainerOptions

        // TODO: 1
        guard let sharedStoreDescription = privateStoreDescription
            .copy() as? NSPersistentStoreDescription else {
            fatalError(
                "Copying the private store description returned an unexpected value."
            )
        }
        let sharedStoreURL = storesURL?.appendingPathComponent("TFshared.sqlite")
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
        
        
        Foundation.NSLog("TFdebug Loading: container.loadPersistentStores")
        container.loadPersistentStores { loadedStoreDescription, error in
            if let error = error as NSError? {
                fatalError("TFdebug Failed to load persistent stores: \(error)")
            } else if let cloudKitContainerOptions = loadedStoreDescription
                .cloudKitContainerOptions {
                guard let loadedStoreDescriptionURL = loadedStoreDescription.url else {
                    return
                }
                if cloudKitContainerOptions.databaseScope == .private {
                    let privateStore = container.persistentStoreCoordinator
                        .persistentStore(for: loadedStoreDescriptionURL)
                    self._privatePersistentStore = privateStore
                    Foundation.NSLog("TFdebug Loading: _privatePersistentStore")
                } else if cloudKitContainerOptions.databaseScope == .shared {
                    let sharedStore = container.persistentStoreCoordinator
                        .persistentStore(for: loadedStoreDescriptionURL)
                    self._sharedPersistentStore = sharedStore
                    Foundation.NSLog("TFdebug Loading: _sharedPersistentStore")
                }
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

        /**
         Pin the viewContext to the current generation token and set it to keep itself up-to-date with local changes.
         */
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("#\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        
        /**
         Observe the following notifications:
         - The remote change notifications from container.persistentStoreCoordinator.
         - The .NSManagedObjectContextDidSave notifications from any context.
         - The event change notifications from the container.
         */
        NotificationCenter.default.addObserver(self, selector: #selector(storeRemoteChange(_:)),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator)
        NotificationCenter.default.addObserver(self, selector: #selector(containerEventChanged(_:)),
                                               name: NSPersistentCloudKitContainer.eventChangedNotification,
                                               object: container)

        return container
        
    }()
    
//    @objc func contextWillSave(_ notification: Notification) {
//        //        print("TFdebug \(notification)")
//        //        let context = notification.object as? NSManagedObjectContext
//        //        let changes = context?.updatedObjects
//        //        print("TFdebug changes \(changes)")
//        //        let saveDate = Date()
//
//    }
    
    func save() {
        //Foundation.NSLog("TFdebug Storage save()")
        let context = Storage.shared.container.viewContext
        
        if context.hasChanges {
            do {
                
                try context.save()
                Foundation.NSLog("TFdebug did SAVE persistence context")
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
        
    lazy var cloudKitContainer: CKContainer = {
        return CKContainer(identifier: Config.containerIdentifier)
    }()
        
    /**
     An operation queue for handling history-processing tasks: watching changes, deduplicating tags, and triggering UI updates, if needed.
     */
    lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
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
            print("TFdebug Get ckshare error")
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
            fatalError("TFdebug Unable to get container identifier")
        }
        return CKContainer(identifier: identifier)
    }
    
    func getShare(_ folio: Folio) -> CKShare? {
        guard isShared(object: folio) else { return nil }
        guard let shareDictionary = try? container.fetchShares(matching: [folio.objectID]),
              let share = shareDictionary[folio.objectID] else {
            print("TFdebug Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = folio.title
        return share
    }
    
}

// MARK: - Notification handlers that trigger history processing.
//
extension Storage {
    /**
     Handle .NSPersistentStoreRemoteChange notifications.
     Process persistent history to merge relevant changes to the context, and deduplicate the tags, if necessary.
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
        guard let storeUUID = notification.userInfo?[NSStoreUUIDKey] as? String,
              [privatePersistentStore.identifier, sharedPersistentStore.identifier].contains(storeUUID) else {
            print("TFdebug \(#function): Ignore a store remote Change notification because of no valid storeUUID.")
            return
        }
        processHistoryAsynchronously(storeUUID: storeUUID)
    }

    /**
     Handle the container's event change notifications (NSPersistentCloudKitContainer.eventChangedNotification).
     */
    @objc
    func containerEventChanged(_ notification: Notification) {
         guard let value = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey],
              let event = value as? NSPersistentCloudKitContainer.Event else {
            print("TFdebug \(#function): Failed to retrieve the container event from notification.userInfo.")
            return
        }
        if event.error != nil {
            print("TFdebug \(#function): Received a persistent CloudKit container event changed notification.\n\(event)")
        }
    }
}

// MARK: - Process persistent historty asynchronously.
//
extension Storage {
    /**
     Process persistent history, posting any relevant transactions to the current view.
     This method processes the new history since the last history token, and is simply a fetch if there's no new history.
     */
    private func processHistoryAsynchronously(storeUUID: String) {
        historyQueue.addOperation {
            let taskContext = self.container.newTaskContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.performAndWait {
                self.performHistoryProcessing(storeUUID: storeUUID, performingContext: taskContext)
            }
        }
    }
    
    private func performHistoryProcessing(storeUUID: String, performingContext: NSManagedObjectContext) {
        /**
         Fetch the history by the other author since the last timestamp.
        */
        let lastHistoryToken = historyToken(with: storeUUID)
        let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
        let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
        historyFetchRequest.predicate = NSPredicate(format: "author != %@", TransactionAuthor.app)
        request.fetchRequest = historyFetchRequest

        if privatePersistentStore.identifier == storeUUID {
            request.affectedStores = [privatePersistentStore]
        } else if sharedPersistentStore.identifier == storeUUID {
            request.affectedStores = [sharedPersistentStore]
        }

        let result = (try? performingContext.execute(request)) as? NSPersistentHistoryResult
        guard let transactions = result?.result as? [NSPersistentHistoryTransaction] else {
            return
        }
        // print("\(#function): Processing transactions: \(transactions.count).")

        /**
         Post transactions so observers can update the UI, if necessary, even when transactions is empty
         because when a share changes, Core Data triggers a store remote change notification with no transaction.
         */
        let userInfo: [String: Any] = [UserInfoKey.storeUUID: storeUUID, UserInfoKey.transactions: transactions]
        NotificationCenter.default.post(name: .tfStoreDidChange, object: self, userInfo: userInfo)
        /**
         Update the history token using the last transaction. The last transaction has the latest token.
         */
        if let newToken = transactions.last?.token {
            updateHistoryToken(with: storeUUID, newToken: newToken)
        }
        
        /**
         Limit to the private store so only owners can deduplicate the tags. Owners have full access to the private database, and so
         don't need to worry about the permissions.
         */
        guard !transactions.isEmpty, storeUUID == privatePersistentStore.identifier else {
            return
        }
        /**
         Deduplicate the new tags.
         This only deduplicates the tags that aren't shared or have the same share.
         */
//        var newTagObjectIDs = [NSManagedObjectID]()
//        let tagEntityName = Tag.entity().name
//
//        for transaction in transactions where transaction.changes != nil {
//            for change in transaction.changes! {
//                if change.changedObjectID.entity.name == tagEntityName && change.changeType == .insert {
//                    newTagObjectIDs.append(change.changedObjectID)
//                }
//            }
//        }
//        if !newTagObjectIDs.isEmpty {
//            deduplicateAndWait(tagObjectIDs: newTagObjectIDs)
//        }
    }
    
    /**
     Track the last history tokens for the stores.
     The historyQueue reads the token when executing operations, and updates it after completing the processing.
     Access this user default from the history queue.
     */
    private func historyToken(with storeUUID: String) -> NSPersistentHistoryToken? {
        let key = "HistoryToken" + storeUUID
        if let data = UserDefaults.standard.data(forKey: key) {
            return  try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: data)
        }
        return nil
    }
    
    private func updateHistoryToken(with storeUUID: String, newToken: NSPersistentHistoryToken) {
        let key = "HistoryToken" + storeUUID
        let data = try? NSKeyedArchiver.archivedData(withRootObject: newToken, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: key)
    }
}
