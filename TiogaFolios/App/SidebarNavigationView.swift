//
//  SidebarNavigationView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/20/22.
//

import SwiftUI

struct SidebarNavigationView: View {
    
    //@SceneStorage("selection")
    @State var selection: NavItem? = .foliolist
    @State var active: Bool = true

    var body: some View {
        NavigationView {
            VStack{
            Text("Tioga Folios")
                .font(.title2)
            List(selection: $selection) {
                NavigationLink(destination: FolioListView(), isActive: $active) {
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
                
                NavigationLink(destination: FolioListSegView()) {
                    Label(title: { Text("Sharing") },
                          icon: { Image(systemName: "icloud")
                            .font(.headline)
                        .imageScale(.medium) })
                }
                .tag(NavItem.foliosharelist)

                NavigationLink(destination: SettingsView()) {
                    Label(title: { Text("Settings") },
                          icon: { Image(systemName: "gear")
                            .font(.headline)
                        .imageScale(.medium) })
                }
                .tag(NavItem.setting)
                
                NavigationLink(destination: OnboardView()) {
                    Label(title: { Text("Onboarding") },
                          icon: { Image(systemName: "questionmark.app")
                            .font(.headline)
                        .imageScale(.medium) })
                }
                .tag(NavItem.onboarding)

                NavigationLink(destination: FolioListByTag(TagKind.plain)) {
                    Label(title: { Text("Tag Filter") },
                          icon: { Image(systemName: "tag.square")
                            .font(.headline)
                        .imageScale(.medium) })
                }
                .tag(NavItem.tagfilterlist)

            }
                
            }

            //.listStyle(SidebarListStyle())
//            .onAppear(perform: {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                    selection = .foliolist
//                })
//            })

        }
    }
}

//extension SidebarNavigationView {
//    /// Show or hide the sidebar list in macOS.
//    ///
//    /// Needed for when the sidebar is hidden from the user
//    /// action as there is a bug in this version of SwiftUI
//    /// that block the user to show the sidebar again without
//    /// this hack.
//    func toggleSidebar() {
//#if os(macOS)
//        NSApp
//            .keyWindow?
//            .firstResponder?
//            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)),
//                          with: nil)
//#endif
//    }
//}

struct SidebarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
