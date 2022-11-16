//
//  AttachDocs.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/14/21.
//

import SwiftUI

struct AttachDocs: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var folio: Folio
    @ObservedObject var vm = FileAssetViewModel()
    
    var body: some View {
        NavigationView {
            List (vm.docs) { doc in
                    Button(action: {
                        folio.attachAsset(doc)
                        folio.objectWillChange.send()
                        self.presentationMode.wrappedValue.dismiss()
                        Storage.privdb.save()
                    }) { //doc: doc)) {
                        Label("\(String(describing: (doc.title ?? "nil doc name")))", systemImage: "doc.richtext")
                    }
            
            }
            Text("Select a document")
        }
        .onAppear(perform: {
                 vm.fetchData()
              })
    }
    
    func isMember(_ tag: Asset) -> Bool {
        return false
    }
}

struct AttachDocs_Previews: PreviewProvider {
    static var previews: some View {
        //AttachDocs()
        EmptyView()
    }
}
