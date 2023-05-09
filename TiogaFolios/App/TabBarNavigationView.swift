//
//  TabBarNavigationView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/20/22.
//

import SwiftUI

enum NavItem {
    case foliolist
    case folioseglist
    case foliosharelist
    case foliosearch
    case taglist
    case templatelist
    case setting
    case tagkindlist
}


struct TabBarNavigationView: View {
    
    @State private var selection: NavItem = .foliolist
    
    var body: some View {
        TabView(selection: $selection) {
            
            NavigationView {
                FolioListView()
            }
            .tabItem {
                Label("Folios", systemImage: "archivebox")
            }
            .tag(NavItem.foliolist)
            
            NavigationView {
                SearchFolioView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(NavItem.foliosearch)
            
            NavigationView {
                TagListView()
            }
            .tabItem {
                Label("Tags", systemImage: "tag")
            }
            .tag(NavItem.taglist)

            NavigationView {
                FolioListSegView()
            }
            .tabItem {
                Label("Sharing", systemImage: "icloud")
            }
            .tag(NavItem.folioseglist)

            NavigationView {
                ShareTestListView()
            }
            .tabItem {
                Label("NewSharing", systemImage: "icloud")
            }
            .tag(NavItem.foliosharelist)

//            NavigationView {
//                FolioTemplListView()
//                
//            }
//            .tabItem {
//                Label("Life Events", systemImage: "square.grid.3x1.folder.badge.plus")
//            }
//            .tag(NavItem.templatelist)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                    
                }
                .tag(NavItem.setting)
            
            TagKindListView()
                .tabItem {
                    Label("Categories", systemImage: "briefcase")
                }
                .tag(NavItem.tagkindlist)
            
            ////#if !os(macOS)
            ////                DocScannerView(viewModel: DocScannerViewModel())
            ////                    .tabItem {
            ////                        Label("Scan", systemImage: "scanner.fill")
            ////                    }
            ////#endif

        }
    }
}

struct TabBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
