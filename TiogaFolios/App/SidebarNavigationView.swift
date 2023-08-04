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
    let elements: [NavItem] = [.foliolist, .foliosearch, .taglist,
        .foliosharelist, .setting, .onboarding, .tagfilterlist ]

    @ViewBuilder var detailView: some View {
        switch self.selection {
        case .foliolist :
            FolioListView()
        case .foliosearch :
            SearchFolioView()
        case .taglist :
            TagListView()
        case .foliosharelist :
            FolioListSegView()
        case .setting :
            SettingsView()
        case .onboarding :
            OnboardView()
        case .tagfilterlist :
            FolioListByTag(TagKind.plain)
        default:
            FolioListView()
      }
    }
    var body: some View {
        NavigationView {
            VStack{
                Text("Tioga Folios")
                    .font(.title2)
                NavigationSplitView {
                    List(elements, id: \.self, selection: $selection) { element in
                        let ttt = element.labelFor()
                        NavigationLink(value: element) {
                            Label(title: { Text(ttt.0) },
                            icon: { Image(systemName: ttt.1)}
                            )}
                    }
                } detail: {
                        detailView
                }
            }
            
        }
    }
}

struct SidebarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
