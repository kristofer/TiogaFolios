/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Extensions that wrap the related methods for sharing.
 */

import Foundation
import CoreData
import UIKit
import CloudKit

// MARK: - Convenient methods for managing sharing.
//
extension Storage {
//    func presentCloudSharingController(folio: Folio) {
//        /**
//         Grab the share if the folio is already shared.
//         */
//        var folioShare: CKShare?
//        
//        folioShare = Storage.shared.existingShare(folio: folio)
//        
//        let sharingController: UICloudSharingController
//        if folioShare == nil {
//            sharingController = newSharingController(unsharedFolio: folio, persistenceController: self)
//        } else {
//            sharingController = UICloudSharingController(share: folioShare!, container: cloudKitContainer)
//        }
//        sharingController.delegate = self
//        /**
//         Setting the presentation style to .formSheet so there's no need to specify sourceView, sourceItem, or sourceRect.
//         */
//        if let viewController = rootViewController {
//            sharingController.modalPresentationStyle = .formSheet
//            viewController.present(sharingController, animated: true)
//        }
//    }
//    
//    func presentCloudSharingController(share: CKShare) {
//        let sharingController = UICloudSharingController(share: share, container: cloudKitContainer)
//        sharingController.delegate = self
//        /**
//         Setting the presentation style to .formSheet so there's no need to specify sourceView, sourceItem, or sourceRect.
//         */
//        if let viewController = rootViewController {
//            sharingController.modalPresentationStyle = .formSheet
//            viewController.present(sharingController, animated: true)
//        }
//    }
    
//    private func newSharingController(unsharedFolio: Folio, persistenceController: Storage) -> UICloudSharingController {
//        return UICloudSharingController { (_, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
//            /**
//             The app doesn't specify a share intentionally, so Core Data creates a new share (zone).
//             CloudKit has a limit on how many zones a database can have, so this app provides an option for users to use an existing share.
//             
//             If the share's publicPermission is CKShareParticipantPermissionNone, only private participants can accept the share.
//             Private participants mean the participants an app adds to a share by calling CKShare.addParticipant.
//             If the share is more permissive, and is, therefore, a public share, anyone with the shareURL can accept it,
//             or self-add themselves to it.
//             The default value of publicPermission is CKShare.ParticipantPermission.none.
//             */
//            self.container.share([unsharedFolio], to: nil) { objectIDs, share, container, error in
//                if let share = share {
//                    self.configure(share: share, with: unsharedFolio)
//                }
//                completion(share, container, error)
//            }
//        }
//    }
//    
//    private var rootViewController: UIViewController? {
//        for scene in UIApplication.shared.connectedScenes {
//            if scene.activationState == .foregroundActive,
//               let sceneDelegate = (scene as? UIWindowScene)?.delegate as? UIWindowSceneDelegate,
//               let window = sceneDelegate.window {
//                return window?.rootViewController
//            }
//        }
//        tfDebug("\(#function): Failed to retrieve the window's root view controller.")
//        return nil
//    }
}

//extension Storage: UICloudSharingControllerDelegate {
    /**
     CloudKit triggers the delegate method in two cases:
     - An owner stops sharing a share.
     - A participant removes themselves from a share by tapping the Remove Me button in UICloudSharingController.
     
     After stopping the sharing,  purge the zone or just wait for an import to update the local store.
     This sample chooses to purge the zone to avoid stale UI. That triggers a "zone not found" error because UICloudSharingController
     deletes the zone, but the error doesn't really matter in this context.
     
     Purging the zone has a caveat:
     - When sharing an object from the owner side, Core Data moves the object to the shared zone.
     - When calling purgeObjectsAndRecordsInZone, Core Data removes all the objects and records in the zone.
     To keep the objects, deep copy the object graph you want to keep and make sure no object in the new graph is associated with any share.
     
     The purge API posts an NSPersistentStoreRemoteChange notification after finishing its job, so observe the notification to update
     the UI, if necessary.
     */
//    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
//        tfDebug("\n\n\(#function) DISABLED\n")
//        if let share = csc.share {
//            let keys = share.allKeys()
//            for k in keys {
//                //let f = k.debugDescription
//                tfDebug("key: \(k.debugDescription)")
//            }
//            //purgeObjectsAndRecords(with: share)
//        }
//    }
//    
//    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
//        if let share = csc.share, let persistentStore = share.persistentStore {
//            container.persistUpdatedShare(share, in: persistentStore) { (share, error) in
//                if let error = error {
//                    tfDebug("\(#function): Failed to persist updated share: \(error)")
//                } else {
//                    tfDebug("\(#function): successful")
//                }
//            }
//        }
//    }
    
