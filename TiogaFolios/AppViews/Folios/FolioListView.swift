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
    @Published var searchQuery = ""

    func fetchData() {
        self.folios = Folio.fetchFolios(vc: Storage.shared.vc)
    }
    
    // generate new folio when the button is pressed...
    func generateFolio() {
        if newFolio == nil {
            newFolio = Folio.emptyFolio()
        }
    }
    
    func doSearch(_ srchStr: String) {
        let persistentContainer = Storage.shared
        // Create a fetch request with a compound predicate
        //let fetchRequest: NSFetchRequest<Folio>
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        var allPred = NSPredicate(value: false)

        if srchStr == "" {
            allPred = NSPredicate(value: true)
        }
        // Create the component predicates
        let titlePredicate = NSPredicate(
            format: "title CONTAINS[CD] %@", srchStr
        )
        
        //        let tagPredicate = NSPredicate(
        //            format: "tags = %@", srchStr
        //        )
        let tagPredicate = NSPredicate(format: "ANY tags.title CONTAINS[cd] %@ || tags.desc CONTAINS[cd] %@ ", srchStr, srchStr )

        
        let descPredicate = NSPredicate(
            format: "desc CONTAINS[CD] %@", srchStr
        )
        
        // Create an "and" compound predicate, meaning the
        // query requires all the predicates to be satisfied.
        // In other words, for an object to be returned by
        // an "and" compound predicate, all the component
        // predicates must be true for the object.
        fetchRequest.predicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: [
                titlePredicate,
                descPredicate,
                tagPredicate,
                allPred
            ]
        )
        
        // Get a reference to a NSManagedObjectContext
        let context = persistentContainer.vc
        
        // Perform the fetch request to get the objects
        // matching the compound predicate
        do {
            self.folios = try context.fetch(fetchRequest) as? [Folio] ?? []
        } catch {
            
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
            .searchable(text: $vm.searchQuery)
//            .onSubmit(of: .search) {
//                vm.doSearch(vm.searchQuery)
//            }
            .onChange(of: $vm.searchQuery.wrappedValue, perform: { _ in
                vm.doSearch(vm.searchQuery)
            })


            //.navigationBarHidden(true)
        } detail: {
            if let thisone = selection {
                FolioDetailView(folio: thisone )
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
