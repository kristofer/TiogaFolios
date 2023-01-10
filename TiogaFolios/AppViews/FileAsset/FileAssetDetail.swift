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
        
        //
        //print("TFdebug showing assignto \(showAssignTo)")
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
        //print("TFdebug loadTempFile \(fileasset.title!) \(tempFile.fileURL)")
        do {
            let blob = fileasset.blob
            if fileasset.blobSize() <= 0 {
                isBlobEmpty = true
            } else {
                isBlobEmpty = false
            }
            try blob!.write(to: tempFile.fileURL)
            if fileasset.thumbnail == nil {
                fileasset.thumbnailCreate(tempFile.fileURL)
                Storage.shared.save()
            }
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
    @State var isEditing: Bool = false
    @State var isEditingMetadata = false
    
    init(anAsset: Asset, showAssignTo: Bool) {
        _vm = StateObject(wrappedValue: FileAssetDetailVM(anAsset: anAsset,
                                                          showAssignTo: showAssignTo))
    }
    
    var body: some View {
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
//                        .padding(5.0)
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
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
                
                //                if vm.showAssign == true {
                //                    NavigationLink("AssignTo", destination: ChooseFolio(asset: vm.fileasset) )
                //                }
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
                    if vm.fileasset.isDocumentWebpage() {
                        WebView(url: URL(string: vm.fileasset.pathname ?? "https://tiogadigital.com")!)
                            .padding(2)
                    } else {
                        FileAssetPreview(tFile: vm.tempFile)
                            .padding(2)
                    }
                }
            }
            Spacer()
            HStack{
                Text("Filetype: \(vm.fileasset.mimetype!)")
                    .font(.caption)
                Spacer()
            }
            .padding(5.0)
            .sheet(isPresented: $isEditing, onDismiss: { vm.resetTempFile() }, content: {
                NoteEditView(vm: vm, isEditing: $isEditing, contentText: String(decoding: vm.fileasset.blob!, as: UTF8.self))
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
