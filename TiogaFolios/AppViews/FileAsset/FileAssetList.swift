//
//  ContentView.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/11/22.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers
import os

class FileAssetViewModel: ObservableObject {
    @Published var docs = [Asset]()
    
    func fetchData() {
        self.docs = Asset.fetchUnassignedAssets(vc: Storage.privdb.vc())
    }
    
}

struct FileAssetList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var vm = FileAssetViewModel()

    @State private var showNewDoc = false
    @State private var isImporting: Bool = false
    @State private var showAlert: Bool = false
    @State private var showError: Error? = nil
    @State private var errormsg = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.docs) { doc in
                    NavigationLink(
                        destination: FileAssetDetail(anAsset: doc)) { //doc: doc)) {
                            Label("\(String(describing: (doc.title ?? "nil doc name")))", systemImage: iconFor(doc))
                        }
                }
                .onDelete(perform: deleteDocs)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action:  {
                        isImporting = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isImporting = true
                        }
                    }) {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                    }
                    
                }
            }
#if os(iOS)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
#else
            // mac desktop
#endif
            
            Text("Select a document")
        }
        .onAppear(perform: {
                 vm.fetchData()
              })
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.content, UTType.compositeContent],
            allowsMultipleSelection: false
        ) { result in do {
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
                let fileasset = Asset(vc: viewContext, title: selectedFile.lastPathComponent,
                                      path: selectedFile.absoluteString,
                                      mimetype: UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType(),
                                      uttype: typeID)
                fileasset.setBlob(blob)
                Storage.privdb.save()
            }
        } catch {
            // Handle failure.
            print(error.localizedDescription)
            showAlert = true
            showError = error
        }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Unable to Archive File"),
                  message: Text("\(showError!.localizedDescription) \(self.errormsg)"),
                  dismissButton: .default(Text("Ok")))
        }
    }
    
    func didDismiss() {
        showNewDoc = false
    }
    
    private func iconFor(_ doc: Asset) -> String {
        if let mimetype = doc.mimetype {
            if mimetype == "text/html"{
                return "bookmark"
            }
            if mimetype == "text/plain"{
                return "doc.plaintext"
            }
            if mimetype.contains("image") {
                return "photo"
            }
        }
        return "doc.richtext"
    }
    
    private func deleteDocs(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.docs[$0] }.forEach(viewContext.delete)
            Storage.privdb.save()
        }
    }
}

struct FileAssetList_Previews: PreviewProvider {
    static var previews: some View {
        FileAssetList()
    }
}
