//
//  Folio.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import Foundation
import CoreData
import UniformTypeIdentifiers

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
