//
//  TagEditView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/14/21.
//

import SwiftUI

struct TagEditView: View {

    @Binding var showNewTag: Bool
    @State var currentTag: Tag
    @State private var selectedTagKind = TagKind.plain
    @State private var selectedTagCat = TagCat.user

    var body: some View {
        Form(content: {
            Section(header: Text("Tag Metadata")) {
                // Text field
                TextField("Name", text: Binding($currentTag.title, "Untitled"))
                TextField("Description", text: Binding($currentTag.desc, ""))
                Picker(currentTag.kind!, selection: $selectedTagKind ) {
                    ForEach(TagKind.allCases) { kind in
                        Text(kind.rawValue.capitalized).tag(kind)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                Text("leave as user for now")
                Picker(currentTag.category!, selection: $selectedTagCat ) {
                    ForEach(TagCat.allCases) { cat in
                        Text(cat.rawValue.capitalized).tag(cat)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(true)
            }
            Section {
                // Button
                Button(action: {
                    currentTag.kind = selectedTagKind.rawValue
                    currentTag.touch()
                    Storage.privdb.save()
                    showNewTag = false
                }) {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.accentColor)
                .cornerRadius(8)
                Spacer()
                Button(action: {
                    Tag.loadAppTags()
                }) {
                    HStack {
                        Spacer()
                        Text("Add Application Tags")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.secondary)
                .cornerRadius(8)

            }

        })
        .navigationBarTitle("Add a New Tag")
        .onDisappear(perform: {
            print("save tag")
        })
    }
}

struct TagEditView_Previews: PreviewProvider {
    static var previews: some View {
        //TagNewView(showNewTag: Binding(true))
        EmptyView()
    }
}
