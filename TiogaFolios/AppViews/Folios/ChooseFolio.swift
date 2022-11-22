//
//  ChooseFolio.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/21/22.
//

import SwiftUI

struct ChooseFolio: View {
    var assetToAssign: Asset
    //@State private var selection: UUID?
    @ObservedObject var vm = FolioListViewModel()
    
    init(asset: Asset) {
        assetToAssign = asset
    }
    
    var body: some View {
        VStack{
            Text("Available Folios")
            Divider()
            List{
                ForEach(vm.folios, id: \.id) { folio in
                    HStack{
                        Text(folio.title ?? "nothing")
//                        Button(folio.title!) {
//                            folio.addToAssets(assetToAssign)
//                        }

                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            
        }
        .onAppear(perform: {
            print("KKYY appearing.")
            vm.fetchData()
        })
        .onDisappear(perform: {
            print("KKYY disappear")
        })

        
    }
}

struct ChooseFolio_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
