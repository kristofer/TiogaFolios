//
//  FileAssetEditList.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 8/11/22.
//  Cleaned by Kristofer Younger on 3/7/23.
//

import SwiftUI

class FileAssetEditViewModel: ObservableObject {
    @Published var docs = [Asset]()
    @Published var folio: Folio
    
    init(docs: [Asset] = [Asset](), folio: Folio) {
        self.folio = folio
        self.docs = Array(folio.assets as? Set<Asset> ?? [])
    }
    
    func refresh() {
        self.docs = Array(folio.assets as? Set<Asset> ?? [])
    }

    
}

struct FileAssetEditList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var vm: FileAssetEditViewModel
    
    @Binding var activeSheet: ActiveSheet?
    
    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        vm = FileAssetEditViewModel(docs: [], folio: folio)
    }
    
    var body: some View {
        VStack{
            HStack {
                Text("Attached Documents to \(vm.folio.title ?? "??")")
                    .font(.body.bold())
                    .foregroundColor(Color.accentColor)
                    .padding(5)
                Spacer()
                Button("Done."){
                    vm.folio.touch()
                    Storage.shared.save()
                    activeSheet = nil
                }
            }
            Divider()
            NavigationView {
                List {
                    ForEach(vm.docs) { doc in
                        NavigationLink(
                            destination: FileAssetDetail(anAsset: doc, showAssignTo: false)) {
                                AssetRow(asset: doc)
                            }
                    }
                    .onDelete(perform: deleteDocs)
                }
                .listStyle(PlainListStyle())
#if os(iOS)
                .navigationTitle(Text("Swipe left to Delete"))
                .navigationBarTitleDisplayMode(.inline)
#else
                // mac desktop
#endif
                Text("No files attached.")
            }
        }
    }
    
    private func deleteDocs(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.docs[$0] }.forEach(viewContext.delete)
            Storage.shared.save()
        }
        vm.refresh()
    }
}

struct FileAssetEditList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
