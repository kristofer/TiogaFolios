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
    @Published var hiddenTags = ""
    var hiddenTagsSelected = [Tag]()
    
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
// REMOVE TAGS
//        let tagPredicate = NSPredicate(format: "ANY tags.title CONTAINS[cd] %@ || tags.desc CONTAINS[cd] %@ ", srchStr, srchStr )
//        
//        var tagHiddenPredicate = NSPredicate(format: "ANY tags.title CONTAINS[cd] %@ ", hiddenTags )
//        if hiddenTags == "" {
//            tagHiddenPredicate = NSPredicate(value: true)
//        }
        
        let descPredicate = NSPredicate(
            format: "desc CONTAINS[CD] %@", srchStr
        )
        
        // Create an "and" compound predicate, meaning the
        // query requires all the predicates to be satisfied.
        // In other words, for an object to be returned by
        // an "and" compound predicate, all the component
        // predicates must be true for the object.
        
        fetchRequest.predicate =
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            // REMOVE TAGS
//            tagHiddenPredicate,
            NSCompoundPredicate(
                orPredicateWithSubpredicates: [
                    titlePredicate,
                    descPredicate,
// REMOVE TAGS
//                    tagPredicate,
                    allPred
                ]
            )])
        
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

extension FolioListViewModel: Taggable {
    func attachTag(_ tag: Tag) {
        if let title = tag.title {
            self.hiddenTags.append(title)
            self.hiddenTagsSelected.append(tag)
        }
    }
    
    func removeTag(_ tag: Tag) {
        if let title = tag.title {
            self.hiddenTags = self.hiddenTags.replacingOccurrences(of: title, with: "")
            if let index = self.hiddenTagsSelected.firstIndex(of: tag) {
                self.hiddenTagsSelected.remove(at: index)
            }
        }
    }
}


struct FolioListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    //    @ObservedObject var vm = FolioListViewModel()
    @StateObject var vm = FolioListViewModel()
    
    @State private var isTemplatesActive = false
    @State private var selection: Folio? = nil // Nothing selected by default.
    @State private var showingDeleteAlert = false
    @State private var itemToDelete: Folio? = nil
    
    init() { }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationSplitView{
            VStack {
                //                TagRestrictView(flvm: vm)
                
// REMOVE TAGS
//                DisclosureGroup("  Filter by tag") {
//                    tagRestrict()
//                }
                List(vm.folios, id: \.self, selection: $selection) { folio in
                    NavigationLink(value: folio) {
                        FolioCell(folio: folio)
                    }
//                    .swipeActions {
//                                Button(
//                                    role: .destructive,
//                                    action: {
//                                        self.itemToDelete = folio
//                                        self.showingDeleteAlert = true
//                                    }) {
//                                        Image(systemName: "trash")
//                                    }
//                            }
//                            .confirmationDialog(
//                                "Are you sure?",
//                                isPresented: $showingDeleteAlert
//                            ) {
//                                Button("Yes") {
//                                    withAnimation {
//                                        deleteItem(itemToDelete)
//                                    }
//                                }
//                            }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    vm.fetchData()
                }
                .onAppear(){
                    vm.fetchData()
                }
                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(
                            destination:FolioTemplListView(isActive: $isTemplatesActive)) {
                                Label("New Folio", systemImage: "plus")
                            }
                    }
                }
                
                .navigationBarTitle("Folios")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $vm.searchQuery)
                .onChange(of: $vm.searchQuery.wrappedValue, perform: { _ in
                    vm.doSearch(vm.searchQuery)
                })
                .onChange(of: $vm.hiddenTags.wrappedValue, perform: { _ in
                    vm.doSearch(vm.searchQuery)
                })
            }
        } detail: {
            NavigationStack {
                ZStack {
                    if let thisone = selection {
                        FolioDetailView(folio: thisone )
                    } else {
                        Text("No folio selected. Click the icon is upper left of screen.")
                    }
                }}
        }
    }
    
    private func deleteFolios(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.folios[$0] }.forEach(Storage.shared.vc.delete)
        }
        Storage.shared.save()
        vm.fetchData()
    }
    
    func deleteItem(_ item: NSManagedObject?) {
        guard let item else { return }
        Storage.shared.vc.delete(item)
        do {
            try Storage.shared.vc.save()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    @ViewBuilder
    func tagRestrict() -> some View {
        HStack {
            TagRestrictView(flvm: vm)
                .frame(height: 300)
        }
    }
}

struct FolioListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
