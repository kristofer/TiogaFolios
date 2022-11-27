//
//  FolioTagItems.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/19/22.
//

import SwiftUI

struct FolioTagItems: View {
    @ObservedObject var folio: Folio
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            LazyHStack {
                Label(" ", systemImage: "tag")
                ForEach(Array(folio.tags as? Set<Tag> ?? []), id: \.self) { tag in
                    Text(tag.title ?? "??")
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 1)
                        )
                        .padding(1)
                }
            }
        }.frame(height: 28)
    }
}

struct FolioTagItems_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        
    }
}
