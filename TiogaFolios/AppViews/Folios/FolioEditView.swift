//
//  FolioEditView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import SwiftUI


struct FolioEditView: View {
    @ObservedObject var folio: Folio
    @Environment(\.presentationMode) var presentationMode
    
    @State var descriptiontext = "Edit Description Here..."
    
    var body: some View {
        NavigationView {

        VStack{
            TextField(
                "Folio name:",
                text: Binding($folio.title)!,
                onCommit: {}
            )
                .padding()
                .border(Color.gray)
                .navigationBarTitle(Text("Edit Folio..."), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        //tfDebug("Dismissing folio edit view...")
                        folio.desc = self.descriptiontext
                        folio.touch()
                        Storage.shared.save()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done").bold()
                    })
            Spacer()
            // description editor
            TextEditor(text: $descriptiontext)
                .padding()
                .border(Color.gray)
                .onAppear() {
                    self.descriptiontext = folio.desc ?? "Edit Description Here..."// getOrCreateFolioDescription(vc: PersistenceController.shared.vc)
                }
            //Text(String(describing: folio.id!) )
            //Text(String(describing: folio.kind))
//            HStack{
//                Label("As of \(folio.modified!, style: .date), \(folio.modified!, style: .time)", systemImage: "folder")
//            }
        }
        .padding()
        }
    }
}

struct FolioEditView_Previews: PreviewProvider {
    static var previews: some View {
        FolioEditView(folio: Folio())
    }
}
