//
//  FileAssetDetail.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/11/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import os

@MainActor final class FileAssetDetailVM: ObservableObject {
    //    private static let logger = Logger(
    //        subsystem: "co.tioga.TiogaFolios",
    //        category: String(describing: FileAssetDetailVM.self)
    //    )
    
    @Published var fileasset: Asset = .init()
    @Published private(set) var isSaving = false
    @Published var isImporting: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Error? = nil
    @Published var errormsg = ""
    @Published var showAssign: Bool = false
    
    @Published var tempFile: TemporaryFile
    @Published var isBlobEmpty = false
    private let context = Storage.privdb.container.viewContext
    
    init(anAsset: Asset, showAssignTo: Bool) {
        fileasset = anAsset
        let fname = "tempfile." + (UTType(anAsset.uttype!)?.preferredFilenameExtension ?? "txt")
        tempFile = try! TemporaryFile(creatingTempDirectoryForFilename: fname)
        
        loadTempFile()
        //
        print("KKYY showing assignto \(showAssignTo)")
        showAssign = showAssignTo
    }
    
    func loadTempFile() {
        print("KKYY loadTempFile \(fileasset.title!) \(tempFile.fileURL)")
        do {
            let blob = fileasset.blob
            if fileasset.blobSize() <= 0 {
                isBlobEmpty = true
            } else {
                isBlobEmpty = false
            }
            try blob!.write(to: tempFile.fileURL)
        } catch {
            Foundation.NSLog("KKYY \(error.localizedDescription)")
        }
    }
    func recorderror(_ s: String) {
        Foundation.NSLog("KKYY \(s)")
    }
    
}

struct FileAssetDetail: View {
    
    @StateObject private var vm : FileAssetDetailVM
    @Environment(\.dismiss) var dismiss
    @State private var isEditing: Bool = false
    @State private var contentText: String = ""
    @State private var isEditingMetadata = false

    init(anAsset: Asset, showAssignTo: Bool) {
        _vm = StateObject(wrappedValue: FileAssetDetailVM(anAsset: anAsset,
                                                          showAssignTo: showAssignTo))
    }
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text(vm.fileasset.desc ?? "")
                        .font(.caption)
                        .padding()
                    Spacer()
                    Button {
                        self.isEditingMetadata = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                        .sheet(isPresented: $isEditingMetadata) {
                            FileAssetDeltaView(objectPassed: vm.fileasset, show: $isEditingMetadata)
                        }

                }
                .padding(5.0)
                
                if vm.showAssign == true {
                    NavigationLink("AssignTo", destination: ChooseFolio(asset: vm.fileasset) )
                }
                Divider()
                if vm.isBlobEmpty {
                    Button(action:  {
                        vm.isImporting = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            vm.isImporting = true
                        }
                    }) {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                    }
                } else {
                    FileAssetPreview(fileUrl: $vm.tempFile.fileURL).padding()
                }
            }
            //Spacer()
            HStack{
                Text("Metadata: \(vm.fileasset.mimetype!)")
                    .font(.caption)
                Spacer()
                if vm.fileasset.isDocumentEditable() == true {
                    Button(action: {
                        contentText = String(decoding: vm.fileasset.blob!, as: UTF8.self)
                        isEditing = true
                    }) {
                        Text(Image(systemName: "square.and.pencil"))
                    }
                    .font(.caption)
                    .padding(5.0)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .padding(5.0)
            .sheet(isPresented: $isEditing, onDismiss: {}, content: {
                HStack {
                    Spacer()
                    Button(action: {
                        isEditing = false
                        vm.fileasset.setBlob(contentText.data(using: .utf8)!)
                        vm.fileasset.touch()
                        //try? viewContext.save()
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
                .padding()
                TextEditor(text: $contentText)
            })
            
            //            Text("Modified: \(vm.fileasset.modified!, formatter: assetFormatter) Archived: \(vm.fileasset.archivedate!, formatter: assetFormatter)")
            //                .font(.caption)
        }
        .onDisappear() {
            do {
                try vm.tempFile.deleteDirectory()
                //print("KK deleted temp files")
            } catch {
                vm.recorderror("\(error.localizedDescription)")
            }
        }
        .fileImporter(
            isPresented: $vm.isImporting,
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
                vm.errormsg = "error: unable to archive an RTFD file, \(selectedFile)"
                print("error: found an RTFD file",selectedFile,range3)
            } else {
                print("continue")
            }
            
            let blob = try Data(contentsOf: selectedFile) as Data?
            
            let typeID = try selectedFile.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
            
            selectedFile.stopAccessingSecurityScopedResource()
            
            if let typeID = typeID, let blob = blob {
                vm.fileasset.pathname = selectedFile.absoluteString
                vm.fileasset.setBlob(blob)
                vm.fileasset.mimetype = UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType()
                vm.fileasset.uttype = typeID
                vm.fileasset.touch()
                Storage.privdb.save()
                vm.isBlobEmpty = false
                vm.loadTempFile()
            }
        } catch {
            // Handle failure.
            print(error.localizedDescription)
            vm.showAlert = true
            vm.showError = error
        }
            
        }
        
        .navigationTitle("\(vm.fileasset.title!)")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
}

private let assetFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct FileAssetDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        
    }
}