//    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
//        tfDebug("\(#function): Failed to save a share: \(error)")
//    }
//    
//    func itemTitle(for csc: UICloudSharingController) -> String? {
//        return csc.share?.title ?? "Shared Folio"
//    }
//}

extension Storage {
    
    func shareObject(_ unsharedObject: NSManagedObject, to existingShare: CKShare?,
                     completionHandler: ((_ share: CKShare?, _ error: Error?) -> Void)? = nil)
    {
        container.share([unsharedObject], to: existingShare) { (objectIDs, share, container, error) in
            guard error == nil, let share = share else {
                tfDebug("\(#function): Failed to share an object: \(error!))")
                completionHandler?(share, error)
                return
            }
            /**
             Deduplicate tags, if necessary, because adding a folio to an existing share moves the whole object graph to the associated
             record zone, which can lead to duplicated tags.
             */
            if existingShare != nil {
                
//                if let tagObjectIDs = objectIDs?.filter({ $0.entity.name == "Tag" }), !tagObjectIDs.isEmpty {
//                    self.deduplicateAndWait(tagObjectIDs: Array(tagObjectIDs))
//                }
            } else {
                self.configure(share: share)
            }
            /**
             Synchronize the changes on the share to the private persistent store.
             */
            self.container.persistUpdatedShare(share, in: self.privatePersistentStore) { (share, error) in
                if let error = error {
                    tfDebug("\(#function): Failed to persist updated share: \(error)")
                }
                completionHandler?(share, error)
            }
        }
    }
    
    /**
     Delete the Core Data objects and the records in the CloudKit record zone associated with the share.
     */
    func purgeObjectsAndRecords(with share: CKShare, in persistentStore: NSPersistentStore? = nil) {
        guard let store = (persistentStore ?? share.persistentStore) else {
            tfDebug("\(#function): Failed to find the persistent store for share. \(share))")
            return
        }
        tfDebug("\(#function): Would purge objects and records!!")
        container.purgeObjectsAndRecordsInZone(with: share.recordID.zoneID, in: store) { (zoneID, error) in
            if let error = error {
                tfDebug("\(#function): Failed to purge objects and records: \(error)")
            }
        }
        
    }
        
    func existingShare(folio: Folio) -> CKShare? {
        if let shareSet = try? container.fetchShares(matching: [folio.objectID]),
           let (_, share) = shareSet.first {
            return share
        }
        return nil
    }
    
    func share(with title: String) -> CKShare? {
        let stores = [privatePersistentStore, sharedPersistentStore]
        let shares = try? container.fetchShares(in: stores)
        let share = shares?.first(where: { $0.title == title })
        return share
    }
    
    func shareTitles() -> [String] {
        let stores = [privatePersistentStore, sharedPersistentStore]
        let shares = try? container.fetchShares(in: stores)
        if let shares = shares {
            for sh in shares {
                tfDebug("share is \(sh.title)")
            }
        } else {
            tfDebug("no shares found.")
        }
        return shares?.map { $0.title } ?? []
    }
    
    private func configure(share: CKShare, with folio: Folio? = nil) {
        if let folio = folio {
            share[CKShare.SystemFieldKey.title] = folio.title
            return
        }
        share[CKShare.SystemFieldKey.title] = "Shared Folio"
    }
}

extension Storage {
    func addParticipant(emailAddress: String, permission: CKShare.ParticipantPermission = .readWrite, share: CKShare,
                        completionHandler: ((_ share: CKShare?, _ error: Error?) -> Void)?) {
        /**
         Use the email address to look up the participant from the private store. Return if the participant doesn't exist.
         Use privatePersistentStore directly because only the owner may add participants to a share.
         */
        let lookupInfo = CKUserIdentity.LookupInfo(emailAddress: emailAddress)
        let persistentStore = privatePersistentStore //share.persistentStore!
        
        container.fetchParticipants(matching: [lookupInfo], into: persistentStore) { (results, error) in
            guard let participants = results, let participant = participants.first, error == nil else {
                completionHandler?(share, error)
                return
            }
            
            participant.permission = permission
            participant.role = .privateUser
            share.addParticipant(participant)
            
            self.container.persistUpdatedShare(share, in: persistentStore) { (share, error) in
                if let error = error {
                    tfDebug("\(#function): Failed to persist updated share: \(error)")
                }
                completionHandler?(share, error)
            }
        }
    }
    
