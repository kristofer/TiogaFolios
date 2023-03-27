//
//  NewNoteView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 3/7/23.
//

import SwiftUI

struct NewNoteView: View {
    enum FocusedField {
        case editor
    }

    @ObservedObject var vm : FileAssetDetailVM
    @State var contentText: String = ""
    
    @Binding var activeSheet: ActiveSheet?

    var folio: Folio

    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        self.folio = folio
        let newasset = Asset.makeNewTextDoc(named: "", content: "")
        folio.addToAssets(newasset)
        vm = FileAssetDetailVM(anAsset: newasset, showAssignTo: false)
    }

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        HStack {
            Text("Add a New Text Note...")
                .font(.caption)
            Spacer()
            Button(action: {
                activeSheet = nil
                if vm.fileasset.title == "",
                    let firstParagraph = contentText.components(separatedBy: CharacterSet.newlines).first {
                    vm.fileasset.title = String(firstParagraph.prefix(20))
                }
                vm.fileasset.setBlob(contentText.data(using: .utf8)!)
                vm.fileasset.lastmodified = Date()
                vm.fileasset.touch()
                Storage.shared.save()
                vm.resetTempFile()
            }) {
                Text("Save ")+Text(Image(systemName: "square.and.arrow.down"))
            }
            .font(.caption)
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        VStack {
            TextField("Title", text: $vm.fileasset.title.toUnwrapped(defaultValue: ""))
                .padding(5)
            Divider()
            TextField("Description", text: $vm.fileasset.desc.toUnwrapped(defaultValue: ""))
                .padding(5)
        }
        Divider()
        TextEditor(text: $contentText)
            .focused($focusedField, equals: .editor)
            .border(.gray)
            .padding(2)
            .onAppear {
                focusedField = .editor
            }
    }
}


struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
