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
    
    
    private var folios = Folio.fetchFoliosAnd(vc: Storage.shared.vc, relations: ["assets"])
    let vc = Storage.shared.vc
    private var selectedFolio: Folio?
    var folioName = ""
    var ssvc: ShareSelectViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func presentationAnimationDidFinish() {
        folios = Folio.fetchFolios(vc: Storage.shared.vc)
        selectedFolio = folios.first
        folioName = selectedFolio?.title ?? "unknown"
        reloadConfigurationItems()
    }
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        handleSharedFile()
        //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        super.didSelectPost()
    }
    
    override func configurationItems() -> [Any]! {
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Add to Folio"
            deck.value = self.folioName
            deck.tapHandler = { [self] in
                self.ssvc = ShareSelectViewController()
                self.ssvc!.folios = self.folios
                self.ssvc!.delegate = self
                self.pushConfigurationViewController(ssvc!)
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
            print("TFdebug registeredTypeIdentifier \(s)")
        }
    }
    
    
    private func handleSharedFile() {
        let ct = contentText ?? ""
        
        
        // extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let iItems = self.extensionContext?.inputItems
        for s in iItems! {
            NSLog("TFdebug unputItem: \(String(describing: s))")
        }
        //let contentType = UTType.content.description
        //NSLog("TFdebug contentType: \(String(describing: contentType))")
        
        //        let setSuper = UTType.content.supertypes
        //        for sup in setSuper {
        //            print("supertype \(sup)")
        //        }
        print("TFdebug # of attachments == \(attachments.count)")
        // for provider in attachments {
            //let foo = provider.suggestedName
            //let variousKinds = provider.registeredTypeIdentifiers
            //print("TFdebug found \(foo) variousKinds ***\n*** \(variousKinds)")
        // }
        for provider in attachments {
            //printProvider(prov: provider)
            // Check if the content type is the same as we expected
            let variousKinds = provider.registeredTypeIdentifiers
            print("TFdebug found variousKinds ***\n*** \(variousKinds)")
            print("TFdebug will attach to folio  \(String(describing: selectedFolio?.title))")
            for kind in variousKinds {
                print("***Current Kind is \(kind)")

                if provider.hasItemConformingToTypeIdentifier("public.plain-text") {
                    print("TFdebug found a \(kind)")
                    break
                }

                if provider.hasItemConformingToTypeIdentifier("com.adobe.pdf") { // was kind
                    print("TFdebug found a \(kind)")
                    provider.loadItem(forTypeIdentifier: "com.adobe.pdf", // public.item
                                      options: nil) { data, error in
                        let url = data as! URL
                        print("TFdebug found a PDF \(url.absoluteString)")
                        Task.detached { [self] in
                            try await Fetching().savePublicItem(url, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                        }
                    }
                    return
                }
                // from files (not pdf)
                // a web site (not the page, just the URL)
                // files from web sites
                else if provider.hasItemConformingToTypeIdentifier("public.content") { // was kind
                    print("TFdebug found a \(kind)")
                    provider.loadItem(forTypeIdentifier: "public.content", // public.item
                                      options: nil) { data, error in
                        let url = data as! URL
                        print("TFdebug found a fileurl \(url.absoluteString)")
                        Task.detached { [self] in
                            try await Fetching().savePublicItem(url, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                        }
                    }
                    return
                }
                
                else if provider.hasItemConformingToTypeIdentifier("public.url") { // was kind
                    
                    provider.loadItem(forTypeIdentifier: "public.url",
                                      options: nil) { [unowned self] (data, error) in
                        // Handle the error here if you want
                        guard error == nil else { return }
                        
                        if let url = data as? URL {
                            if url.isFileURL{
                                print("TFdebug found a FILE URL \(url.absoluteString)")
                                Task.detached { [self] in
                                    try await Fetching().savePublicItem(url, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                                    //                                    try await Fetching().saveLocalFile(url.absoluteString, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                                }
                            } else {
                                print("TFdebug found URL \(url.absoluteString)")
                                Task.detached {
                                    try await Fetching().getDistantUrl(url.absoluteString, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                                }
                            }
                        } else {
                            // Handle this situation as you prefer
                            print("Failed to load data from provider")
                        }
                    }
                    return
                }
                
                else if provider.hasItemConformingToTypeIdentifier("public.file-url") { // was kind
                    
                    provider.loadItem(forTypeIdentifier: "public.file-url",
                                      options: nil) { //[unowned self]
                        (data, error) in
                        // Handle the error here if you want
                        guard error == nil else { return }
                        
                        if let url = data as? URL {
                            if url.isFileURL{
                                print("TFdebug found a FILE URL \(url.absoluteString)")
                                Task.detached { [self] in
                                    //    try await
                                    try? await Fetching().savePublicItem(url, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                                    //                                    try await Fetching().saveLocalFile(url.absoluteString, folio: self.selectedFolio!, viewContext: self.vc, contentNote: ct)
                                }
                            }
                        } else {
                            // Handle this situation as you prefer
                            print("Failed to load data from provider")
                        }
                    }
                    return
                }
            }
            
        }
    }
}

extension ShareViewController: ShareSelectViewControllerDelegate {
    func selected(f: Folio) {
        selectedFolio = f
        folioName = f.title ?? "unknown"
        print("TFdebug will attach to folio  \(String(describing: selectedFolio?.title))")
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
