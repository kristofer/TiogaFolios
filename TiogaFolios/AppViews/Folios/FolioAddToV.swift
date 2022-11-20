//
//  FolioAddToV.swift
//  Carolina
//
//  Created by Kristofer Younger on 1/6/22.
//

import SwiftUI

struct FolioAddToV: View {
    //@ObservedObject var viewModel: FolioVM
    
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
        List {
            NavigationLink("Add document...") {
                Button("Add document...", action: {
                    self.selection = 3
                })
                    .padding(20)
            }
            NavigationLink("Scan document...") {
            Button("Scan document...", action: {
                self.selection = 5
            })
                .padding(20)
            }
            NavigationLink("Add Web Bookmark...") {
            Button("Add Web Bookmark...", action: {
                self.selection = 4
            })
                .padding(20)
            }
        }
        .navigationTitle("Import To Folio...")
        }
    }
    
}

struct FolioAddToV_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
