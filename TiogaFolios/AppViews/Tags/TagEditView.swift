//
//  TagEditView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/14/21.
//

import SwiftUI
class DeltaTagVm: ObservableObject {
    //@Binding var showNewTag: Bool
    @Published var tag: Tag
    @Published var selectedTagKind = TagKind.plain
    @Published var selectedTagCat = TagCat.user
    var ttitle: String
    var creating = false
    
    init(objectPassed: Tag? = nil) {
        if objectPassed == nil {
            creating = true
            tag = Tag.createTag(vc: Storage.shared.vc, named: "NewTag", kind: .plain)
            ttitle = "Creating New Tag"
        } else {
            creating = false
            tag = objectPassed!
            ttitle = "Editing Tag"
        }
    }
    
    func cancel() {
        if creating {
                tag.managedObjectContext?.delete(tag)
        }
    }

}


struct TagEditView: View {

//    enum FocusField: Hashable {
//      case field
//    }


    @ObservedObject var vm: DeltaTagVm
    @Binding var isPresented: Bool
//    @FocusState private var focusedField: FocusField?
    init(objectPassed: Tag? = nil, show: Binding<Bool>) {
        if objectPassed == nil {
            vm = DeltaTagVm()
            self._isPresented = show
        } else {
            vm = DeltaTagVm(objectPassed: objectPassed)
            self._isPresented = show
        }
    }


    var body: some View {
        Form(content: {
            Section(header: Text("Tag Metadata")) {
                // Text field
                TextField("Name", text: Binding($vm.tag.title, ""))
//                TextField("Description", Binding(vm.tag?.desc?, ""))
                //TextField("Name", text: ((vm.tag).title?) ?? "")
                //TextField("Description", (vm.tag?).desc?)
                Picker(vm.tag.kind!, selection: $vm.selectedTagKind ) {
                    ForEach(TagKind.allCases) { kind in
                        Text(kind.rawValue.capitalized).tag(kind)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                Text("leave as user for now")
                Picker(vm.tag.category!, selection: $vm.selectedTagCat ) {
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
                    vm.tag.kind = vm.selectedTagKind.rawValue
                    vm.tag.touch()
                    Storage.shared.save()
                    isPresented = false
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
        .navigationBarTitle(vm.ttitle)
        .onDisappear(perform: {
            //vm.cancel()
        })
    }
}

struct TagEditView_Previews: PreviewProvider {
    static var previews: some View {
        //TagNewView(showNewTag: Binding(true))
        EmptyView()
    }
}
