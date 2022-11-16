//
//  Persistence.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/15/22.
//

import CoreData

import CoreData
import QuickLook

final class Storage {

    static let privdb = Storage()
    private init() {}

    lazy var container: NSPersistentCloudKitContainer = {
        NotificationCenter.default.post(name: Notification.Name("starting up NSPersistentCloudKitContainer"), object: nil, userInfo: nil)
        
        let container = NSPersistentCloudKitContainer(name: Config.containerIdentifier)


        //Foundation.NSLog("KKYY Loading: container.loadPersistentStores")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                Foundation.NSLog("KKYY Unresolved error in loading cloudkit container \(error), \(error.userInfo)")
                    // SEE error notes below.
            }
            //Foundation.NSLog("KKYY Store description: \(storeDescription)")
            guard let description = container.persistentStoreDescriptions.first else {
                    fatalError("###\(#function): Failed to retrieve a persistent store description.")
                }
                description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: Config.containerIdentifier)
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        //container.viewContext.refreshAllObjects()
        
        return container

    }()
 
    func vc() -> NSManagedObjectContext {
        return Storage.privdb.container.viewContext
    }
 
    func save() {
        let context = Storage.privdb.container.viewContext

        if context.hasChanges {
            do {
                NSLog("KKYY did save main persistence context")
                try context.save()
            } catch {
                // Show some error here
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
