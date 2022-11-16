//
//  FolioView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import SwiftUI

struct FolioView: View {
    @ObservedObject var folio: Folio
    
    @State private var isEditing = false
    @State private var addingItems = false
    @State private var navigateTo = ""
    @State private var isActive = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(folio.desc ?? "-")
                    .font(.body.italic())
                Spacer()
            }
            Divider()
            HStack{
//                Text("As of \(folio.modified ?? .now, style: .date), \(folio.modified ?? .now, style: .time)")
//                    .font(.caption)
                Spacer()
                Button("Edit...") {
                    isEditing = true
                }
                
            }
            .font(.caption)
            
            NavigationLink(destination: ContentTagView(item: folio)) {
                HStack {
                    FolioTagItems(folio: folio)
                    Spacer()
                    Text("Tags...")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.accentColor)
                        .cornerRadius(5)
                }
            }
            
            NavigationView {
                List {
                    ForEach(Array(folio.assets as? Set<Asset> ?? []), id: \.self) { doc in
                        NavigationLink(
                            destination: FileAssetDetail(anAsset: doc)) { //doc: doc)) {
                                Label("\(String(describing: (doc.title ?? "nil doc name")))", systemImage: "doc.richtext")
                            }
                    }
                }
                .navigationBarTitle("Contents", displayMode: .inline)
                .toolbar{
                    ToolbarItem {
                        NavigationLink(
                            destination: AttachDocs(folio: folio)
                        ) {
                            HStack {
                                Text("Add").font(.caption)
                                Image(systemName: "plus").font(.caption)
                            }
                        }
                    }
                }
                
            }
        }
        .padding()
        .navigationTitle(folio.title ?? "?wha?")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditing) {
            FolioDeltaView(objectPassed: folio, show: $isEditing)
        }
    }
    
    func placeOrder() { }
    func adjustOrder() { }
    
}

struct FolioView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

//struct DemoNavigateFromMenu: View {
//    @State private var navigateTo = ""
//    @State private var isActive = false
//    var body: some View {
//        NavigationView {
//            Menu {
//                Button("item1") {
//                    self.navigateTo = "test1"
//                    self.isActive = true
//                }
//                Button("item2") {
//                    self.navigateTo = "test2"
//                    self.isActive = true
//                }
//            } label: {
//                Label("Add", systemImage: "plus")
//            }
//            .background(
//                NavigationLink(destination: Text(self.navigateTo), isActive: $isActive) {
//                    EmptyView()
//                })
//        }
//    }
//}
