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

    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
             LazyHStack {
                 ForEach(Array(folio.assets as? Set<Asset> ?? []), id: \.self) { doc in
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
