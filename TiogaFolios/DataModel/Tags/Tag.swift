//
//  Tag.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import Foundation
import CoreData

// this is used to store the String in Core Data, but it is a ENUM in the data model.
extension Tag {

    static func allTags() -> [Tag] {
        //print("KKYY running fetch on all tags")
        let vc = Storage.privdb.vc()
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let dateSort = NSSortDescriptor(key:"title", ascending:true)
        fetchRequest.sortDescriptors = [dateSort]
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
//        for t in fetchedTags {
//            print("KKYY \(t.title!), [\(t.kind!)]")
//        }
        return fetchedTags
    }
    static func allTagsSelectable() -> [SelectableTagModel] {
        let ttags = allTags()
        let tt = Array(ttags).map { SelectableTagModel(displayedTag: $0) }
        return tt
    }
    
    static func allByKind(tagkind: TagKind) -> [Tag] {
        let vc = Storage.privdb.vc()
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let dateSort = NSSortDescriptor(key:"title", ascending:true)
        let predicate = NSPredicate(format: "kind == %@", tagkind.rawValue)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = predicate
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
        //print("KKYY tag list \(tagkind.rawValue) : \(fetchedTags.count)")
        return fetchedTags
    }
    
    static func allByKindCat(tagkind: TagKind, tagcat: TagCat) -> [Tag] {
        return allByTitleKindCat(title: tagkind.rawValue, tagkind: tagkind, tagcat: tagcat)
    }
    
    static func allByTitleKindCat(title: String, tagkind: TagKind, tagcat: TagCat) -> [Tag] {
        let vc = Storage.privdb.vc()
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "title == %@ AND kind == %@ AND category == %@", title, tagkind.rawValue, tagcat.rawValue)
        fetchRequest.predicate = predicate
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
        //print("KKYY tag list \(tagkind.rawValue) : \(fetchedTags.count)")
        return fetchedTags
    }
    
    func touch() { self.lastmodified = Date() }

    static func getOrCreate(title: String, desc: String,
                            tagkind: TagKind, tagcat: TagCat) -> Tag {
        let currentTags = allByTitleKindCat(title: title, tagkind: tagkind, tagcat: tagcat)
        if currentTags.count == 1 {
            return currentTags[0]
        }
        let newTag = createTag(vc: Storage.privdb.vc(),
                               named: title, desc: desc, kind: tagkind, category: tagcat)
        return newTag
    }

    static func createIfNotExists(title: String, tagkind: TagKind, tagcat: TagCat) -> Bool{
        let currentTags = allByTitleKindCat(title: tagkind.rawValue, tagkind: tagkind, tagcat: tagcat)
        if currentTags.count == 0 {
            _ = createTagApp(vc: Storage.privdb.vc(), named: tagkind.rawValue, kind: tagkind)
            return true
        }
        return false
    }
    
    static func loadAppTags() {
        for tt in TagKind.allCases {
            _ = createIfNotExists(title: tt.rawValue, tagkind: tt, tagcat: TagCat.app)
        }
    }

    func imgtxtForCat(tagcat: String) -> String {
        switch tagcat {
        case "user":
            return "person"
        case "system":
            return "computer"
        case "thirdparty":
            return "tag.circle"
        default:
            return "tag"
        }
    }

    func imgtxtFor(tagkind: TagKind) -> String {
        return tagkind.imgtxtFor(tagkind: tagkind)
    }
    
    static func createTag(vc: NSManagedObjectContext) -> (Tag) {
        return Tag.createTag(vc: vc, named: "Untitled", desc: "", kind: TagKind.plain, category: TagCat.user)
    }

    static func createTag(vc: NSManagedObjectContext, named: String, kind: TagKind) -> (Tag) {
        return Tag.createTag(vc: vc, named: "Untitled", desc: "", kind: TagKind.plain, category: TagCat.user)
    }
    
    static func createTagApp(vc: NSManagedObjectContext, named: String, kind: TagKind) -> (Tag) {
        return Tag.createTag(vc: vc, named: kind.rawValue, desc: "App tag for \(kind.rawValue)", kind: kind, category: TagCat.app)
    }
    
    // primary initializer
    static func createTag(vc: NSManagedObjectContext, named: String, desc: String, kind: TagKind, category: TagCat) -> (Tag) {
        let newTag = Tag(context: vc)
        newTag.id = UUID()
        newTag.title = named
        newTag.desc = desc
        newTag.kind = kind.rawValue
        newTag.category = TagCat.user.rawValue
        return newTag
    }

    
    func attach(blob: Asset, vc: NSManagedObjectContext) throws {
        self.addToAssets(blob)
        blob.addToTags(self)
    }

    func remove(blob: Asset, vc: NSManagedObjectContext) throws {
        self.removeFromAssets(blob)
        blob.removeFromTags(self)
    }

    func attach(folio: Folio, vc: NSManagedObjectContext) throws {
        self.addToFolios(folio)
        folio.addToTags(self)
    }

    func remove(folio: Folio, vc: NSManagedObjectContext) throws {
        folio.removeFromTags(self)
        self.removeFromFolios(folio)
    }

}
