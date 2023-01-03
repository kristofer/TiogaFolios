//
//  Extras.swift
//  Carolina
//
//  Created by Kristofer Younger on 3/3/22.
//
// these are urls that can be used for testing various fetching code.
// first created to test the code that gets embedded into the ShareExtension ToArchive

import Foundation
import CoreData

enum ExtrasUrl {
    static let extrasurl = "https://tioga-help.s3.amazonaws.com/demo"

    static let form1099 = extrasurl + "/1099example.pdf"
    static let tax1040 = extrasurl + "/2011-1040.pdf"
    static let allstatepolicy = extrasurl + "/Allstate-Policy-Illustrator-Home.pdf"
    static let chasestmt = extrasurl + "/Chase-statements-and-images.pdf"
    static let declI = extrasurl + "/DeclarationOfIndependence-Final.pdf"
    static let mlynchhowto = extrasurl + "/MLynch-HowToReadStmt_DCOnly.pdf"
    static let wellsfargostmt = extrasurl + "/WellsFargo-Biz-Statement-Example.pdf"
    static let w2example = extrasurl + "/w-2example.pdf"

}

class TestFetch {
    var vc: NSManagedObjectContext
    
    init(_ viewContext: NSManagedObjectContext){
        vc = viewContext
    }
    
    func runTest() async {
        do {
            let testy = ExtrasUrl.extrasurl + "/index.html"
            let folios = Folio.fetchFolios(vc: vc)
            let lastfolio = folios.count > 0 ? folios.first! : Folio.createFolio(vc: vc, title: "Import")

            try await Fetching().getDistantUrl(testy, folio: lastfolio, viewContext: vc, contentNote: "foo")
        } catch {
            print("unable to fetch url")
        }
    }
    func runTest2() async {
        do {
            let testy = "https://www.zipcodewilmington.com"
            let folios = Folio.fetchFolios(vc: vc)
            let lastfolio = folios.count > 0 ? folios.first! : Folio.createFolio(vc: vc, title: "Import")

            try await Fetching().getDistantUrl(testy, folio: lastfolio, viewContext: vc, contentNote: "Zip Code Wilmington")
        } catch {
            print("unable to fetch url")
        }
    }
}
