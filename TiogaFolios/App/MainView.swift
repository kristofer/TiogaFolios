//
//  MainView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import Foundation

import SwiftUI
import CoreData

struct MainView: View {
    // @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
//        Text("Empty Tioga Folios")
            TabView {
                FolioListView()
                    .tabItem {
                        Label("Folios", systemImage: "archivebox")
                    }

                TagKindListView()
                    .tabItem {
                        Label("Categories", systemImage: "briefcase")
                    }

                SearchFolioView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

//                FolioAddToV(viewModel: FolioVM())
//                    .tabItem {
//                        Label("Import", systemImage: "square.and.arrow.down.on.square.fill")
//                    }
                
//                FileAssetList()
//                    .tabItem {
//                        Label("Documents", systemImage: "doc.richtext")
//                    }
//
//#if !os(macOS)
//                DocScannerView(viewModel: DocScannerViewModel())
//                    .tabItem {
//                        Label("Scan", systemImage: "scanner.fill")
//                    }
//#endif
//                TagListView()
//                    .tabItem {
//                        Label("Tags", systemImage: "tag")
//                    }
                FolioTemplListView()
                    .tabItem {
                        Label("Life Events", systemImage: "square.grid.3x1.folder.badge.plus")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }

            }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, Storage.preview.container.viewContext)
    }
}


func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        // Ensure a non-nil value in `source`.
        if source.wrappedValue == nil {
            source.wrappedValue = defaultValue
        }
        // Unsafe unwrap because *we* know it's non-nil now.
        self.init(source)!
    }
    
}

