//
//  FolioCardItems.swift
//  Carolina
//
//  Created by Kristofer Younger on 1/6/22.
//

import SwiftUI

struct FolioCardItems: View {
    // @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var folio: Folio
    @State var assetList: [Asset]
    
    init(folio: Folio) {
        self.folio = folio
        self.assetList = Array(folio.assets as? Set<Asset> ?? [])
        self.assetList.sort {
            $0.lastmodified! > $1.lastmodified!
        }
    }

    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
             LazyHStack { //.sorted(by: >)
                 ForEach(assetList, id: \.self) { doc in
                     Label("\(String(describing: (doc.title ?? "nil doc name")))", systemImage: "doc.richtext")
                         .font(.caption)
                 }
             }
        }.frame(height: 20)
    }
}

struct FolioCardItems_Previews: PreviewProvider {
    static var emptyFolio: Folio = Folio.emptyFolio()
    static var previews: some View {
        FolioCardItems(folio: emptyFolio)
    }
}
