//
//  TagEditView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/14/21.
//

import SwiftUI
import CoreData


//class DeltaTagVM: ObservableObject {
//    //@Binding var showNewTag: Bool
//    //@Published var tag: Tag?
//    @Published var selectedTagKind = TagKind.plain
//    @Published var selectedTagCat = TagCat.user
//    @Published var tag: Tag?
//
//    var ttitle: String
//
//    var creating = false
//    var newTitle = "Untitled"
//    var newDesc = " - "
//    var newKind = TagKind.plain
//    var newCat = TagCat.user
//
//    init(objectPassed: Tag? = nil) {
//        if objectPassed == nil {
//            creating = true
//            ttitle = "Creating New Tag"
//            selectedTagKind = .plain
//            selectedTagCat = .user
//        } else {
//            creating = false
//            if let tag = objectPassed {
//                newTitle = tag.title!
//                newDesc = tag.desc!
//                newKind = TagKind(rawValue: (tag.kind!)) ?? .plain
//                selectedTagKind = newKind
//                newCat = .user
//                selectedTagCat = newCat
//                ttitle = "Editing Tag"
//            }
//        }
//    }
//
////    func cancel() {
////        if creating {
////            tfDebug("Delete tag created.")
////            if let tag = tag {
////                tag.managedObjectContext?.delete(tag)
////            }
////            Storage.shared.save()
////        }
////    }
//
//    func updateTag () {
//        if creating {
//            tfDebug("Tag created \(self.newTitle)")
//            tag = Tag.createTag(vc: Storage.shared.vc, named: self.newTitle, kind: self.newKind)
//            tag!.desc = self.newDesc
//        } else {
//            if self.tag != nil {
//                tag!.title = newTitle
//                tag!.desc = newDesc
//                tag!.kind = newKind.rawValue
//                tag!.category = newCat.rawValue
//            }
//        }
//    }
//}


struct TagEditView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var tag: Tag
    @Binding var isPresented: Bool
    @State var selectedTagKind: TagKind
    @State var selectedTagCat = TagCat.user

    init(objectPassed: Tag? = nil, show: Binding<Bool>) {
        self._isPresented = show

        if let tag = objectPassed {
            self.tag = tag
            _selectedTagKind = State<TagKind>(initialValue: TagKind.withLabel(tag.kind ?? "meta")!)
            tfDebug("TagEditView editing \(String(describing: self.selectedTagKind))")
            self.selectedTagCat = TagCat(rawValue: tag.category!) ?? TagCat.user
            self._isPresented = show
            return
        }

        tfDebug("TagEditView nil of Edit")
        self.tag = Tag.createTag(vc: Storage.shared.vc, named: "untitled", kind: .plain)
        _selectedTagKind = State<TagKind>(initialValue: TagKind.withLabel("plain")!)
    }

    
    var body: some View {
        //Text("TagEditView")
        Form(content: {
//            Section{
            Button(action: {
                tag.kind = selectedTagKind.rawValue
                tag.category = TagCat.user.rawValue
                Storage.shared.save()
//                isPresented = false
                dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Save Tag")
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
                
//            }

            Section(header: Text("Tag Details")) {
                // Text field
                TextField("Name", text: $tag.title.toUnwrapped(defaultValue: ""))
                    .font(.title)
                TextField("Description", text: $tag.desc.toUnwrapped(defaultValue: ""))
                    .font(.title2).italic()
                Picker("Kind", selection: $selectedTagKind ) {
                    ForEach(TagKind.allCases) { kind in
                        Text(kind.rawValue.capitalized).tag(kind)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
//            Section {
//                // Button
//                Spacer()
//                Button(action: {
//                    Tag.loadAppTags()
//                }) {
//                    HStack {
//                        Spacer()
//                        Text("Add Application Tags")
//                        Spacer()
//                    }
//                }
//                .foregroundColor(.white)
//                .padding(10)
//                .background(Color.secondary)
//                .cornerRadius(8)
//            }
//
        })
    }
}


struct TagEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
