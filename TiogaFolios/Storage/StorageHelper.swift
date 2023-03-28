/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extensions that add convenience methods to Core Data.
*/
import Foundation

import CoreData
import CloudKit

extension NSPersistentStore {
    func contains(manageObject: NSManagedObject) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: manageObject.entity.name!)
        fetchRequest.predicate = NSPredicate(format: "self == %@", manageObject)
        fetchRequest.affectedStores = [self]

        if let context = manageObject.managedObjectContext,
           let result = try? context.count(for: fetchRequest), result > 0 {
            return true
        }
        return false
    }
}

extension NSManagedObject {
    var persistentStore: NSPersistentStore? {
        let persistenceController = Storage.shared
        if persistenceController.sharedPersistentStore.contains(manageObject: self) {
            return persistenceController.sharedPersistentStore
        } else if persistenceController.privatePersistentStore.contains(manageObject: self) {
            return persistenceController.privatePersistentStore
        }
        return nil
    }
}

extension NSManagedObjectContext {
    /**
     Contextual information for handling errors that occur when saving a managed object context.
     */
    enum ContextualInfoForSaving: String {
        case addPhoto, deletePhoto
        case toggleTagging, deleteTag, addTag
        case addRating, deleteRating
        case sheetOnDismiss
        case deduplicateAndWait
    }
    /**
     Save a context and handle the save error. This sample simply prints the error message. Real apps can
     implement comprehensive error handling based on the contextual information.
     */
    func save(with contextualInfo: ContextualInfoForSaving) {
        if hasChanges {
            do {
                try save()
            } catch {
                tfDebug("\(#function): Failed to save Core Data context for \(contextualInfo.rawValue): \(error)")
            }
        }
    }
}

/**
 A convenience method for creating background contexts that specify the app as their transaction author.
 */
extension NSPersistentCloudKitContainer {
    func newTaskContext() -> NSManagedObjectContext {
        let context = newBackgroundContext()
        context.transactionAuthor = TransactionAuthor.app
        return context
    }
    
    /**
     Fetch and return shares in the persistent stores.
     */
    func fetchShares(in persistentStores: [NSPersistentStore]) throws -> [CKShare] {
        var results = [CKShare]()
        for persistentStore in persistentStores {
            do {
                let shares = try fetchShares(in: persistentStore)
                results += shares
            } catch let error {
                tfDebug("Failed to fetch shares in \(persistentStore).")
                throw error
            }
        }
        return results
    }
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
                    tfDebug("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }
    
    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return false }
        guard let share = try? container.fetchShares(matching: [object.objectID])[object.objectID] else {
            tfDebug("Get ckshare error")
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
    
//    var ckContainer: CKContainer {
//        let storeDescription = container.persistentStoreDescriptions.first
//        guard let identifier = storeDescription?
//            .cloudKitContainerOptions?.containerIdentifier else {
//            fatalError("TFdebug Unable to get container identifier")
//        }
//        return CKContainer(identifier: identifier)
//    }
    
    func getShare(_ folio: Folio) -> CKShare? {
        guard isShared(object: folio) else { return nil }
        guard let shareDictionary = try? container.fetchShares(matching: [folio.objectID]),
              let share = shareDictionary[folio.objectID] else {
            tfDebug("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = folio.title
        return share
    }
    
}
