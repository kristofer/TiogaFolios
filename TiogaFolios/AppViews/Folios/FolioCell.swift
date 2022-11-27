//
//  FolioCell.swift
//  MenYou
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
    
    let colorratio = 150/255.0
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "magazine")
                .foregroundColor(Color.accentColor)
            VStack(alignment: .leading) {
                HStack {
                    Text(folio.title ?? "-")
                        .bold()
//                    Group {
//                        Circle()
//                            .frame(width: 7, height: 7)
//                        Text("\(folio.modified ?? .now, style: .date)")
//                            .font(.caption)
//                    }
                }
                .foregroundColor(Color.accentColor)

                Text(folio.desc ?? "-")
                    .font(.caption.italic())
                    .lineLimit(2)
                    .padding(.bottom, 2)
                FolioCardItems(folio: folio)
                FolioTagItems(folio: folio)
                HStack {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "doc.richtext")
                            Text("\(folio.assets?.count ?? 0)")
                        }
                    }
                    
                    Spacer()
                    Button {
                    } label: {
                        HStack {
                            Image(systemName: "tag")
                            Text("\(folio.tags?.count ?? 0)")
                        }
                    }
                    
                    Spacer()
                    
                }
                .buttonStyle(.plain)
                .foregroundColor(.gray)
            }
        }
        .padding(5)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.sRGB, red: colorratio, green: colorratio, blue: colorratio, opacity: 1.0), lineWidth: 1)
        )
    }
    
}

struct FolioCell_Previews: PreviewProvider {
    static var previews: some View {
        //FolioCell(folio: Binding(Tag.emptyFolio()) )
        EmptyView()
    }
}