    func deleteParticipant(_ participants: [CKShare.Participant], share: CKShare,
                           completionHandler: ((_ share: CKShare?, _ error: Error?) -> Void)?) {
        for participant in participants {
            share.removeParticipant(participant)
        }
        /**
         Use privatePersistentStore directly because only the owner may delete participants to a share.
         */
        container.persistUpdatedShare(share, in: privatePersistentStore) { (share, error) in
            if let error = error {
                tfDebug("\(#function): Failed to persist updated share: \(error)")
            }
            completionHandler?(share, error)
        }
    }
}

extension CKShare.ParticipantAcceptanceStatus {
    var stringValue: String {
        return ["Unknown", "Pending", "Accepted", "Removed"][rawValue]
    }
}

extension CKShare {
    var title: String {
        return self[SystemFieldKey.title] as? String ?? "folio share"
    }
    
    var persistentStore: NSPersistentStore? {
        let container = Storage.shared.container
        let privatePersistentStore = Storage.shared.privatePersistentStore
        if let shares = try? container.fetchShares(in: privatePersistentStore) {
            let zoneIDs = shares.map { $0.recordID.zoneID }
            if zoneIDs.contains(recordID.zoneID) {
                return privatePersistentStore
            }
        }
        let sharedPersistentStore = Storage.shared.sharedPersistentStore
        if let shares = try? container.fetchShares(in: sharedPersistentStore) {
            let zoneIDs = shares.map { $0.recordID.zoneID }
            if zoneIDs.contains(recordID.zoneID) {
                return sharedPersistentStore
            }
        }
        return nil
    }
}


extension NSManagedObject {
    
    enum DeepCopyError: Error {
        case missingContext
        case missingEntityName(NSManagedObject)
        case unmanagedObject(Any)
    }
    
    func deepcopy(context: NSManagedObjectContext? = nil) throws -> NSManagedObject {
        
        if let context = context ?? managedObjectContext {
            
            var cache = Dictionary<NSManagedObjectID, NSManagedObject>()
            return try deepcopy(context: context, cache: &cache)
            
        } else {
            throw DeepCopyError.missingContext
        }
    }
    
    private func deepcopy(context: NSManagedObjectContext, cache alreadyCopied: inout Dictionary<NSManagedObjectID, NSManagedObject>) throws -> NSManagedObject {
        
        guard let entityName = self.entity.name else {
            throw DeepCopyError.missingEntityName(self)
        }
        
        if let storedCopy = alreadyCopied[self.objectID] {
            return storedCopy
        }
        // already entity has been copied.
        
        // but if here, make a copy of the object
        let cloned = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        alreadyCopied[self.objectID] = cloned
        
        // Loop through all attributes and assign them to the clone (new object)
        NSEntityDescription
            .entity(forEntityName: entityName, in: context)?
            .attributesByName
            .forEach { attribute in
                cloned.setValue(value(forKey: attribute.key), forKey: attribute.key)
            }
        
        // Loop through all relationships, and clone them.
        try NSEntityDescription
            .entity(forEntityName: entityName, in: context)?
            .relationshipsByName
            .forEach { relation in
                
                if relation.value.isToMany {
                    if relation.value.isOrdered {
                        
                        // Get a set of all objects in the relationship
                        let sourceSet = mutableOrderedSetValue(forKey: relation.key)
                        let clonedSet = cloned.mutableOrderedSetValue(forKey: relation.key)
                        
                        for object in sourceSet.objectEnumerator() {
                            if let relatedObject = object as? NSManagedObject {
                                
                                // Clone it, and add clone to the set
                                let clonedRelatedObject = try relatedObject.deepcopy(context: context, cache: &alreadyCopied)
                                clonedSet.add(clonedRelatedObject as Any)
                                
                            } else {
                                throw DeepCopyError.unmanagedObject(object)
                            }
                        }
                        
                    } else {
                        
                        // Get a set of all objects in the relationship
                        let sourceSet = mutableSetValue(forKey: relation.key)
                        let clonedSet = cloned.mutableSetValue(forKey: relation.key)
                        
                        for object in sourceSet.objectEnumerator() {
                            if let relatedObject = object as? NSManagedObject {
                                
                                // Clone it, and add clone to the set
                                let clonedRelatedObject = try relatedObject.deepcopy(context: context, cache: &alreadyCopied)
                                clonedSet.add(clonedRelatedObject as Any)
                                
                            } else {
                                throw DeepCopyError.unmanagedObject(object)
                            }
                        }
                    }
                    
                } else if let relatedObject = self.value(forKey: relation.key) as? NSManagedObject {
                    
                    // Clone it, and assign then to the clone
                    let clonedRelatedObject = try relatedObject.deepcopy(context: context, cache: &alreadyCopied)
                    cloned.setValue(clonedRelatedObject, forKey: relation.key)
                    
                }
            }
        
        return cloned
    }
}


