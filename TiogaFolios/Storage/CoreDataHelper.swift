/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Extensions that add convenience methods to Core Data.
*/

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


// MARK: - Deduplicate tags.
//
extension Storage {
    /**
     Deduplicate tags that have the same name and are in the same CloudKit record zone, one tag at a time, on the historyQueue.
     All peers eventually reach the same result with no coordination or communication.
     */

    func deduplicateAndWait(tagObjectIDs: [NSManagedObjectID])
    {
        /**
         Make any store changes on a background context with the transaction author name of this app.
         Use performAndWait to serialize the steps. historyQueue runs in the background so this doesn't block the main queue.
         */
        let taskContext = container.newTaskContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.performAndWait {
            tagObjectIDs.forEach { tagObjectID in
                deduplicate(tagObjectID: tagObjectID, performingContext: taskContext)
            }
            taskContext.save(with: .deduplicateAndWait)
        }
    }

    /**
     Deduplicate one single tag.
     */
    private func deduplicate(tagObjectID: NSManagedObjectID, performingContext: NSManagedObjectContext) {
        /**
         tag.name can be nil when the app inserts a tag and immediately deletes it before processing the insertion .
         In that case, silently ignore the deleted tag.
         */
        guard let tag = performingContext.object(with: tagObjectID) as? Tag,
              let tagName = tag.title else {
            tfDebug("\(#function): Ignore a tag that was deleted: \(tagObjectID)")
            return
        }
        /**
         Fetch all tags with the same name, sorted by uuid, and return if there are no duplicates.
         */
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Tag.Schema.uuid.rawValue, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "\(Tag.Schema.title.rawValue) == %@", tagName)
        guard var duplicatedTags = try? performingContext.fetch(fetchRequest), duplicatedTags.count > 1 else {
            return
        }
        
        /**
         Filter out the tags that aren't in the same CloudKit record zone.
         Only tags that have the same name and are in the same record zone are duplicates.
         The tag zone ID can be nil, which means it isn't a shared tag. The filter rule is still valid in that case.
         */
        let tagZoneID = container.recordID(for: tag.objectID)?.zoneID
        duplicatedTags = duplicatedTags.filter {
            self.container.recordID(for: $0.objectID)?.zoneID == tagZoneID
        }
        
        guard duplicatedTags.count > 1 else {
            return
        }
        /**
         Pick the first tag as the winner.
         */
        tfDebug("\(#function): Deduplicating tag with name: \(tagName), count: \(duplicatedTags.count)")
        let winner = duplicatedTags.first!
        duplicatedTags.removeFirst()
        remove(duplicatedTags: duplicatedTags, winner: winner, performingContext: performingContext)
    }
    
    /**
     Remove duplicate tags from their respective photos, replacing them with the winner.
     */
    private func remove(duplicatedTags: [Tag], winner: Tag, performingContext: NSManagedObjectContext) {
//        duplicatedTags.forEach { tag in
//            if let photoSet = tag.photos {
//                for case let photo as Photo in photoSet {
//                    photo.removeFromTags(tag)
//                    photo.addToTags(winner)
//                }
//            }
//            performingContext.delete(tag)
//        }
    }
}
