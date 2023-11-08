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
            
            //NavigationStack {
                FolioListView()
            //}
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
        }
    }
}

struct TabBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
