//
//  FolioDetailAssetList.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 10/12/23.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct FolioDetailAssetList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var vm: FolioVM
    
    var body: some View {
        GridView()
            .environmentObject(vm)
            .onDrop(of: ["public.url","public.file-url", "public.text", "com.adobe.pdf"], isTargeted: nil) { providers -> Bool in
                print(providers)
                print(providers.count)
                providers.forEach { item in
                    if item.hasItemConformingToTypeIdentifier("public.text") {
                        item.loadDataRepresentation(forTypeIdentifier: "public.text") { data, error in
                            guard error == nil else {
                                print("loading prob \(String(describing: error))")
                                return
                            }
                            let fname = item.suggestedName?.split(separator: ".").map(String.init).first ?? "unknown"
                            if let data = data {
                                //self.addNoteWith(title: fname, body: String(decoding: data, as: UTF8.self))
                                let td = Asset.makeNewTextDoc(named: fname, content: String(decoding: data, as: UTF8.self))
                                vm.folio.addToAssets(td)

                                self.vm.flushChanges()
                            }
                        }
                    }
                    if item.hasItemConformingToTypeIdentifier("com.adobe.pdf") {
                        item.loadDataRepresentation(forTypeIdentifier: "com.adobe.pdf") { data, error in
                            guard error == nil else {
                                print("loading prob \(String(describing: error))")
                                return
                            }
                            let fname = item.suggestedName ?? "untitled pdf"//?.split(separator: ".").map(String.init).first ?? "unknown"
                            if let data = data {
                                let td = Asset.makeNewPDFDoc(named: fname, content: data)
                                vm.folio.addToAssets(td)
                                self.vm.flushChanges()
                                
                            }
                        }
                    }
                    if item.hasItemConformingToTypeIdentifier("public.url") {
                        item.loadDataRepresentation(forTypeIdentifier: "public.url") { data, error in
                            guard error == nil else {
                                print("loading prob \(String(describing: error))")
                                return
                            }
                            let fname = item.suggestedName ?? "unknown"
                            if let data = data {
                                let td = Asset.makeNewURLDoc(named: fname, content: data)
                                vm.folio.addToAssets(td)

                                self.vm.flushChanges()
                            }
                        }
                    }
                }
                vm.refresh()
                return true
            }
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
                //.frame(width: size, height: size)

//            AsyncImage(url: item.thumbnail) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//            } placeholder: {
//                ProgressView()
//            }
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
        .navigationBarTitleDisplayMode(.inline)
    }
}
