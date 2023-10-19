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

    @ObservedObject var tag: Tag
    @Binding var isPresented: Bool
    @State var selectedTagKind = TagKind.plain
    @State var selectedTagCat = TagCat.user

//    @FocusState private var focusedField: FocusField?
    init(objectPassed: Tag? = nil, show: Binding<Bool>) {
        self._isPresented = show
        tfDebug("TagEditView editing \(String(describing: objectPassed?.title))")
        if let tag = objectPassed {
            self.tag = tag
            self.selectedTagKind = TagKind(rawValue: tag.kind!) ?? TagKind.plain
            self.selectedTagCat = TagCat(rawValue: tag.category!) ?? TagCat.user
            self._isPresented = show
            return
        }

        tfDebug("TagEditView nil of Edit")
        self.tag = Tag.createTag(vc: Storage.shared.vc, named: "untitled", kind: .plain)
    }


    var body: some View {
        Form(content: {
            Section(header: Text("Tag Metadata")) {
                // Text field
                TextField("Name", text: $tag.title.toUnwrapped(defaultValue: ""))
                TextField("Description", text: $tag.desc.toUnwrapped(defaultValue: ""))
                Picker("Kind", selection: $selectedTagKind ) {
                    ForEach(TagKind.allCases) { kind in
                        Text(kind.rawValue.capitalized).tag(kind)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            Section {
                // Button
                Button(action: {
                    tag.kind = selectedTagKind.rawValue
                    tag.category = TagCat.user.rawValue
                    Storage.shared.save()
                    isPresented = false
                }) {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
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
        .navigationBarTitle("Changing Tag")
    }
}
//struct TagEditView: View {
//
//    @ObservedObject var vm: DeltaTagVM
//    @Binding var isPresented: Bool
//
////    @FocusState private var focusedField: FocusField?
//    init(objectPassed: Tag? = nil, show: Binding<Bool>) {
//        if objectPassed == nil {
//            tfDebug("TagEditView nil of Edit")
//
//            self.vm = DeltaTagVM()
//            self._isPresented = show
//        } else {
//            tfDebug("TagEditView editing \(String(describing: objectPassed?.title))")
//
//            vm = DeltaTagVM(objectPassed: objectPassed)
//            self._isPresented = show
//        }
//    }
//
//
//    var body: some View {
//        Form(content: {
//            Section(header: Text("Tag Metadata")) {
//                // Text field
//                TextField("Name", text: $vm.newTitle) //Binding($vm.newTitle, ""))
//                TextField("Description", text: $vm.newDesc) //Binding(vm.tag?.desc?, ""))
//
//                Picker(vm.newKind.rawValue, selection: $vm.selectedTagKind ) {
//                    ForEach(TagKind.allCases) { kind in
//                        Text(kind.rawValue.capitalized).tag(kind)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//            }
//            Section {
//                // Button
//                Button(action: {
//                    vm.updateTag()
//                    Storage.shared.save()
//                    isPresented = false
//                }) {
//                    HStack {
//                        Spacer()
//                        Text("Save")
//                        Spacer()
//                    }
//                }
//                .buttonStyle(.borderedProminent)
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
//
//            }
//
//        })
//        .navigationBarTitle(vm.ttitle)
//    }
//}

struct TagEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
