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
            if context.coordinator.parent.url.absoluteURL != self.url.absoluteURL {
                context.coordinator.urlToDisplay = self.url
                uiViewController.refreshCurrentPreviewItem()
            }
        }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: QLPreviewControllerDataSource {
        
        var parent: PreviewController
        var urlToDisplay: URL

        init(parent: PreviewController) {
            self.parent = parent
            self.urlToDisplay = parent.url
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            tfDebug("TFdebug previewController previewItemAt: \(parent.url.absoluteString)")

            return self.urlToDisplay as QLPreviewItem
        }
        
    }
}
struct FileAssetPreview: View {
    @State var tURL: URL
    
    //let tracker = InstanceTracker("FileAssetPreview")
    var body: some View {
        //tracker {
            PreviewController(url: self.tURL)
                .border(.blue)
            //}
    }
}

struct FileAssetPreview_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
