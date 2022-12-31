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
            Text("Editing...")
                .font(.caption)
            Spacer()
            Button(action: {
                isEditing = false
                vm.fileasset.setBlob(contentText.data(using: .utf8)!)
                vm.fileasset.lastmodified = Date()
                vm.fileasset.touch()
                Storage.shared.save()
                vm.resetTempFile()
            }) {
                Text("Save ")+Text(Image(systemName: "square.and.arrow.down"))
            }
            .font(.caption)
            .padding(5.0)
            .foregroundColor(.white)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
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
            //.onAppear(perform: { UITextView.appearance().backgroundColor = .clear })
            .border(.gray)
            .padding(2)
    }
}

struct NoteEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
