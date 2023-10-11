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
    @Environment(\.managedObjectContext) var moc
        
    @Binding var fileasset: Asset
    @Binding var isEditing: Bool
    @State var contentText: String = ""

    let tracker = InstanceTracker("NoteEditView")
    
    var body: some View {
        tracker {
            VStack {
                HStack {
                    Text("Editing...")
                        .font(.caption)
                    Spacer()
                    Button(action: {
                        isEditing = false
                        fileasset.setBlob(contentText.data(using: .utf8)!)
                        fileasset.lastmodified = Date()
                        fileasset.touch()
                        do {
                            try moc.save()
                        } catch {
                            tfDebug(error)
                        }
                    }) {
                        Text("Save ")+Text(Image(systemName: "square.and.arrow.down"))
                    }
                    .font(.caption)
                    .buttonStyle(.borderedProminent)
                    
                }
                .padding()
                VStack {
                    TextField("Title", text: $fileasset.title.toUnwrapped(defaultValue: ""))
                        .padding(5)
                    Divider()
                    TextField("Description", text: $fileasset.desc.toUnwrapped(defaultValue: ""))
                        .padding(5)
                }
                Divider()
                TextEditor(text: $contentText)
                    .border(.gray)
                    .padding(2)
                    .onAppear(){
                        self.contentText = String(decoding: fileasset.blob!, as: UTF8.self)
                    }
            }
        }
        
    }
}

struct NoteEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
