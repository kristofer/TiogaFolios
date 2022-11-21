//
//  ShareViewController.swift
//  ToArchive
//
//  Created by Kristofer Younger on 10/14/21.
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers
//import Carolina

class ShareViewController: SLComposeServiceViewController {
    
    
    private var folios = Folio.fetchFolios(vc: Storage.privdb.vc())
    let vc = Storage.privdb.vc()
    private var selectedFolio: Folio?
    var folioName = ""

    override func viewDidLoad() {
        folios = Folio.fetchFolios(vc: Storage.privdb.vc())
        super.viewDidLoad()
        selectedFolio = folios.first
        folioName = selectedFolio?.title ?? "unknown"
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        handleSharedFile()
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Add to Folio"
            deck.value = self.folioName
            deck.tapHandler = {
                let ssvc = ShareSelectViewController()
                ssvc.folios = self.folios
                ssvc.delegate = self
                self.pushConfigurationViewController(ssvc)
            }
            return [deck]
        }
        return nil
    }
    
    private func printProvider(prov: NSItemProvider) {
        // print out all the type IDs in the Provider.
        //
        let f = prov.registeredTypeIdentifiers;
        // what could I send in for fileOptions:?
        //let g = prov.registeredTypeIdentifiers(fileOptions: NSItemProviderFileOptions)
        for s in f {
            print("KKYY registeredTypeIdentifier \(s)")
        }
    }
    private func handleSharedFile() {
        let ct = contentText ?? ""

        
        // extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let iItems = self.extensionContext?.inputItems
        for s in iItems! {
            NSLog("KKYY unputItem: \(String(describing: s))")
        }
        //let contentType = UTType.content.description
        //NSLog("KKYY contentType: \(String(describing: contentType))")

//        let setSuper = UTType.content.supertypes
//        for sup in setSuper {
//            print("supertype \(sup)")
//        }
        for provider in attachments {
            printProvider(prov: provider)
            // Check if the content type is the same as we expected
            let variousKinds = provider.registeredTypeIdentifiers
            print("KKYY found variousKinds \(variousKinds)")
            print("KKYY will attach to folio  \(String(describing: selectedFolio?.title))")
            for kind in variousKinds {
            if provider.hasItemConformingToTypeIdentifier(kind) {
                print("KKYY found a \(kind)")
                provider.loadItem(forTypeIdentifier: kind,
                                  options: nil) { [unowned self] (data, error) in
                    // Handle the error here if you want
                    guard error == nil else { return }
                    
                    if let url = data as? URL {
                        if url.isFileURL{
                            print("KKYY found a FILE URL \(url.absoluteString)")
                            Task.detached { [self] in
                                try await Fetching.saveLocalFile(url.absoluteString, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                            }
                        } else {
                            print("KKYY found URL \(url.absoluteString)")
                            Task.detached {
                                try await Fetching.getDistantUrl(url.absoluteString, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                            }
                        }
                    } else {
                        // Handle this situation as you prefer
                        print("Failed to load data from provider")
                    }
                }}
            }
        }
    }
    
//    private func save(_ data: Data, key: String, value: Any) {
//        // You must use the userdefaults of an app group, otherwise the main app don't have access to it.
//        //      let userDefaults = UserDefaults(suiteName: appGroupName)
//        //      userDefaults.set(data, forKey: key)
//        NSLog("KKYY private func save(_ data: Data, key: String, value: Any)")
//    }
}

extension ShareViewController: ShareSelectViewControllerDelegate {
    func selected(f: Folio) {
        selectedFolio = f
        folioName = f.title ?? "unknown"
        //print("KKYY will attach to folio  \(String(describing: selectedFolio?.name))")
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
