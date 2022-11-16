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
    private static let logger = Logger(
        subsystem: "com.tiogadigital.halfroll",
        category: String(describing: FileAssetDetailVM.self)
    )
    
    @Published var fileasset: Asset = .init()
    @Published private(set) var isSaving = false
    @Published var isImporting: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Error? = nil
    @Published var errormsg = ""

    @Published var tempFile: TemporaryFile
    @Published var isBlobEmpty = false
    private let context = Storage.privdb.container.viewContext
    
    init(anAsset: Asset) {
        fileasset = anAsset
        let fname = "tempfile." + (UTType(anAsset.uttype!)?.preferredFilenameExtension ?? "txt")
        tempFile = try! TemporaryFile(creatingTempDirectoryForFilename: fname)

        loadTempFile()
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
            Self.logger.error("KKYY \(error.localizedDescription, privacy: .public)")
        }
    }
    func recorderror(_ s: String) {
        Self.logger.error("\(s, privacy: .public)")
    }
    
}

struct FileAssetDetail: View {
    
    @StateObject private var vm : FileAssetDetailVM
    @Environment(\.dismiss) var dismiss
    
    init(anAsset: Asset) {
        _vm = StateObject(wrappedValue: FileAssetDetailVM(anAsset: anAsset))
    }
    
    var body: some View {
        VStack{
        VStack{
            //Text("\(vm.fileasset.title!)").bold()
            Text("a description of the document")
                .font(.caption)//\(vm.fileasset.desc!)")
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
        Spacer()
            Text("Metadata: \(vm.fileasset.mimetype!)")
                .font(.caption)
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
        FileAssetDetail(anAsset: Asset.sampleAsset())
    }
}
