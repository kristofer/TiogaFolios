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
    @Published var newFolio: Folio?

    func fetchData() {
        self.folios = Folio.fetchFolios(vc: Storage.privdb.vc())
        print("KKYY fetch folios \(self.folios.count)")
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
    @ObservedObject var vm = FolioListViewModel()

    @State private var showNewFolio = false

    init() {
        UITableView.appearance().backgroundColor = .clear // Uses UIColor
    }
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recent Folios"))
                    {
                    ForEach(vm.folios) { folio in
                        VStack(spacing: 0) {
                        NavigationLink(
                            destination: FolioView(folio: folio )) {
                                FolioCell(folio: folio)
                            }
                        }

                    }
                    .onDelete(perform: deleteFolios)
                }
                .headerProminence(.increased).padding(4)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .refreshable {
                
            }
            .onAppear(){
                vm.fetchData()
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .bottomBar) {
                    EditButton()
                }
                
#endif
                ToolbarItem(placement: .bottomBar) {
                    Button(action:  {
                        vm.generateFolio()
                        showNewFolio = true
                    }) {
                        HStack {
                            Text("New Folio")
                            Image(systemName: "plus")
                        }
                    }
                    .sheet(isPresented: $showNewFolio, onDismiss: didDismiss)
                    {
                        FolioDeltaView(objectPassed: vm.newFolio, show: $showNewFolio)
                    }
                }
            }
#if os(iOS)
            .navigationBarTitle("")
            .navigationBarHidden(true)
#else
            // mac desktop
#endif
        }
    }
    
    func didDismiss() {
        showNewFolio = false
        vm.newFolio = nil
        vm.fetchData()
    }
    
    private func deleteFolios(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.folios[$0] }.forEach(Storage.privdb.vc().delete)
        }
        Storage.privdb.save()
        vm.fetchData()
    }
}

struct FolioListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
