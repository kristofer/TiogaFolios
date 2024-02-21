//
//  TagCell.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 1/11/24.
//

import SwiftUI

struct TagCell: View {
    @ObservedObject var tag: Tag
    
    var body: some View {
        HStack {
            Label("\(String(describing: (tag.title ?? "No Tag Name")))",
                  systemImage: tag.imgtxtFor(tagkind: TagKind(rawValue: tag.kind!)!))
            Text(" - ")
            Text("\(String(describing: (tag.kind ?? "No Tag Type")))")
                .italic()
            //Text(tag.id?.uuidString ?? "no uuid")
        }
    }
}

#Preview {
    EmptyView()
}
