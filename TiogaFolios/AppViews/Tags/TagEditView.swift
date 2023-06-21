//
//  TagEditView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/14/21.
//

import SwiftUI
class DeltaTagVm: ObservableObject {
    //@Binding var showNewTag: Bool
    //@Published var tag: Tag?
    @Published var selectedTagKind = TagKind.plain
    @Published var selectedTagCat = TagCat.user
    var ttitle: String
    
    var tag: Tag?
    var creating = false
    var newTitle = "Untitled"
    var newDesc = " - "
    var newKind = TagKind.plain
    var newCat = TagCat.user

    init(objectPassed: Tag? = nil) {
        if objectPassed == nil {
            creating = true
            ttitle = "Creating New Tag"
        } else {
            creating = false
            tag = objectPassed!
            newTitle = tag?.title! ?? "unknown"
            newDesc = tag?.desc! ?? "unknown"
            newKind = TagKind(rawValue: (tag!.kind!)) ?? .plain
            newCat = .user
            ttitle = "Editing Tag"
        }
    }
    
//    func cancel() {
//        if creating {
//            tfDebug("Delete tag created.")
//            if let tag = tag {
//                tag.managedObjectContext?.delete(tag)
//            }
//            Storage.shared.save()
//        }
//    }

    func updateTag () {
        if creating {
            tfDebug("Tag created \(self.newTitle)")
            tag = Tag.createTag(vc: Storage.shared.vc, named: self.newTitle, kind: self.newKind)
            tag!.desc = self.newDesc
        } else {
            if let tag = self.tag {
                tag.title = newTitle
                tag.desc = newDesc
                tag.kind = newKind.rawValue
                tag.category = newCat.rawValue
            }
        }
    }
}


struct TagEditView: View {

    @ObservedObject var vm: DeltaTagVm
    @Binding var isPresented: Bool
    
//    @FocusState private var focusedField: FocusField?
    init(objectPassed: Tag? = nil, show: Binding<Bool>) {
        if objectPassed == nil {
            tfDebug("TagEditView nil of Edit")

            vm = DeltaTagVm()
            self._isPresented = show
        } else {
            tfDebug("TagEditView editing \(objectPassed?.title)")

            vm = DeltaTagVm(objectPassed: objectPassed)
            self._isPresented = show
        }
    }


    var body: some View {
        Form(content: {
            Section(header: Text("Tag Metadata")) {
                // Text field
                TextField("Name", text: $vm.newTitle) //Binding($vm.newTitle, ""))
                TextField("Description", text: $vm.newDesc) //Binding(vm.tag?.desc?, ""))

                Picker(vm.newKind.rawValue, selection: $vm.selectedTagKind ) {
                    ForEach(TagKind.allCases) { kind in
                        Text(kind.rawValue.capitalized).tag(kind)
                    }
                }
                .pickerStyle(WheelPickerStyle())
//                Text("leave as user for now")
//                Picker(vm.newCat.rawValue, selection: $vm.selectedTagCat ) {
//                    ForEach(TagCat.allCases) { cat in
//                        Text(cat.rawValue.capitalized).tag(cat)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .disabled(true)
            }
            Section {
                // Button
                Button(action: {
                    vm.updateTag()
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
//                .foregroundColor(.white)
//                .padding(10)
//                .background(Color.accentColor)
//                .cornerRadius(8)
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
        .navigationBarTitle(vm.ttitle)
    }
}

struct TagEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
