//
//  Storage+DeDupe.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 3/28/23.
//

import Foundation

import CoreData
import CloudKit

// MARK: - Deduplicate tags.
//
//extension Storage {
//    /**
//     Deduplicate tags that have the same name and are in the same CloudKit record zone, one tag at a time, on the historyQueue.
//     All peers eventually reach the same result with no coordination or communication.
//     */
//
//    func deduplicateAndWait(tagObjectIDs: [NSManagedObjectID])
//    {
//        /**
//         Make any store changes on a background context with the transaction author name of this app.
//         Use performAndWait to serialize the steps. historyQueue runs in the background so this doesn't block the main queue.
//         */
//        let taskContext = container.newTaskContext()
//        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        taskContext.performAndWait {
//            tagObjectIDs.forEach { tagObjectID in
//                deduplicate(tagObjectID: tagObjectID, performingContext: taskContext)
//            }
//            taskContext.save(with: .deduplicateAndWait)
//        }
//    }
//
//    /**
//     Deduplicate one single tag.
//     */
//    private func deduplicate(tagObjectID: NSManagedObjectID, performingContext: NSManagedObjectContext) {
//        /**
//         tag.name can be nil when the app inserts a tag and immediately deletes it before processing the insertion .
//         In that case, silently ignore the deleted tag.
//         */
//        guard let tag = performingContext.object(with: tagObjectID) as? Tag,
//              let tagUUID = tag.id?.uuidString else {
//            tfDebug("\(#function): Ignore a tag that was deleted: \(tagObjectID)")
//            return
//        }
//        tfDebug("\(#function): Tag: \(tagUUID)")
//        /**
//         Fetch all tags with the same name, sorted by uuid, and return if there are no duplicates.
//         */
//        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Tag.Schema.id.rawValue, ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "\(Tag.Schema.id.rawValue) == %@", tagUUID)
//        guard var duplicatedTags = try? performingContext.fetch(fetchRequest), duplicatedTags.count > 1 else {
//            tfDebug("\(#function): Tag has no duplicates: \(tagObjectID) \(tagUUID)")
//            return
//        }
//
//        duplicatedTags.forEach {
//            tfDebug("Tag: \(String(describing: $0.title))")
//        }
//
//        /**
//         Filter out the tags that aren't in the same CloudKit record zone.
//         Only tags that have the same name and are in the same record zone are duplicates.
//         The tag zone ID can be nil, which means it isn't a shared tag. The filter rule is still valid in that case.
//         */
////        let tagZoneID = container.recordID(for: tag.objectID)?.zoneID
////        duplicatedTags = duplicatedTags.filter {
////            self.container.recordID(for: $0.objectID)?.zoneID == tagZoneID
////        }
////        duplicatedTags.forEach {
////            tfDebug("Tag: \(String(describing: $0.title))")
////        }
//
//        guard duplicatedTags.count > 1 else {
//            tfDebug("\(#function): Tag has no duplicates: \(tagObjectID) \(tagUUID)")
//            return
//        }
//        /**
//         Pick the first tag as the winner.
//         */
//        tfDebug("\(#function): Deduplicating tag with name: \(tagUUID), count: \(duplicatedTags.count)")
//        let winner = duplicatedTags.first!
//        duplicatedTags.removeFirst()
//        remove(duplicatedTags: duplicatedTags, winner: winner, performingContext: performingContext)
//    }
//    
//    /**
//     Remove duplicate tags from their respective photos, replacing them with the winner.
//     */
//    private func remove(duplicatedTags: [Tag], winner: Tag, performingContext: NSManagedObjectContext) {
//        duplicatedTags.forEach { tag in
//            if let folioSet = tag.folios {
//                for case let folio as Folio in folioSet {
//                    folio.removeFromTags(tag)
//                    folio.addToTags(winner)
//                }
//            }
//            performingContext.delete(tag)
//        }
//    }
//}
