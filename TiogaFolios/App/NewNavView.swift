//
//  NewNavView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 10/20/23.
//

import SwiftUI

struct NewNavView: View {
    @State private var columnVisibility =
    NavigationSplitViewVisibility.all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarNavigationView()
                .navigationSplitViewColumnWidth(200)
        } content: {
            EmptyView()
                .navigationSplitViewColumnWidth(200)
        } detail: {
            NewFolioDetail()
        }
        //.navigationSplitViewStyle(.balanced)
    }
}

struct NewNavView_Previews: PreviewProvider {
    static var previews: some View {
        NewNavView()
    }
}
