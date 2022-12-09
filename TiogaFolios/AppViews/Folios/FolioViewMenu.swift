//
//  FolioViewMenu.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/27/22.
//

import SwiftUI

struct FolioViewMenu: View {
    var body: some View {
        Menu("Menu") {
            Button("Edit Folio...", action: editfolio)
            Button("Tags...", action: edittags)
            Button("Add to Folio...", action: addtofolio)
            Button("Add Note...", action: addnotetofolio)
            Button("Share Folio...", action: sharefolio)
        }
    }
    
    func editfolio() { }
    func edittags() { }
    func addtofolio() { }
    func addnotetofolio() { }
    func sharefolio() { }
}
struct FolioViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        FolioViewMenu()
    }
}
