//
//  JSONLoadStore.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 5/4/23.
//

import Foundation
import CoreData

extension NSManagedObject {
  func toJSON() -> String? {
    let keys = Array(self.entity.attributesByName.keys)
    let dict = self.dictionaryWithValues(forKeys: keys)
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        return reqJSONStr
    }
    catch{}
    return nil
  }
}

extension Storage {
    
//    func makeJsonArray() -> String? {
//        do {
//            let tags = try self.container.viewContext.fetch(Tag.fetchRequest())
//            let tagmodels = tags.map{ (tag) -> TagJSON in
//                return TagJSON(from: tag)
//            }
//            let jsonData = try JSONEncoder().encode(tagmodels)
//        } catch {
//            print("Error fetching tag data from CoreData", error)
//        }
//    }
}
