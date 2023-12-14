//
//  FolioCell.swift
//  front panel folio summary
//
//  Created by Kristofer Younger on 1/13/22.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
}

struct FolioCell: View {
    @ObservedObject var folio: Folio
    
    let colorratio = 220/255.0
    private let storage = Storage.shared

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
                .shadow(radius: 5)
                .padding(5)
            HStack(alignment: .top) {
                Image(systemName: "magazine")
                    .foregroundColor(Color.accentColor)
                VStack(alignment: .leading) {
                    HStack {
                        Text(folio.title ?? "-")
                            .bold()
                        Image(systemName: Folio.sharingState(folio))
                            .font(.system(size: 24))
                    }
                    .foregroundColor(Color.accentColor)
                    
                    Text(folio.desc ?? "-")
                        .font(.caption.italic())
                        .lineLimit(2)
                        .padding(.bottom, 2)
//                    HStack {
//                        Text("\(folio.assets?.count ?? 0)")
//                            .font(.caption.italic())
//                        FolioCardItems(folio: folio)
//                    }
                    .foregroundColor(Color.accentColor)

                    HStack {
//                        Text("\(folio.tags?.count ?? 0)")
//                            .font(.caption.italic())
                        FolioTagItems(folio: folio)
                    }
                    .foregroundColor(Color.accentColor)

                }
            }
            .padding()
            //.background(.white)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color(.sRGB, red: colorratio, green: colorratio, blue: colorratio, opacity: 1.0), lineWidth: 2)
//            )
//            //topLeftButton()
        }
    }
    
    @ViewBuilder
    private func topLeftButton() -> some View {
//        if storage.sharedPersistentStore.contains(manageObject: folio) {
//            Image(systemName: "person.2.circle")
//                .foregroundColor(.gray)
//        }
        Image(systemName: Folio.sharingState(folio))
            .foregroundColor(.green)
            .padding(4)
    }

}

struct FolioCell_Previews: PreviewProvider {
    static var previews: some View {
        //FolioCell(folio: Binding(Tag.emptyFolio()) )
        EmptyView()
    }
}
