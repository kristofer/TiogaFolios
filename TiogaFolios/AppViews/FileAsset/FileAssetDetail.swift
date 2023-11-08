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

final class FileAssetDetailVM: ObservableObject {
    
    @Published var fileasset: Asset = .init()
    @Published private(set) var isSaving = false
    @Published var isImporting: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Error? = nil
    @Published var errormsg = ""
    @Published var showAssign: Bool = false
    
    @Published var tempFile: TemporaryFile
    @Published var isBlobEmpty = false
    
    init(anAsset: Asset, showAssignTo: Bool) {
        fileasset = anAsset
        let fname = "tempfile." + (UTType(anAsset.uttype!)?.preferredFilenameExtension ?? "txt")
        tempFile = try! TemporaryFile(creatingTempDirectoryForFilename: fname)
        
        showAssign = showAssignTo
    }
    
    func deleteTempFile() {
        do {
            try self.tempFile.deleteDirectory()
            Foundation.NSLog("TFdebug deleted temp files")
        } catch {
            self.recorderror("\(error.localizedDescription)")
        }
    }
    
    func resetTempFile() {
        deleteTempFile()
        let fname = "tempfile." + (UTType(fileasset.uttype!)?.preferredFilenameExtension ?? "txt")
        self.tempFile = try! TemporaryFile(creatingTempDirectoryForFilename: fname)
        
        Foundation.NSLog("TFdebug NEW temp file \(self.tempFile.fileURL.absoluteString)")
        
        loadTempFile()
        
    }
    
    func loadTempFile() {
        tfDebug("loadTempFile \(fileasset.title!) \(tempFile.fileURL)")
        do {
            let blob = fileasset.blob
            if fileasset.blobSize() <= 0 {
                isBlobEmpty = true
            } else {
                isBlobEmpty = false
            }
            try blob!.write(to: tempFile.fileURL)
//            if fileasset.thumbnail == nil {
                fileasset.thumbnailCreate(tempFile.fileURL)
                Storage.shared.save()
//            }
        } catch {
            Foundation.NSLog("TFdebug no loadTempFile \(error.localizedDescription)")
        }
    }
    
    func recorderror(_ s: String) {
        Foundation.NSLog("TFdebug recorderror \(s)")
    }
    
}

struct FileAssetDetail: View {
    
    @StateObject var vm : FileAssetDetailVM

    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var isEditing: Bool = false
    @State var isEditingMetadata = false
    
    
    let tracker = InstanceTracker("FileAssetDetail")
    var body: some View {
        tracker {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white)
                    .shadow(radius: 10)
                    .padding(5)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack{
                            Text(vm.fileasset.desc ?? "")
                                .font(.caption)
                                .padding()
                            Spacer()
                            if vm.fileasset.isDocumentEditable() {
                                Button(action: {
                                    isEditing = true
                                }) {
                                    Label("Edit ", systemImage: "square.and.pencil")
                                }
                                .font(.caption)
                                .buttonStyle(.borderedProminent)
                            } else {
                                Button {
                                    self.isEditingMetadata = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                }
                                .sheet(isPresented: $isEditingMetadata) {
                                    FileAssetDeltaView(objectPassed: vm.fileasset, show: $isEditingMetadata)
                                }
                            }
                            
                        }
                        .padding(2)
                        
                        Divider()
                        if vm.isBlobEmpty {
                            VStack {
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
                                MissingAssetView()
                            }
                            .padding()
                        } else {
                            if vm.fileasset.isDocumentWebpage() {
                                WebView(url: URL(string: vm.fileasset.pathname ?? "https://tiogadigital.com")!)
                                    .padding(2)
                            } else {
                                if vm.fileasset.isDocumentEditable() {
                                    if let actualBlob = vm.fileasset.blob {
                                        TextEditor(text: .constant(String(decoding: actualBlob, as: UTF8.self)))
                                    } else {
                                        Text("Empty Note")
                                    }
                                } else {
                                    FileAssetPreview(tURL: vm.tempFile.fileURL)
                                        .padding(2)
                                }
                            }
                        }
                    }
                    Spacer()
                    HStack{
                        if let mime = vm.fileasset.mimetype {
                            Text("Filetype: \(mime)")
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding(5.0)
                    .sheet(isPresented: $isEditing, onDismiss: { vm.resetTempFile() }, content: {
                        NoteEditView(fileasset: $vm.fileasset, isEditing: $isEditing)
                    })
                    
                }
                .onDisappear() {
                    vm.deleteTempFile()
                }
                .onAppear() {
                    vm.loadTempFile()
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
                        tfDebug("error: found an RTFD file",selectedFile,range3)
                    } else {
                        tfDebug("continue")
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
                        Storage.shared.save()
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
                //.navigationBarItems(trailing: EditButton())
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
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
