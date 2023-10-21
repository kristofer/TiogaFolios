//
//  TabBarNavigationView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/20/22.
//

import SwiftUI

struct TabBarNavigationView: View {
    
    @State private var selection: NavItem = .foliolist
    
    var body: some View {
        TabView(selection: $selection) {
            
            NavigationStack {
                FolioListView()
            }
            .tabItem {
                Label("Folios", systemImage: "archivebox")
            }
            .tag(NavItem.foliolist)
            
            NavigationStack {
                SearchFolioView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(NavItem.foliosearch)
            
            NavigationStack {
                TagListView()
            }
            .tabItem {
                Label("Tags", systemImage: "tag")
            }
            .tag(NavItem.taglist)

            NavigationStack {
                FolioListSegView()
            }
            .tabItem {
                Label("Sharing", systemImage: "icloud")
            }
            .tag(NavItem.folioseglist)

            NavigationStack {
                FolioListByTag(TagKind.plain)
            }
            .tabItem {
                Label("Tag Filter", systemImage: "tag.square")
            }
            .tag(NavItem.tagfilterlist)


//            NavigationView {
//                ShareTestListView()
//            }
//            .tabItem {
//                Label("NewSharing", systemImage: "icloud")
//            }
//            .tag(NavItem.foliosharelist)

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

            OnboardView()
                .tabItem {
                    Label("Onboarding", systemImage: "questionmark.app")
                }
                .tag(NavItem.onboarding)

//            NavigationStack {
//                TagKindListView()
//            }
//                .tabItem {
//                    Label("Categories", systemImage: "briefcase")
//                }
//                .tag(NavItem.tagkindlist)
            
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
