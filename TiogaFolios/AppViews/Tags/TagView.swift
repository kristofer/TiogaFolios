//
//  TagView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import SwiftUI

struct TagView: View {
    // @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var tag: Tag

    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0){
            Text(tag.title ?? "?wha?")
                .font(.title2)
            Text(tag.desc ?? " ")
                .font(.body)
            HStack{
                Label(tag.kind ?? TagKind.plain.rawValue,
                      systemImage: tag.imgtxtFor(tagkind: TagKind(rawValue: tag.kind ?? TagKind.plain.rawValue) ?? TagKind.plain))
                    .font(.body)
                
            }
            HStack{
                Label(tag.category ?? "n/a",
                      systemImage: tag.imgtxtForCat(tagcat: tag.category ?? ""))
                    .font(.body)
                
            }
            HStack{
//                Text(tag.modified!, style: .date)
//                    .font(.body)
//                Text(tag.modified!, style: .time)
//                    .font(.body)
            }
            Text(String(describing: tag.id!) )
                .font(.caption2)
                .padding(10.0)
            Button("Edit...") {
                isEditing = true
            }
        }
        .padding()
        .navigationTitle("")
        .sheet(isPresented: $isEditing) {
            TagEditView(objectPassed: tag, show: $isEditing)
        }
        Spacer()

    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: Tag())
    }
}
