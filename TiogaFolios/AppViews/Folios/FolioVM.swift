//
//  FolioVM.swift
//  Carolina
//
//  Created by Kristofer Younger on 1/15/22.
//

import Foundation
import SwiftUI
import CoreData


class FolioVM: ObservableObject {
    
    // @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        //entity: Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Folio.title, ascending: false)],
        animation: .default)
    private var folios: FetchedResults<Folio>
}
