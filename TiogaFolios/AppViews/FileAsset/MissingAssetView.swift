//
//  MissingAssetView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 1/20/23.
//

import SwiftUI

struct MissingAssetView: View {
    var body: some View {
        Spacer()
        Text("Empty Document")
            .font(.title2)
        
        Text("")
        Text("To replace this empty document with yours, click the blue Add + button.")
        Spacer()
    }
}

struct MissingAssetView_Previews: PreviewProvider {
    static var previews: some View {
        MissingAssetView()
    }
}
