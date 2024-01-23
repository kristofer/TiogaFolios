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
    
    var body: some View {
        if UIDevice.runningOnMac {
            PreviewController(url: self.tURL)
            NavigationLink(destination: PreviewControllerMac(url: self.$tURL)) {
                    Text("Open in Preview")
                    .font(.system(size: 20, weight: Font.Weight.bold))
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                    .buttonStyle(PlainButtonStyle())
//                    .bold()
//                    .buttonStyle(.borderedProminent)
//                    .tint(.white)
            }
        } else {
            PreviewController(url: self.tURL)
        }
    }
}

struct FileAssetPreview_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

struct PDFFilePreviewMac: View {
    @State var tURL: URL
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        PreviewControllerMac(url: self.$tURL)
//        .toolbar {
//            Button("Done") {
//                dismiss()
//            }
//        }
    }
}

struct PreviewControllerMac: UIViewControllerRepresentable {
    @Binding var url: URL
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    class Coordinator: NSObject, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        let parent: PreviewControllerMac
        init(parent: PreviewControllerMac) {
            self.parent = parent
        }
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as NSURL
        }
        func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
            return .updateContents
        }
    }
}
