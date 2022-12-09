//
//  NoteEditView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/9/22.
//

import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
struct NoteEditView: View {
    @ObservedObject var vm : FileAssetDetailVM
    @Binding var isEditing: Bool
    @State var contentText: String = ""

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                isEditing = false
                vm.fileasset.setBlob(contentText.data(using: .utf8)!)
                vm.fileasset.touch()
                Storage.privdb.save()
            }) {
                Text("Save ")+Text(Image(systemName: "square.and.arrow.down"))
            }
            .font(.caption)
            .padding(5.0)
            .foregroundColor(.white)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
        }
        VStack {
            TextField("Title", text: $vm.fileasset.title.toUnwrapped(defaultValue: ""))
                .padding(5)
            Divider()
            TextField("Description", text: $vm.fileasset.desc.toUnwrapped(defaultValue: ""))
                .padding(5)
        }
        Divider()
        TextEditor(text: $contentText)
            .padding()
    }
}

struct NoteEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
