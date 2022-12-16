//
//  SearchFolioView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/28/22.
//

import SwiftUI
import CoreData

class FolioSearchViewModel: ObservableObject {
    
    @Published var folios = [Folio]()
    @Published var searchQuery = ""

    func fetchData() {
        self.folios = Folio.fetchFolios(vc: Storage.shared.vc)
        //print("KKYY fetch folios \(self.folios.count)")
    }
    
    func doSearch(_ srchStr: String) {
        let persistentContainer = Storage.shared
        // Create a fetch request with a compound predicate
        //let fetchRequest: NSFetchRequest<Folio>
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folio")
        
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
                tagPredicate
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

struct SearchFolioView: View {
    @ObservedObject var vm = FolioSearchViewModel()
    //@Environment(\.dismissSearch) var dismissSearch
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section(header: Text("Folios"))
                    {
                        ForEach(vm.folios) { folio in
                            VStack(spacing: 0) {
                                NavigationLink(
                                    destination: FolioView(folio: folio )) {
                                        FolioCell(folio: folio)
                                    }
                            }
                            
                        }
                    }
                    .headerProminence(.increased).padding(4)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    
                }
//                .toolbar {
//                    .navigationBarTitle("Search")
//                    .navigationBarHidden(true)
//                }
            }
        }
        .searchable(text: $vm.searchQuery)
        .onSubmit(of: .search) {
            vm.doSearch(vm.searchQuery)
        }
        
        
    }
    
}

struct SearchFolioView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFolioView()
    }
}
