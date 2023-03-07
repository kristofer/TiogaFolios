//
//  ScannerView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 1/3/23.
//
import Foundation

import SwiftUI
import VisionKit
import PDFKit
import UniformTypeIdentifiers

class ScanViewModel: ObservableObject {
    
    @Published var camera: DocumentCamera
    
    init() {
        camera = DocumentCamera(
            cancelAction: { print("User did cancel") },
            resultAction: { result in
                print("Scanned \(result)")
            }             // Mandatory
        )
        
    }
    
}


struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var activeSheet: ActiveSheet?
    var folio: Folio
    
    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        self.folio = folio
    }
    
    @State var index = 0
    @State var scanArray = [Image]()
    @State var isScanning = false
    @State var hasScanned = false
    @State var pdfResult: Data?
    
    var body: some View {
        List {
            Section {
                Text("Scan a document into this folio.")
            }
            Section(header: Text("Actions")) {
                Button(action: openCamera) {
                    Text("Open Scanner")
                }
                .buttonStyle(.bordered)
                Button(action: savePDFtoFolio) {
                    Text("Save PDF")
                }
                .disabled(!hasScanned)
                .buttonStyle(.bordered)
            }

            if scanArray.count > 0 {
                Section(header: Text("Scans")) {
                    ForEach(0 ..< scanArray.count) { imageIdx in
                        scanArray[imageIdx]
                       .resizable()
                       .frame(width: 400, height: 600)
                       .aspectRatio(contentMode: .fit)
                    }
                }
            }
            
        }
        .navigationBarTitle("DocumentCamera")
        .sheet(isPresented: $isScanning, content: {
            DocumentCamera(
                cancelAction: dismissCamera,
                resultAction: handleResult)
            .edgesIgnoringSafeArea(.all)
        })
        
    }
    
    
    func createCamera() -> some View {
        DocumentCamera(
            cancelAction: dismissCamera,
            resultAction: handleResult)
        .edgesIgnoringSafeArea(.all)
    }
    
    func dismissCamera() {
        //sheetContext.dismiss()
        self.isScanning = false
    }
    
    func handleResult(_ result: DocumentCamera.CameraResult) {
        switch result {
        case .failure: dismissCamera()
        case .success(let scan): do {
            if scan.scans.count > 0 {
                hasScanned = true
            }
            saveImages(scan.scans)
            savePDF(scan.makePDFFromScans)
        }
        }
    }
    
    func openCamera() {
        //sheetContext.present(createCamera())
        self.isScanning = true
    }
    
    func savePDFtoFolio() {
        // save as fileasset
        let newAsset = Asset(vc: Storage.shared.vc, title: "Document Scan", path: "", mimetype: "com.adobe.pdf", uttype: UTType.pdf.identifier)
        newAsset.setBlob(pdfResult!)
        // attach to folio
        folio.attachAsset(newAsset)
        Storage.shared.save()
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func savePDF(_ pdfGen: () -> Data) {
        // CREATE PDF
        pdfResult =  pdfGen()
    }
    
    func saveImages(_ images: [Image]) {
        scanArray.append(contentsOf: images)
        dismissCamera()
    }
    

    
}

private extension VNDocumentCameraScan {
    
    /**
     Get all images from the scan.
     */
    var scans: [Image] {
        (0..<pageCount)
            .compactMap { imageOfPage(at: $0) }
            .map { Image(uiImage: $0) }
    }
    
    func makePDFFromScans() -> Data {
        var scans: [UIImage] {
            (0..<pageCount)
                .compactMap { imageOfPage(at: $0) }
            //.map { Image(uiImage: $0) }
        }
        
        let pdfDocument = PDFDocument()
        for (index,image) in scans.enumerated() {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let uiim = UIImage(data: data)
                let pdfPage = PDFPage(image: uiim!)
                pdfDocument.insert(pdfPage!, at: index)
            }
        }
        let data = pdfDocument.dataRepresentation()
        return data!
    }

}


//
//  DocumentCamera.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-01-22.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

#if os(iOS)

/**
 This view can be used to open a camera that can scan one or
 multiple pages in a physical document.
 
 You create a document camera by providing two action blocks:
 
 ```swift
 let camera = DocumentCamera(
 cancelAction: { print("User did cancel") }  // Optional
 resultAction: { result in ... }             // Mandatory
 }
 ```
 
 You can then present the camera with a sheet, a full screen
 cover etc.
 
 The camera uses a `VNDocumentCameraViewController` and will
 return a `VNDocumentCameraScan` that contains a list of all
 scanned document pages, if any.
 */
public struct DocumentCamera: UIViewControllerRepresentable {
    
    /**
     Create a document camera.
     
     - Parameters:
     - cancelAction: The action to trigger when the scan is cancelled.
     - resultAction: The action to trigger when the scan is completes.
     */
    public init(
        cancelAction: @escaping CancelAction = {},
        resultAction: @escaping ResultAction) {
            self.cancelAction = cancelAction
            self.resultAction = resultAction
        }
    
    public typealias CameraResult = Result<VNDocumentCameraScan, Error>
    public typealias CancelAction = () -> Void
    public typealias ResultAction = (CameraResult) -> Void
    
    private let cancelAction: CancelAction
    private let resultAction: ResultAction
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            cancelAction: cancelAction,
            resultAction: resultAction)
    }
    
    public func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(
        _ uiViewController: VNDocumentCameraViewController,
        context: Context) {}
}

public extension DocumentCamera {
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        public init(
            cancelAction: @escaping DocumentCamera.CancelAction,
            resultAction: @escaping DocumentCamera.ResultAction
        ) {
            self.cancelAction = cancelAction
            self.resultAction = resultAction
        }
        
        private let cancelAction: DocumentCamera.CancelAction
        private let resultAction: DocumentCamera.ResultAction
        
        public func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController
        ) {
            cancelAction()
        }
        
        public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            resultAction(.failure(error))
        }
        
        public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            resultAction(.success(scan))
        }
    }
}
#endif

