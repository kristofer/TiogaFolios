//
//  FileAsset.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/11/22.
//


import Foundation
import CoreData
import CloudKit

protocol Assetable {
    func attachAsset(_ asset: Asset)
    func removeAsset(_ asset: Asset)
}

// ASSET - a file of some kind, perhaps a 
extension Asset {
    convenience init(vc: NSManagedObjectContext, title: String, path: String, mimetype: String, uttype: String) {
        self.init(entity: Asset.entity(), insertInto: vc)
        self.id = UUID()
        self.title = title
        self.desc = ""
        self.pathname = path
        self.mimetype = mimetype
        self.uttype = uttype
        self.lastmodified = Date()
        //
        // .source and .blob not init'd
    }
    static func sampleAsset() -> Asset {
        return Asset.init(vc: Storage.privdb.vc(), title: "sample", path: "empty", mimetype: "plain/text", uttype: "")
    }
    static func defaultBlobMimeType() -> String {
        return "application/octet-stream"
    }
    func setBlob(_ data: Data) {
        self.blob = data
    }
    func blobSize() -> Int {
        if let blob = self.blob {
            return blob.count
        }
        return 0
    }

    func touch() { self.lastmodified = Date() }
}


extension Asset {

    static func fetchUnassignedAssets(vc: NSManagedObjectContext) -> [Asset] {
        var fetchedAssets = [Asset]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Asset")
        let dateSort = NSSortDescriptor(key:"title", ascending:true)
        let predicate = NSPredicate(format: "folio == nil") //(format: "folio == %i", nil)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = predicate
        //fetchedAssets = try! vc.fetch(fetchRequest) as! [Asset]
        do {
            fetchedAssets = try vc.fetch(fetchRequest) as? [Asset] ?? []
        } catch {
            Foundation.NSLog("No assets in store")
        }

        //print("KKYY folio count \(fetchedAssets.count)")
        return fetchedAssets
    }

    func tempURLFor() -> URL {
        //print("KKYY tempURLFor(document: BlobAsset) -> URL?")
        //print("KKYY tempURLFor \(self)")
        if self.mimetype == "text/html" {
            return URL(string: self.source!.absoluteString)!
        }
        do {
            let tmpPath = NSTemporaryDirectory() + self.id!.uuidString + "file"
            let temporaryFileURL = URL(fileURLWithPath: tmpPath)
            removeIfExists(tmpPath)
            let data = self.blob
            try data?.write(to: temporaryFileURL, options: .completeFileProtection)
            return temporaryFileURL
        } catch {
            print("KKYY unable to create temporary version of blob for display")
            return URL(string:"https://tiogadigital.com/")!
        }
    }
    
    func removeIfExists(_ filePath: String) {
        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }

    func isDocumentEditable() -> Bool {
        let targettype: String = "public.plain-text"
        let docType = self.uttype
        if let docType = docType {
            if (docType == targettype) {
                //                print("iseditable")
                return true
            }
            //print(">>> ", String(describing: docType))
        }
        //        print("NOT EDITABLE")
        return false
    }
    
    func coerceBlobToText() -> String {
        return "coerce Blob To Text"
    }

}
extension Asset: Comparable {
//    var modDate: Date {
//        let pc = Storage.privdb.container
//        let ckr = pc.record(for: self.objectID)
//        let m = ckr?.modificationDate
//        
//        return m!
//    }
    
    public static func <(lhs: Asset, rhs: Asset) -> Bool {
        if lhs.lastmodified == nil && rhs.lastmodified == nil {
            return true
        } else if lhs.lastmodified == nil {
            return false
        } else if rhs.lastmodified == nil {
            return true
        }
        return lhs.lastmodified! < rhs.lastmodified!
    }
}

extension Asset: Taggable {
    
    func attachTag(_ tag: Tag) {
        self.addToTags(tag)
    }
    
    func removeTag(_ tag: Tag) {
        self.removeFromTags(tag)
    }
    
    
}


// for Thumbnails

//    let prevGen = QLThumbnailGenerator()
//    let thumbnailSize = CGSize(width: 60, height: 90)
//    let scale = UIScreen.main.scale

//    func getThumbImage(asset: Asset) -> Image {
//
//        let request = QLThumbnailGenerator.Request(fileAt: url, size: self.thumbnailSize, scale: self.scale, representationTypes: .thumbnail)
//
//        prevGen.generateBestRepresentation(for: request) { (thumbnail, error) in
//
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let thumb = thumbnail {
//                thumb.uiImage // image available
//            }
//
//        }
//    }

