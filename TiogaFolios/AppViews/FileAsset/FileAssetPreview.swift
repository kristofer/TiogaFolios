//
//  FileAssetPreview.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/12/22.
//

import SwiftUI
import QuickLook

struct PreviewController: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        tfDebug("TFdebug makeUIViewController")

        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: QLPreviewController, context: Context) {
            tfDebug("TFdebug updateUIViewController")
        }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: QLPreviewControllerDataSource {
        
        var parent: PreviewController
        
        init(parent: PreviewController) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            tfDebug("TFdebug previewController previewItemAt: \(parent.url.absoluteString)")

            return parent.url as NSURL
        }
        
    }
}
struct FileAssetPreview: View {
    var tFile: TemporaryFile
    
    let tracker = InstanceTracker("FileAssetPreview")
    var body: some View {
        tracker {
            PreviewController(url: self.tFile.fileURL)
                .border(.blue)
        }
    }
}

struct FileAssetPreview_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
