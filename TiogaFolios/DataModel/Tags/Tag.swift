//
//  Tag.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

@objc(Tag)
public class Tag: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case desc = "Desc"
        case category = "Category"
        case favorite = "Favorite"
        case lastmodified = "LastModified"
        case ref = "Ref"
        case refstring = "RefString"
        case thumbnail = "Thumbnail"
    }

    enum DecoderConfigurationError: Error {
      case missingManagedObjectContext
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(UUID.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.desc = try values.decode(String.self, forKey: .desc)
        self.category = try values.decode(String.self, forKey: .category)
        self.favorite = try values.decode(Bool.self, forKey: .favorite)
        self.lastmodified = try values.decode(Date.self, forKey: .lastmodified)
        self.ref = try values.decode(URL.self, forKey: .ref)
        self.refstring = try values.decode(String.self, forKey: .refstring)
        self.thumbnail = try values.decode(Data.self, forKey: .thumbnail)
        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(desc, forKey: .desc)
        try container.encode(category, forKey: .category)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(lastmodified, forKey: .lastmodified)
        try container.encode(ref, forKey: .ref)
        try container.encode(refstring, forKey: .refstring)
        try container.encode(thumbnail, forKey: .thumbnail)

    }


}

// this is used to store the String in Core Data, but it is a ENUM in the data model.
extension Tag {

    enum Schema: String {
        case id, title, desc
    }

    static func allTags() -> [Tag] {
        //tfDebug("running fetch on all tags")
        let vc = Storage.shared.vc
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let dateSort = NSSortDescriptor(key:"lastmodified", ascending:true)
        fetchRequest.sortDescriptors = [dateSort]
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
//        for t in fetchedTags {
//            tfDebug("\(t.title!), [\(t.kind!)]")
//        }
        return fetchedTags
    }
    
    static func allByTitle(tt: String) -> [Tag] {
        let vc = Storage.shared.vc
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let dateSort = NSSortDescriptor(key:"title", ascending:true)
        let predicate = NSPredicate(format: "title == %@", tt)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = predicate
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
        //tfDebug("tag list \(tagkind.rawValue) : \(fetchedTags.count)")
        return fetchedTags
    }
    

    static func allTagsSelectable() -> [SelectableTagModel] {
        let ttags = allTags()
        let tt = Array(ttags).map { SelectableTagModel(displayedTag: $0) }
        return tt
    }
    
    static func allByKind(tagkind: TagKind) -> [Tag] {
        let vc = Storage.shared.vc
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let dateSort = NSSortDescriptor(key:"title", ascending:true)
        let predicate = NSPredicate(format: "kind == %@", tagkind.rawValue)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = predicate
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
        //tfDebug("tag list \(tagkind.rawValue) : \(fetchedTags.count)")
        return fetchedTags
    }
    
    static func allByKindCat(tagkind: TagKind, tagcat: TagCat) -> [Tag] {
        return allByTitleKindCat(title: tagkind.rawValue, tagkind: tagkind, tagcat: tagcat)
    }
    
    static func allByTitleKindCat(title: String, tagkind: TagKind, tagcat: TagCat) -> [Tag] {
        let vc = Storage.shared.vc
        var fetchedTags = [Tag]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        let predicate = NSPredicate(format: "title == %@ AND kind == %@ AND category == %@", title, tagkind.rawValue, tagcat.rawValue)
        fetchRequest.predicate = predicate
        fetchedTags = try! vc.fetch(fetchRequest) as! [Tag]
        //tfDebug("tag list \(tagkind.rawValue) : \(fetchedTags.count)")
        return fetchedTags
    }
    
    func touch() { self.lastmodified = Date() }

    static func getOrCreate(title: String, desc: String,
                            tagkind: TagKind, tagcat: TagCat) -> Tag {
        let currentTags = allByTitleKindCat(title: title, tagkind: tagkind, tagcat: tagcat)
        if currentTags.count >= 1 {
            return currentTags[0]
        }
        let newTag = createTag(vc: Storage.shared.vc,
                               named: title, desc: desc, kind: tagkind, category: tagcat)
        return newTag
    }

    static func createIfNotExists(title: String, tagkind: TagKind, tagcat: TagCat) -> Bool{
        let currentTags = allByTitleKindCat(title: tagkind.rawValue, tagkind: tagkind, tagcat: tagcat)
        if currentTags.count == 0 {
            _ = createTagApp(vc: Storage.shared.vc, named: tagkind.rawValue, kind: tagkind)
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
        return Tag.createTag(vc: vc, named: named, desc: "", kind: TagKind.plain, category: TagCat.user)
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
        newTag.lastmodified = .now
        newTag.favorite = false
        newTag.ref = URL(string: "")
        newTag.refstring = ""
        newTag.thumbnail = Data()
        return newTag
    }

    static func dedupeTags() { // DOES not save the viewContext
        tfDebug("Dedupe Tags")
        let vc = Storage.shared.vc

        let all = Tag.allTags()
        var foundDict = [String: Tag]()
        var tagsToDelete = [Tag]()
        
        for t in all {
            if let tuuid = t.id?.uuidString {
                if foundDict.updateValue(t, forKey: tuuid) == nil {
                    //tfDebug("Would keep (inserting) \(tuuid)")
                } else {
                    //tfDebug("Would REMOVE duplicate tag \(t.id?.uuidString ?? "no uuid")")
                    tagsToDelete.append(t)
                }
            }
        }
        
        for t in tagsToDelete {
            if let tuuid = t.id?.uuidString {
                // get tag that survived
                if let survivedTag = foundDict[tuuid] {
                    // copy each asset/folio from t to survivedTag
                    if let assets = survivedTag.assets {
                        for asset in assets {
                            try? survivedTag.attach(blob: asset as! Asset, vc: vc)
                        }
                    }
                    if let folios = survivedTag.folios {
                        for folio in folios {
                            try? survivedTag.attach(folio: folio as! Folio, vc: vc)
                        }
                    }
                }
                vc.delete(t)
            }
        }
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