extension Storage {
    // See <https://developer.apple.com/documentation/uikit/uicloudsharingcontroller>
    // from a post by Reinhard Männer
    
    // For sharing see https://developer.apple.com/documentation/cloudkit/shared_records
    func share(folio: Folio, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) {
        if #available(iOS 15, *) {
            // iOS 15++
            let recordZoneID = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone", ownerName: CKCurrentUserDefaultName)
            let shareRecord = CKShare(recordZoneID: recordZoneID)
            
            // Configure the share so the system displays the shopping lists name and logo
            // when the user initiates sharing or accepts an invitation to participate.
            shareRecord[CKShare.SystemFieldKey.title] = folio.title
            //                let image = UIImage(named: kFileNameLogo)!.pngData()
            //                shareRecord[CKShare.SystemFieldKey.thumbnailImageData] = image
            // Include a custom UTI that describes the share's content.
            shareRecord[CKShare.SystemFieldKey.shareType] = "co.tioga.TiogaFolios.folio"
            
            
            let recordsToSave = [shareRecord]
            let container = CKContainer.default()
            let privateDatabase = container.privateCloudDatabase
            let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
            operation.perRecordProgressBlock = { (record, progress) in
                if progress < 1.0 {
                    print("CloudKit error: Could not save record completely")
                }
            }
            
            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .success:
                    completion(shareRecord, container, nil)
                case .failure(let error):
                    completion(nil, nil, error)
                }
            }
            
            privateDatabase.add(operation)
            
            
        } else {
            // iOS <15
            fatalError("Sharing is only available in iOS 15")
        }
    }
    
    func getShareRecord(completion: @escaping (Result<CKShare?, Error>) -> Void) {
        let container = Storage.shared.container
        let existingShares = try? container.fetchShares(in: privatePersistentStore)
        if let shares = existingShares{
            switch shares.count {
            case 0:
                completion(.success(nil))
                return
            case 1:
                let recordResult = Result(catching: {shares.first! })
                switch recordResult {
                case .success(let ckRecord):
                    completion(.success(ckRecord as CKShare))
                    return
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            default:
                tfDebug("More than 1 CKShare record")
                for sh in shares {
                    print("share: \(sh.debugDescription)")
                }
            }
        } else {
            //completion(.failure(Error("no shares found.")))
            tfDebug("unable to get shares from privatePersistentStore")
            return
        }
    }
    //let query = CKQuery(recordType: "cloudkit.share", predicate: NSPredicate(value: true))
    
    // doc
    //        func fetch(
    //            withQuery query: CKQuery,
    //            inZoneWith zoneID: CKRecordZone.ID? = nil,
    //            desiredKeys: [CKRecord.FieldKey]? = nil,
    //            resultsLimit: Int = CKQueryOperation.maximumResults,
    //            completionHandler: @escaping (Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>) -> Void
    //        )
    //        privateDatabase.fetch(withQuery: query) { result in
    //            switch result {
    //            case .success(let returned):
    //                // .success((matchResults: [CKRecord.ID : Result<CKRecord, Error>], queryCursor: CKQueryOperation.Cursor?))
    //                let matchResults = returned.0 // [CKRecord.ID : Result<CKRecord, Error>]
    //                switch matchResults.count {
    //                case 0:
    //                    completion(.success(nil))
    //                    return
    //                case 1:
    //                    let recordResult = matchResults.values.first!
    //                    switch recordResult {
    //                    case .success(let ckRecord):
    //                        completion(.success(ckRecord as? CKShare))
    //                        return
    //                    case .failure(let error):
    //                        completion(.failure(error))
    //                        return
    //                    }
    //                default:
    //                    fatalError("More than 1 CKShare record")
    //                }
    //            case .failure(let error):
    //                completion(.failure(error))
    //                return
    //            }
    //        }
    
    
}

