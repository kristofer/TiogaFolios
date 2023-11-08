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
        GridView()
            .environmentObject(vm)
            //.navigationViewStyle(.stack)
//        HStack {
//            Text("Attached Documents").font(.caption2.italic())
//            Spacer()
//            //Button("Edit List") { activeSheet = .editAssetsView(vm.folio) }
//            EditButton()
//        }
//        List { Section {
//            ForEach(vm.assetList, id: \.self) { asset in
//                NavigationLink(
//                    destination:  FileAssetDetail(vm: FileAssetDetailVM(anAsset: asset, showAssignTo: false))) {
//                        AssetRow(asset: asset)
//                    }
//            }
//            .onDelete(perform: delete)
//        }
//            
//        }
//        .refreshable {
//            vm.refresh()
//        }
//        .listStyle(PlainListStyle())
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.assetList[$0] }.forEach(viewContext.delete)
            Storage.shared.save()
        }
        vm.refresh()
    }

}

struct GridItemView: View {
    let size: Double
    let asset: Asset


    var body: some View {
        ZStack(alignment: .topTrailing) {
            AssetRow(asset: asset)
//            AsyncImage(url: item.thumbnail) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//            } placeholder: {
//                ProgressView()
//            }
            .frame(width: size, height: size)
        }
    }
}

struct GridView: View {
    @EnvironmentObject var vm: FolioVM
    @Environment(\.dismiss) var dismiss


    private static let initialColumns = 3
    @State private var isAddingPhoto = false
    @State private var isEditing = false


    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State private var numColumns = initialColumns
    
    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }
    
    var body: some View {
        VStack {
//            if isEditing {
//                ColumnStepper(title: columnsTitle, range: 1...8, columns: $gridColumns)
//                .padding()
//            }
            HStack(){
                Spacer()
                Button(isEditing ? "Done" : "Remove Items") {
                    withAnimation { isEditing.toggle() }
                }

            }
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(vm.assetList) { asset in
                        GeometryReader { geo in
                            NavigationLink(destination:
                                            FileAssetDetail(vm: FileAssetDetailVM(anAsset: asset, showAssignTo: false))) {
                                GridItemView(size: geo.size.width, asset: asset)
                            }
                        }
                        .cornerRadius(8.0)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(alignment: .topTrailing) {
                            if isEditing {
                                Button {
                                    withAnimation {
                                        //dataModel.removeItem(item)
                                    }
                                } label: {
                                    Image(systemName: "xmark.square.fill")
                                                .font(Font.title)
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(.white, .red)
                                }
                                .offset(x: 7, y: -7)
                            }
                        }
                    }
                }
                .padding()
            }
        }
//        .navigationBarTitle("Assets")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    isAddingPhoto = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//                .disabled(isEditing)
//            }
//        }
    }
}


//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView().environmentObject(DataModel())
//            .previewDevice("iPad (8th generation)")
//    }
//}
