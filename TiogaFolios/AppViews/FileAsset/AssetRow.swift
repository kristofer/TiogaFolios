//
//  AssetRow.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/14/22.
//
//
//  AssetRow.swift
//  tiogafolios-beta
//
//  Created by Kristofer on 5/5/20.
//  Copyright © 2020 Kristofer. All rights reserved.
//

import SwiftUI

var demoAsset = Asset()

struct AssetRow: View {
    var asset: Asset
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
            .resizable()
            //.frame(width: 40, height: 60)
            .border(.gray)
            VStack(alignment: .leading) {
                Text("\(asset.title ?? "none")")
            }
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        guard asset.thumbnail == nil else {
            image = Image(uiImage: UIImage(data: (asset.thumbnail!))!)

            return
        }
        image = Image(systemName: "doc.richtext")
    }
}

struct AssetRow_Previews: PreviewProvider {
    
    static var previews: some View {
        AssetRow(asset: demoAsset)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
