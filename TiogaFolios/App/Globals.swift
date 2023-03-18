//
//  Globals.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 3/13/23.
//

import Foundation


public func tfDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var nitems: [Any] = items
    nitems.insert("TFdebug ", at: 0)
    Foundation.NSLog(separator, nitems)
}
