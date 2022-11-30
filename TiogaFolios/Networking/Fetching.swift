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
    
    static func saveLocalFile(_ urlstring: String,
                              folio: Folio,
                              viewContext: NSManagedObjectContext,
                              contentNote: String) async throws {
        guard let url = URL(string: urlstring) else {  NSLog("KKYY saveLocalFile urlstring error"); return }
            do {
                
                let data = try Data(contentsOf: url)
                
                let typeID = uttypeFor(url.pathExtension).identifier

                let blobasset = Asset(vc: viewContext, title: url.lastPathComponent, path: "", mimetype: UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType(), uttype: typeID)
                blobasset.setBlob(data)
                blobasset.desc = contentNote
                folio.attachAsset(blobasset)

                Storage.privdb.save()
            } catch {
                NSLog("KKYY error in saveLocalFile \(error)")
            }
        
    }
    
    static func getDistantUrl(_ urlstring: String,
                              folio: Folio,
                              viewContext: NSManagedObjectContext,
                              contentNote: String) async throws {
        NSLog("KKYY getDistantUrl")

        guard let url = URL(string: urlstring) else { return }
        
//        guard url.startAccessingSecurityScopedResource() else {
//            NSLog("KKYY getDistantUrl: unable to startAccessingSecurityScopedResource")
//            return
//        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print(response)
            fatalError("KKYY Error while fetching data")
        }
        
        //url.stopAccessingSecurityScopedResource()
        
        NSLog("KKYY getting a \(String(describing: response.mimeType))")
        var typeID: String = ""
        var blobasset: Asset
        var thisMime = response.mimeType
        
        if  thisMime == "text/html" {
            typeID = uttypeFor("html").identifier
            thisMime = UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType()
        }
        
        if  thisMime != "text/html" {
            typeID = uttypeFor(url.pathExtension).identifier
            thisMime = UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType()
        }

        blobasset = Asset(vc: viewContext, title: urlstring, path: urlstring, mimetype: thisMime ?? Asset.defaultBlobMimeType(), uttype: typeID)
        blobasset.source = url
        blobasset.setBlob(data)
        //folio.attachAsset(blobasset)
        folio.addToAssets(blobasset)
        
        Storage.privdb.save()
    }
    
    static func uttypeFor(_ fileextension: String) -> UTType {
        return UTType.types(tag: fileextension, tagClass: .filenameExtension, conformingTo: nil).first!
    }
    
}
