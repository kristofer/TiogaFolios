//
//  FileAssetPreview.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/12/22.
//

import SwiftUI
import QuickLook

struct PreviewController: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        //print("TFdebug makeUIViewController")

        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: QLPreviewController, context: Context) {
            //print("TFdebug updateUIViewController")
        }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: QLPreviewControllerDataSource {
        
        let parent: PreviewController
        
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
            //print("TFdebug previewController previewItemAt:")

            return parent.url as NSURL
        }
        
    }
}
struct FileAssetPreview: View {
    var tFile: TemporaryFile
    
    var body: some View {
        PreviewController(url: self.tFile.fileURL)
            .border(.blue)
    }
}

struct FileAssetPreview_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
