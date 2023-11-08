//
//  FolioListView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import SwiftUI
import CoreData

class FolioListViewModel: ObservableObject {
    
    @Published var folios = [Folio]()
    @Published var sharedfolios = [Folio]()
    @Published var sharingfolios = [Folio]()
    
    @Published var newFolio: Folio?
    
    func fetchData() {
        self.folios = Folio.fetchFolios(vc: Storage.shared.vc)
    }
    
    // generate new folio when the button is pressed...
    func generateFolio() {
        if newFolio == nil {
            newFolio = Folio.emptyFolio()
        }
    }
}

struct FolioListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    //    @ObservedObject var vm = FolioListViewModel()
    @StateObject var vm = FolioListViewModel()
    
    @State private var isTemplatesActive = false
    @State private var selection: Folio? = nil // Nothing selected by default.

    init() { }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationSplitView{
            List(vm.folios, id: \.self, selection: $selection) { folio in
                NavigationLink(value: folio) {
                    FolioCell(folio: folio)
                }
                .listRowSeparator(.hidden)
                .headerProminence(.increased).padding(4)
                .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }
            .listStyle(PlainListStyle())
            .refreshable {
                vm.fetchData()
            }
            .onAppear(){
                vm.fetchData()
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(
                        destination:FolioTemplListView(isActive: $isTemplatesActive)) {
                            Label("New Folio", systemImage: "plus")
                        }
                    //.isDetailLink(false)
                }
            }
            
            .navigationBarTitle("All Folios")
            .navigationBarTitleDisplayMode(.inline)
            //.navigationBarHidden(true)
        } detail: {
            if let folio = selection {
                FolioDetailView(folio: folio )
            } else {
                Text("No folio selected.")
            }
        }
    }
    
    private func deleteFolios(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.folios[$0] }.forEach(Storage.shared.vc.delete)
        }
        Storage.shared.save()
        vm.fetchData()
    }
}

struct FolioListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
