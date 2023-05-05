//
//  TagSources.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/17/22.
//

import Foundation

enum TagCat: String,  CaseIterable, Identifiable, Decodable {
    case user, app, system, thirdparty
    
    var id: String { self.rawValue }

}

enum TagKind: String,  CaseIterable, Identifiable, Decodable {
    case person, place, thing,
         money, estate, legal, tax, insurance,
         occupation, medical, home, car, education,
         plain, meta
    
    var id: String { self.rawValue }

    func imgtxtFor(tagkind: TagKind) -> String {
        switch tagkind {
        case .estate:
            return "list.bullet.rectangle"
        case .money:
            return "banknote"
        case .legal:
            return "building.columns"
        case .tax:
            return "dollarsign.square"
        case .medical:
            return "cross.case"
        case .insurance:
            return "checkmark.shield"
        case .occupation:
            return "person.crop.circle.badge"
        case .education:
            return "graduationcap"
        case .home:
            return "house"
        case .car:
            return "car"
        case .person:
            return "person"
        case .place:
            return "location"
        case .thing:
            return "camera"
        case .plain:
            return "tag"
        case .meta:
            return "tag.circle"
//        default:
//            return "tag"
        }
    }

}

//struct TagJSON: Decodable {
//
//    let title: String
//    let desc: String
//    let category: TagCat
//    let kind: TagKind
//}
