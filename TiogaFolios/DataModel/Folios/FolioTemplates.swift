//
//  LoadTemplJSON.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/26/22.
//

import Foundation

//{
//    "title": "Last Will and Testament",
//    "desc": "Will and other items to track with it",
//    "tags": [
//        {
//            "category": "app",
//            "desc": "",
//            "kind": "legal",
//            "title": "Will"
//        }
//    ],
//    "assets": [
//        {
//            "title": "Will Document",
//            "desc": "a digital copy of your will",
//            "mimetype": "plain/empty"
//        },
//        {
//            "title": "Notes About The Will",
//            "desc": "tracking the laywer, or source of your will and information about the will",
//            "mimetype": "plain/empty"
//        }
//
//    ]
//},
struct AssetTemplate: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var desc: String
    var mimetype: String
    private enum CodingKeys: String, CodingKey {
        case title, desc, mimetype
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct TagTemplate: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var desc: String
    var kind: String
    var category: String
    private enum CodingKeys: String, CodingKey {
        case title, desc, kind, category
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FolioTemplate: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var desc: String
    var tags: [ TagTemplate ]?
    var assets: [ AssetTemplate ]?
    
    private enum CodingKeys: String, CodingKey {
        case title, desc, tags, assets
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FolioRoot: Codable {
    let data : [FolioTemplate]?
}

func decodeTemplatesFromString(_ data: Data) -> [ FolioTemplate ] {
    
    let decoder = JSONDecoder()

    do {
        let folioroot = try decoder.decode(FolioRoot.self, from: data)
        return folioroot.data ?? []
    } catch DecodingError.dataCorrupted(let context) {
        print(context)
    } catch DecodingError.keyNotFound(let key, let context) {
        print("KKYY Key '\(key)' not found:", context.debugDescription)
        print("KKYY codingPath:", context.codingPath)
    } catch DecodingError.valueNotFound(let value, let context) {
        print("KKYY Value '\(value)' not found:", context.debugDescription)
        print("KKYY codingPath:", context.codingPath)
    } catch DecodingError.typeMismatch(let type, let context) {
        print("KKYY Type '\(type)' mismatch:", context.debugDescription)
        print("KKYY codingPath:", context.codingPath)
    } catch {
        print("KKYY error: ", error)
    }//    } catch {
//        print("KKYY \(error.localizedDescription)")
//    }
    return []
}

