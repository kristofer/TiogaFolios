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
    @Environment(\.dismiss) private var dismiss

    @Binding var isTemplatesActive: Bool
    @ObservedObject var vm: FolioTemplListViewModel

    var searchResults: [FolioTemplate] {
        if vm.searchText.isEmpty {
            return vm.templates
        } else {
            return vm.templates.filter { $0.title.lowercased().contains(vm.searchText.lowercased()) }
        }
    }
    
    init(isActive:  Binding<Bool>) {
        UITableView.appearance().backgroundColor = .clear // Uses UIColor
        _isTemplatesActive = isActive
        vm = FolioTemplListViewModel()
    }
    
    
    var body: some View {
            List {
                ForEach(searchResults, id: \.self) { template in
                    VStack(spacing: 4) {
                        NavigationLink(destination: FolioTemplView(template: template, isActive: $isTemplatesActive))
                        {
                                FolioTemplCell(template: template)
                            }
                        .isDetailLink(false)
                    }
                }
                
            }
            .onAppear(){ if isTemplatesActive {
                dismiss()
            }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Life Event Examples")
#if os(iOS)
            .navigationBarTitle("New Folio from Example")
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
