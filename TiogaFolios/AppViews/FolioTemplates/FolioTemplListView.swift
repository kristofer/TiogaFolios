//
//  FolioTemplListView.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/26/22.
//

import SwiftUI

class FolioTemplListViewModel: ObservableObject {
    
    @Published var templates = decodeTemplatesFromString(globalTemplateData)
    @Published var searchText = ""
    
}


struct FolioTemplListView: View {
    @ObservedObject var vm = FolioTemplListViewModel()
    
    @State private var showNewFolio = false
    
    var searchResults: [FolioTemplate] {
        if vm.searchText.isEmpty {
            return vm.templates
        } else {
            return vm.templates.filter { $0.title.lowercased().contains(vm.searchText.lowercased()) }
        }
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear // Uses UIColor
    }
    
    
    var body: some View {
//        NavigationView {
            List {
                //Section(header: Text("Life Event Templates")) {
                ForEach(searchResults, id: \.self) { template in
                    VStack(spacing: 4) {
                        NavigationLink(
                            destination: FolioTemplView(template: template )) {
                                FolioTemplCell(template: template)
                            }
                    }
                    .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 4, trailing: 0))
                    
                }
                
                // .onDelete(perform: deleteFolios)
                
                //}
                //.listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Life Event Templates")
#if os(iOS)
            .navigationBarTitle("Create Folios from Templates")
            .navigationBarTitleDisplayMode(.inline)
            //.navigationBarHidden(true)
#else
            // mac desktop
#endif
//        }
    }
    
    func didDismiss() {
        showNewFolio = false
    }
}

struct FolioTemplListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
