//
//  FolioDetailAssetList.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 10/12/23.
//

import SwiftUI

struct FolioDetailAssetList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var vm: FolioVM
    
    var body: some View {
        HStack {
            Text("Attached Documents").font(.caption2.italic())
            Spacer()
            //Button("Edit List") { activeSheet = .editAssetsView(vm.folio) }
            EditButton()
        }
        List { Section {
            ForEach(vm.assetList, id: \.self) { asset in
                NavigationLink(
                    destination:  FileAssetDetail(vm: FileAssetDetailVM(anAsset: asset, showAssignTo: false))) {
                        AssetRow(asset: asset)
                    }
            }
            .onDelete(perform: delete)
        }
            
        }
        .refreshable {
            vm.refresh()
        }
        .listStyle(PlainListStyle())
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.assetList[$0] }.forEach(viewContext.delete)
            Storage.shared.save()
        }
        vm.refresh()
    }

}

struct FolioDetailAssetList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
