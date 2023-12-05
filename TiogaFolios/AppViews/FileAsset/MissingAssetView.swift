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
        Text("No Document Here Yet.")
            .font(.title2)
        
        Text("")
        Text("To replace this empty document with one of yours, click the blue Add + button.")
        Text("You can also delete this empty document holder, if you'd like.")
        Spacer()
    }
}

struct MissingAssetView_Previews: PreviewProvider {
    static var previews: some View {
        MissingAssetView()
    }
}
