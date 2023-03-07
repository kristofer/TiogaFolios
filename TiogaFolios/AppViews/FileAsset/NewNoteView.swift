//
//  NewNoteView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 3/7/23.
//

import SwiftUI

struct NewNoteView: View {
    @ObservedObject var vm : FileAssetDetailVM
    @State var contentText: String = ""
    
    @Binding var activeSheet: ActiveSheet?

    var folio: Folio

    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        self.folio = folio
        let newasset = Asset.makeNewTextDoc(named: "", content: "")
        folio.addToAssets(newasset)
        //Storage.shared.save()
        vm = FileAssetDetailVM(anAsset: newasset, showAssignTo: false)
    }

    
    var body: some View {
        HStack {
            Text("Editing...")
                .font(.caption)
            Spacer()
            Button(action: {
                activeSheet = nil
                if vm.fileasset.title == "", let firstParagraph = contentText.components(separatedBy: CharacterSet.newlines).first {
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
            .border(.gray)
            .padding(2)
    }
}


struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
