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
    //@Binding var rootIsActive : Bool

    var searchResults: [FolioTemplate] {
        if vm.searchText.isEmpty {
            return vm.templates
        } else {
            return vm.templates.filter { $0.title.lowercased().contains(vm.searchText.lowercased()) }
        }
    }
    
    init() {//rootIsActive: Binding<Bool>) {
        UITableView.appearance().backgroundColor = .clear // Uses UIColor
        //rootIsActive = rootIsActive
    }
    
    
    var body: some View {
            List {
                ForEach(searchResults, id: \.self) { template in
                    VStack(spacing: 4) {
                        NavigationLink(destination: FolioTemplView(template: template)) //, shouldPopToRootView: self.$rootIsActive))
                        {
                                FolioTemplCell(template: template)
                            }
                        .isDetailLink(false)
                    }
                    .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 4, trailing: 0))
                    
                }
                
            }
            .listStyle(PlainListStyle())
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Life Event Templates")
#if os(iOS)
            .navigationBarTitle("New Folio from Template")
            .navigationBarTitleDisplayMode(.inline)
#else
            // mac desktop
#endif
//        }
    }
    
    func didDismiss() {
        //isActive = false
    }
}

struct FolioTemplListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
