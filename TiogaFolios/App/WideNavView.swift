//
//  WideNavView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 6/27/23.
//

import SwiftUI

enum SideBarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case folios
    case search
    case tags
    case sharing
    case settings
    case onboarding
    case tagfilter
}

struct WideNavView: View {
    // 1
     //@State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedSideBarItem: SideBarItem = .folios

    var body: some View {
         // 2
//         NavigationSplitView(columnVisibility: $sideBarVisibility) {
//             Text("Users")
//         // 3
//         } detail: {
             FolioListView()
//         }
     }
}

struct WideNavView_Previews: PreviewProvider {
    static var previews: some View {
        WideNavView()
    }
}
