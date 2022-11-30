//
//  FolioView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers
import os

struct FolioView: View {
    @ObservedObject var folio: Folio
    
    @State private var isEditing = false
    @State private var addingItems = false
    @State private var showTagSelection = false
    
    @State private var isImporting: Bool = false
    @State private var showAlert: Bool = false
    @State private var showError: Error? = nil
    @State private var errormsg = ""
    @State private var message: Message? = nil
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(folio.desc ?? "-")
                    .font(.body.italic())
                Spacer()
                Menu("Actions") {
                    Button("Edit Folio Name...", action: editfolio)
                    Button("Change Tags...") {
                        self.showTagSelection = true
                    }
                    Button("Add to Folio...", action: addtofolio)
                    Button("Share Folio...", action: sharefolio)
                }.alert(item: $message) { message in
                    Alert(
                        title: Text(message.text),
                        dismissButton: .cancel()
                    )
                }
                .background(
                    NavigationLink(destination: ContentTagView(item: folio), isActive: $showTagSelection) {
                        EmptyView()
                    })
                
            }
            
            Divider()
            FolioTagItems(folio: folio)
            Divider()
            
            Text("Attached Documents").font(.caption2.italic())
            List {
                ForEach(Array(folio.assets as? Set<Asset> ?? []), id: \.self) { doc in
                    NavigationLink(
                        destination: FileAssetDetail(anAsset: doc, showAssignTo: false)) { //doc: doc)) {
                            Label("\(String(describing: (doc.title ?? "nil doc name")))", systemImage: "doc.richtext")
                        }
                }
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType.content, UTType.compositeContent],
                allowsMultipleSelection: false
            ) { result in
                importFile(result)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Unable to Archive File"),
                      message: Text("\(showError!.localizedDescription) \(self.errormsg)"),
                      dismissButton: .default(Text("Ok")))
            }
        }
        .padding()
        .navigationTitle(folio.title ?? "?wha?")
        //.foregroundColor(Color.accentColor)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditing) {
            FolioDeltaView(objectPassed: folio, show: $isEditing)
        }
    }
    
    func editfolio() { self.isEditing = true }

    func addtofolio() {
        self.isImporting = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isImporting = true
        }
    }

    func sharefolio() {
        self.message = Message(text: "share this folio...")
    }
    
    private func importFile(_ result: Result<[URL], Error> ) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            //trying to get access to url contents
            guard selectedFile.startAccessingSecurityScopedResource() else { return }
            //print(selectedFile)
            let teststr = selectedFile.absoluteString
            if let range3 = teststr.range(of: ".rtfd", options: .caseInsensitive) {
                // match
                self.errormsg = "error: unable to archive an RTFD file, \(selectedFile)"
                print("error: found an RTFD file",selectedFile,range3)
            } else {
                print("continue")
            }
            
            let blob = try Data(contentsOf: selectedFile) as Data?
            
            let typeID = try selectedFile.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
            
            selectedFile.stopAccessingSecurityScopedResource()
            
            if let typeID = typeID, let blob = blob {
                let viewContext = Storage.privdb.vc()
                let fileasset = Asset(vc: viewContext, title: selectedFile.lastPathComponent,
                                      path: selectedFile.absoluteString,
                                      mimetype: UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType(),
                                      uttype: typeID)
                fileasset.setBlob(blob)
                folio.addToAssets(fileasset)
                Storage.privdb.save()
                //vm.fetchData()
            }
        } catch {
            // Handle failure.
            print(error.localizedDescription)
            showAlert = true
            showError = error
        }
    }
    
}

struct FolioView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

