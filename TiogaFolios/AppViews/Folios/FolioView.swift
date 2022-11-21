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
    @State private var navigateTo = ""
    @State private var isActive = false
    
    @State private var isImporting: Bool = false
    @State private var showAlert: Bool = false
    @State private var showError: Error? = nil
    @State private var errormsg = ""

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(folio.desc ?? "-")
                    .font(.body.italic())
                Spacer()
            }
            Divider()
            HStack{
//                Text("As of \(folio.modified ?? .now, style: .date), \(folio.modified ?? .now, style: .time)")
//                    .font(.caption)
                Spacer()
                Button("Edit...") {
                    isEditing = true
                }
                
            }
            .font(.caption)
            
            NavigationLink(destination: ContentTagView(item: folio)) {
                HStack {
                    FolioTagItems(folio: folio)
                    Spacer()
                    Text("Tags...")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.accentColor)
                        .cornerRadius(5)
                }
            }
            Divider()
            HStack {
                Text("Attached Documents").font(.caption2.italic())
                Spacer()
                Button(action:  {
                    isImporting = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isImporting = true
                    }
                })
                {
                    HStack {
                        Text("Add").font(.caption)
                        Image(systemName: "plus").font(.caption)
                    }
                }
            }
            Divider()
            //NavigationView {
                List {
                    ForEach(Array(folio.assets as? Set<Asset> ?? []), id: \.self) { doc in
                        NavigationLink(
                            destination: FileAssetDetail(anAsset: doc)) { //doc: doc)) {
                                Label("\(String(describing: (doc.title ?? "nil doc name")))", systemImage: "doc.richtext")
                            }
                    }
                }
                //.navigationBarTitle("Contents", displayMode: .inline)
                .toolbar{
                    ToolbarItem {
//                        NavigationLink(
//                            destination: AttachDocs(folio: folio)
//                        )
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

                
            //}
        }
        .padding()
        .navigationTitle(folio.title ?? "?wha?")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditing) {
            FolioDeltaView(objectPassed: folio, show: $isEditing)
        }
    }
    
    func placeOrder() { }
    func adjustOrder() { }
    
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

//struct DemoNavigateFromMenu: View {
//    @State private var navigateTo = ""
//    @State private var isActive = false
//    var body: some View {
//        NavigationView {
//            Menu {
//                Button("item1") {
//                    self.navigateTo = "test1"
//                    self.isActive = true
//                }
//                Button("item2") {
//                    self.navigateTo = "test2"
//                    self.isActive = true
//                }
//            } label: {
//                Label("Add", systemImage: "plus")
//            }
//            .background(
//                NavigationLink(destination: Text(self.navigateTo), isActive: $isActive) {
//                    EmptyView()
//                })
//        }
//    }
//}
