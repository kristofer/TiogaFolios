//
//  ArchivedListView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 1/18/23.
//

import SwiftUI
import CoreData
class ArchivedListViewModel: ObservableObject {
    
    @Published var folios = [Folio]()
    
    func fetchData() {
        self.folios = Folio.fetchArchivedFolios(vc: Storage.shared.vc)
        //print("TFdebug fetch folios \(self.folios.count)")
    }
    
}

struct ArchivedListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var vm = ArchivedListViewModel()
    
    init() {
        //UITableView.appearance().backgroundColor = .clear // Uses UIColor
    }
    
    
    var body: some View {
        // moved to "superview" NavigationView {
        VStack(alignment: .leading, spacing: 10) {
            List {
//                Section(header: Text("Archived (locked) Folios"))
//                {
                    ForEach(vm.folios) { folio in
                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: FolioView(folio: folio )) {
                                    FolioCell(folio: folio)
                                }
                        }
                        
                    }
//                }
                .headerProminence(.increased).padding(4)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(PlainListStyle())
            .refreshable {
                vm.fetchData()
            }
            .onAppear(){
                vm.fetchData()
            }
#if os(iOS)
            .navigationBarTitle("Archived Folios")
            //.navigationBarHidden(true)
#else
            // mac desktop
#endif
            Spacer()
        }
        .padding()

    }
    
    func didDismiss() {
        vm.fetchData()
    }
    
    
}

struct ArchivedListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
