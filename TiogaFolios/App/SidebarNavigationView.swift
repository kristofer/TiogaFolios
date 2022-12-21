//
//  SidebarNavigationView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/20/22.
//

import SwiftUI

struct SidebarNavigationView: View {
    
    @SceneStorage("selection")
    var selection: String?
    
    var content: some View {
        List(selection: $selection) {
            NavigationLink(destination: FolioListView()) {
                Label(title: { Text("Folios") },
                      icon: { Image(systemName: "archivebox")
                        .font(.headline)
                    .imageScale(.medium) })
            }
            .tag(NavItem.foliolist)
            NavigationLink(destination: SearchFolioView()) {
                Label(title: { Text("Search") },
                      icon: { Image(systemName: "magnifyingglass")
                        .font(.headline)
                    .imageScale(.medium) })
            }
            .tag(NavItem.foliosearch)
            NavigationLink(destination: TagListView()) {
                Label(title: { Text("Tags") },
                      icon: { Image(systemName: "tag")
                        .font(.headline)
                    .imageScale(.medium) })
            }
            .tag(NavItem.taglist)
            NavigationLink(destination: FolioTemplListView()) {
                Label(title: { Text("Life Events") },
                      icon: { Image(systemName: "square.grid.3x1.folder.badge.plus")
                        .font(.headline)
                    .imageScale(.medium) })
            }
            .tag(NavItem.templatelist)
            NavigationLink(destination: SettingsView()) {
                Label(title: { Text("Settings") },
                      icon: { Image(systemName: "gear")
                        .font(.headline)
                    .imageScale(.medium) })
            }
            .tag(NavItem.setting)
        }
        .listStyle(SidebarListStyle())
    }
    
    var body: some View {
        NavigationView {
#if os(iOS)
            content
#else
            content
                .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSidebar ) {
                            Image(systemName: "sidebar.left")
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
#endif
            
            // This is the part where the magic happens for the split view.
            // Instead of the Text, add any view you want in place.
            // Play here to see what fits best for you.
            Text("Content List")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
#if os(iOS)
            Text("Split view for iPad")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
#else
            Text("Split view for macOS")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar { Spacer() }
#endif
        }
    }
}

extension SidebarNavigationView {
    /// Show or hide the sidebar list in macOS.
    ///
    /// Needed for when the sidebar is hidden from the user
    /// action as there is a bug in this version of SwiftUI
    /// that block the user to show the sidebar again without
    /// this hack.
    func toggleSidebar() {
#if os(macOS)
        NSApp
            .keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)),
                          with: nil)
#endif
    }
}

struct SidebarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
