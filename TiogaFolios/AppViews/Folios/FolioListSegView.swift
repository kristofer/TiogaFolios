//
//  FolioListSegView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 4/7/23.
//

import SwiftUI

import SwiftUI
import CoreData

class FolioListSegViewModel: ObservableObject {
    
    @Published var folios = [Folio]()
    @Published var sharedfolios = [Folio]()
    @Published var sharingfolios = [Folio]()
    
    @Published var newFolio: Folio?
    
    func fetchData() {
        //self.folios = Folio.fetchFolios(vc: Storage.shared.vc)
        self.folios = Folio.fetchPrivateFolios(vc: Storage.shared.vc)
        self.sharedfolios = Folio.fetchSharedFolios(vc: Storage.shared.vc)
        self.sharingfolios = Folio.fetchSharingFolios(vc: Storage.shared.vc)
        tfDebug("fetch folios \(self.folios.count)")
    }
    
    // generate new folio when the button is pressed...
    func generateFolio() {
        if newFolio == nil {
            newFolio = Folio.emptyFolio()
        }
    }
}

struct FolioListSegView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var vm = FolioListSegViewModel()
    
    @State private var isTemplatesActive = false
    
    init() { }
    
    var body: some View {
        // moved to "superview" NavigationView {
        List {
            Section(header: Text("Private Folios (Locked, Unshared)").foregroundColor(Color.primary))
            {
                if vm.folios.isEmpty {
                    Text("No Private Folios.") // Placeholder
                        .font(.caption2)
                } else {
                    ForEach(vm.folios) { folio in
                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: FolioDetailView(folio: folio )) {
                                    FolioCell(folio: folio)
                                }
                        }

                    }
                    .onDelete(perform: deleteFolios)
                }
            }
            .headerProminence(.increased).padding(4)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Section(header: Text("Folios You Are Sharing").foregroundColor(.green))
            {
                if vm.sharingfolios.isEmpty {
                    Text("Sharing No Folios.") // Placeholder
                        .font(.caption2)
                } else {
                    ForEach(vm.sharingfolios) { folio in
                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: FolioDetailView(folio: folio )) {
                                    FolioCell(folio: folio)
                                }
                        }

                    }
                    .onDelete(perform: deleteFolios)
                }
            }
            .headerProminence(.increased).padding(4)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Section(header: Text("Folios Shared with You").foregroundColor(.green))
            {
                if vm.sharedfolios.isEmpty {
                    Text("No one is sharing folios with you.") // Placeholder
                        .font(.caption2)
                } else {
                    ForEach(vm.sharedfolios) { folio in
                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: FolioDetailView(folio: folio )) {
                                    FolioCell(folio: folio)
                                }
                        }

                    }
                    .onDelete(perform: deleteFolios)
                }
            }
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
        .navigationBarTitle("Current Folio Sharing")
        .navigationBarTitleDisplayMode(.inline)
        //.navigationBarHidden(true)
        //        }
    }
    
    func didDismiss() {
        isTemplatesActive = false
        vm.newFolio = nil
        vm.fetchData()
    }
    
    private func deleteFolios(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.folios[$0] }.forEach(Storage.shared.vc.delete)
        }
        Storage.shared.save()
        vm.fetchData()
    }
}

struct FolioListSegView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
