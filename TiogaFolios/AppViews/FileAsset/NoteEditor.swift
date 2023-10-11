//
//  NoteEditor.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 10/10/23.
//

import SwiftUI

final class NoteEditorVM: ObservableObject {
    
}

struct NoteEditor: View {
    @Binding var fileasset: Asset

    @State var contentText: String = ""

    
    // this turned out to be a BAD idea
    var body: some View {
        Form {
            TextEditor(text: $contentText)
                .border(.gray)
                .padding(2)
        }
        .onSubmit {
                fileasset.setBlob(contentText.data(using: .utf8)!)
            }
            .onAppear(){
                self.contentText = String(decoding: fileasset.blob!, as: UTF8.self)
            }
    }
}

struct NoteEditor_Previews: PreviewProvider {
    static var previews: some View {
        //NoteEditor()
        EmptyView()
    }
}
