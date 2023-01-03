//
//  Fetching.swift
//  Carolina
//
//  Created by Kristofer Younger on 3/3/22.
//

import Foundation
import CoreData
import UniformTypeIdentifiers
import os.log

class Fetching {
    
    func savePublicItem(_ url: URL,
                               folio: Folio,
                               viewContext: NSManagedObjectContext,
                        contentNote: String) async throws {
        do {
            
            if url.startAccessingSecurityScopedResource() {
                
                defer { url.stopAccessingSecurityScopedResource() }
                
                let taskContext = Storage.shared.container.newBackgroundContext()
                try await taskContext.perform {
                    let data = try Data(contentsOf: url)
                    
                    let typeID = self.uttypeFor(url.pathExtension).identifier
                    let mimetype = UTType(typeID)?.preferredMIMEType
                    
                    let fileasset = Asset(vc: viewContext, title: url.lastPathComponent, path: "",
                                          mimetype: mimetype ?? Asset.defaultBlobMimeType(), uttype: typeID)
                    fileasset.setBlob(data)
                    fileasset.desc = contentNote
                    //folio.attachAsset(blobasset)
                    folio.addToAssets(fileasset)
                    //fileasset.folio = folio
                    
                    Storage.shared.save()
                }
            } else {
                // Handle denied access
                NSLog("TFdebug error in savePublicItem DENIED ACCESS")
            }
        } catch {
            NSLog("TFdebug error in savePublicItem \(error)")
        }
        
    }
    
    
    func saveLocalFile(_ urlstring: String,
                              folio: Folio,
                              viewContext: NSManagedObjectContext,
                              contentNote: String) async throws {
        do {
            guard let url: URL = URL(string: urlstring) else { return }
            if url.startAccessingSecurityScopedResource() {
                
                defer { url.stopAccessingSecurityScopedResource() }
                //guard let url = URL(string: urlstring) else {  NSLog("TFdebug saveLocalFile urlstring error"); return }
                
                let data = try Data(contentsOf: url)
                
                let typeID = self.uttypeFor(url.pathExtension).identifier
                
                let blobasset = Asset(vc: viewContext, title: url.lastPathComponent, path: "", mimetype: UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType(), uttype: typeID)
                blobasset.setBlob(data)
                blobasset.desc = contentNote
                folio.attachAsset(blobasset)
                
                Storage.shared.save()
            } else {
                // Handle denied access
                NSLog("TFdebug error in saveLocalFile DENIED ACCESS")
            }
        } catch {
            NSLog("TFdebug error in saveLocalFile \(error)")
        }
        
    }
    
    func getDistantUrl(_ urlstring: String,
                              folio: Folio,
                              viewContext: NSManagedObjectContext,
                              contentNote: String) async throws {
        NSLog("TFdebug getDistantUrl")
        
        guard let url = URL(string: urlstring) else { return }
        
        //        guard url.startAccessingSecurityScopedResource() else {
        //            NSLog("TFdebug getDistantUrl: unable to startAccessingSecurityScopedResource")
        //            return
        //        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print(response)
            fatalError("TFdebug Error while fetching data")
        }
        
        //url.stopAccessingSecurityScopedResource()
        
        NSLog("TFdebug getting a \(String(describing: response.mimeType))")
        var typeID: String = ""
        var blobasset: Asset
        var thisMime = response.mimeType
        
        if  thisMime == "text/html" {
            typeID = self.uttypeFor("html").identifier
            thisMime = UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType()
        }
        
        if  thisMime != "text/html" {
            typeID = self.uttypeFor(url.pathExtension).identifier
            thisMime = UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType()
        }
        
        blobasset = Asset(vc: viewContext, title: urlstring, path: urlstring, mimetype: thisMime ?? Asset.defaultBlobMimeType(), uttype: typeID)
        blobasset.source = url
        blobasset.setBlob(data)
        //folio.attachAsset(blobasset)
        folio.addToAssets(blobasset)
        
        Storage.shared.save()
    }
    
    func uttypeFor(_ fileextension: String) -> UTType {
        return UTType.types(tag: fileextension, tagClass: .filenameExtension, conformingTo: nil).first!
    }
    
}
