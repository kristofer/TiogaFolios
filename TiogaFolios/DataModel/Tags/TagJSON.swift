//
//  TagJSON.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 5/4/23.
//

import Foundation

struct TagJSON: Codable {
    var category: String?
    var desc: String?
    var favorite: Bool?
    var id: UUID?
    var kind: String?
    var lastmodified: Date?
    var ref: URL?
    var refstring: String?
    var thumbnail: Data?
    var title: String?

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

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(UUID.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        desc = try values.decode(String.self, forKey: .desc)
        category = try values.decode(String.self, forKey: .category)
        favorite = try values.decode(Bool.self, forKey: .favorite)
        lastmodified = try values.decode(Date.self, forKey: .lastmodified)
        ref = try values.decode(URL.self, forKey: .ref)
        refstring = try values.decode(String.self, forKey: .refstring)
        thumbnail = try values.decode(Data.self, forKey: .thumbnail)
    }

    func encode(to encoder: Encoder) throws {
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
