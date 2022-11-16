//
//  FolioTemplCell.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/26/22.
//

import SwiftUI

struct FolioTemplCell: View {
    var template: FolioTemplate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("\(template.title)").font(.subheadline)
            Text("\(template.desc)").font(.caption)
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "doc.richtext")
                    Text("\(template.assets?.count ?? 0)")
                }
            }
        }
    }
}

struct FolioTemplCell_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
