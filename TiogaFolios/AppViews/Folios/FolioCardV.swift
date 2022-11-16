//
//  FolioCardV.swift
//  Carolina
//
//  Created by Kristofer Younger on 1/6/22.
//

import SwiftUI

struct FolioCardV: View {
    // @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var folio: Folio
    
    let colorratio = 150/255.0
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Label("\(String(describing: (folio.title ?? "nil folio name")))", systemImage: "folder")
                //Text("As of \(folio.modified ?? .now, style: .date), \(folio.modified ?? .now, style: .time)")
                //    .font(.caption)
                FolioCardItems(folio: folio)
            }
            .padding(5)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: colorratio, green: colorratio, blue: colorratio, opacity: 0.8), lineWidth: 1)
            )
        }
    }
    
    
    
}

struct FolioCardV_Previews: PreviewProvider {
    static var previews: some View {
        FolioCardV(folio: Folio.emptyFolio())
    }
}
