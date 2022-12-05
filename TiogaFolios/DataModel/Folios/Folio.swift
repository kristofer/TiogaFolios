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
        //Foundation.NSLog("KKYY folio create \(vc), \(title)")
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
        return Folio.createFolio(vc: vc, title: "Untitled", desc: "")
    }

    static func emptyFolio() -> (Folio) {
        return Folio.createFolio(vc: Storage.privdb.vc(), title: "Untitled", desc: "description")
    }
    
    static func createFolioFromTemplate(_ template: FolioTemplate) -> Folio {
        let vc = Storage.privdb.vc()
        
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
        let dateSort = NSSortDescriptor(key:"title", ascending:true)
        //let predicate = NSPredicate(format: "kindValue == %i", TagKind.folio.rawValue)
        fetchRequest.sortDescriptors = [dateSort]
        //fetchRequest.predicate = predicate
        
        do {
            fetchedFolios = try vc.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            Foundation.NSLog("No folios in store")
        }
        //print("KKYY folio count \(fetchedFolios.count)")
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
