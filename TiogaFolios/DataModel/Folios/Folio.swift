//
//  Folio.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import Foundation
import CoreData
import UniformTypeIdentifiers

import UIKit

@objc(Folio)
public class Folio: NSManagedObject { }

extension Folio {
    
    // designated base constructor
    static func createFolio(vc: NSManagedObjectContext,
                            title: String,
                            desc: String) -> (Folio) {
        //Foundation.NSLog("TFdebug folio create \(vc), \(title)")
        let f = Folio(context: vc)
        f.id = UUID()
        f.title = title
        f.desc = desc
        f.lastmodified = Date()
        return f
    }
    
    static func createFolio(vc: NSManagedObjectContext, title: String) -> (Folio) {
        return createFolio(vc: vc, title: title, desc: "")
    }
    
    static func createFolio(vc: NSManagedObjectContext) -> (Folio) {
        return Folio.createFolio(vc: vc, title: "", desc: "")
    }

    static func emptyFolio() -> (Folio) {
        return Folio.createFolio(vc: Storage.shared.vc, title: "", desc: "")
    }
    
    static func createFolioFromTemplate(_ template: FolioTemplate) -> Folio {
        let vc = Storage.shared.vc
        
        let f = createFolio(vc: vc, title: template.title, desc: template.title)
        // do tags
        for t in template.tags! {
            let ttag = Tag.getOrCreate(title: t.title, desc: t.desc,
                                       tagkind: TagKind(rawValue: t.kind)!,
                                       tagcat: TagCat(rawValue: t.category)!)
            f.attachTag(ttag)
        }
        // do assets
        for aa in template.assets! {
            let newAsset = Asset(vc: vc, title: aa.title, path: "", mimetype: aa.mimetype, uttype: "")
            newAsset.desc = aa.desc
            newAsset.setBlob(Data())
            f.addToAssets(newAsset)
        }
        return f
    }
    
    func touch() { self.lastmodified = Date() }

    static func fetchFolios(vc: NSManagedObjectContext) -> [Folio] {
        var fetchedFolios = [Folio]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        let notLocked = NSPredicate(format: "locked == %@", false as NSNumber)
        fetchRequest.predicate = notLocked
        
        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        tfDebug("folio count \(fetchedFolios.count)")
        return fetchedFolios
    }
    
    func refetchFolio(vc: NSManagedObjectContext) -> Folio? {
        guard let folioID = self.id else { return nil }
        let request = NSFetchRequest<Folio>(entityName: "Folio")
        request.predicate = NSPredicate(format: "id == %@", folioID as CVarArg)
        
        do {
            return try vc.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }
//    static func fetchSingleFolio(vc: NSManagedObjectContext, uuid: UUID) -> Folio? {
//        var fetchedFolio: Folio?
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
//        let which = NSPredicate(format: "id == %@", uuid as CVarArg)
//        fetchRequest.predicate = which
//
//        do {
//            fetchedFolio = try (vc.fetch(fetchRequest) as! Folio?)
//            return fetchedFolio
//        } catch {
//            Foundation.NSLog("No folios in store")
//        }
//        return fetchedFolio
//    }
    

    static func fetchPrivateFolios(vc: NSManagedObjectContext) -> [Folio] {
        var fetchedFolios = [Folio]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        let notLocked = NSPredicate(format: "locked == %@", false as NSNumber)
        fetchRequest.predicate = notLocked
        
        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        var fs = [Folio]()
        let Store = Storage.shared
        for f in fetchedFolios{
            if Store.isShared(object: f) == false {
                fs.append(f)
            }
        }
        tfDebug("private folio count \(fs.count)")
        return fs
//        tfDebug("folio count \(fetchedFolios.count)")
//        return fetchedFolios
    }
    
    static func fetchSharedFolios(vc: NSManagedObjectContext) -> [Folio] {
        var fetchedFolios = [Folio]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        let notLocked = NSPredicate(format: "locked == %@", false as NSNumber)
        fetchRequest.predicate = notLocked
        
        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        var fs = [Folio]()
        let Store = Storage.shared
        for f in fetchedFolios{
            if Store.isShared(object: f) && (Store.isOwner(object: f) == false) {
                fs.append(f)
            }
        }
        tfDebug("shared folio count \(fs.count)")
        return fs
//        tfDebug("folio count \(fetchedFolios.count)")
//        return fetchedFolios
    }
    
    static func fetchSharingFolios(vc: NSManagedObjectContext) -> [Folio] {
        var fetchedFolios = [Folio]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        let notLocked = NSPredicate(format: "locked == %@", false as NSNumber)
        fetchRequest.predicate = notLocked
        
        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        var fs = [Folio]()
        let Store = Storage.shared
        for f in fetchedFolios{
            if Store.isShared(object: f) && Store.isOwner(object: f) {
                fs.append(f)
            }
        }
        tfDebug("sharing folio count \(fs.count)")
        return fs
//        tfDebug("folio count \(fetchedFolios.count)")
//        return fetchedFolios
    }
    
    static func sharingState(_ f: Folio) -> String {
        let Store = Storage.shared
        if Store.isShared(object: f) == false {
            return "lock.icloud" // not shared was "icloud.slash"
        }
        if Store.isShared(object: f) && (Store.isOwner(object: f) == false) {
            return "icloud.and.arrow.down" // shared in
        }
        if Store.isShared(object: f) && Store.isOwner(object: f) {
            return "icloud.and.arrow.up" // shared out
        }
        return "icloud"
    }
    static func fetchFoliosAnd(vc: NSManagedObjectContext, relations: [String]) -> [Folio] {
        var fetchedFolios = [Folio]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        fetchRequest.relationshipKeyPathsForPrefetching = relations
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        let notLocked = NSPredicate(format: "locked == %@", false as NSNumber)
        fetchRequest.predicate = notLocked

        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        tfDebug("folio count \(fetchedFolios.count)")
        return fetchedFolios
    }

    static func fetchArchivedFolios(vc: NSManagedObjectContext) -> [Folio] {
        var fetchedFolios = [Folio]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        let notLocked = NSPredicate(format: "locked == %@", true as NSNumber)
        fetchRequest.predicate = notLocked
        
        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        tfDebug("folio count \(fetchedFolios.count)")
        return fetchedFolios
    }
    

//    var folioSize: Int32 {
//        get {
//            return 0
//        }
//    }
}

extension Folio: Assetable {
    func attachAsset(_ asset: Asset) {
        self.addToAssets(asset)
    }
    
    func removeAsset(_ asset: Asset) {
        self.removeFromAssets(asset)
    }
}

extension Folio: Taggable {
    func attachTag(_ tag: Tag) {
        self.addToTags(tag)
    }
    
    func removeTag(_ tag: Tag) {
        self.removeFromTags(tag)
    }
}
