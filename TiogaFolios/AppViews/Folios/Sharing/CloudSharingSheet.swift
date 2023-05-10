//
//  CloudSharingSheet.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 5/10/23.
//

import SwiftUI

struct CloudSharingSheet: View {
    
    @Binding var activeSheet: ActiveSheet?

    var folio: Folio

    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        self.folio = folio
    }
    
    var body: some View {
        VStack{
            let share = Storage.shared.getShare(folio)!
            let sharingContainer = Storage.shared.ckContainer
            CloudSharingView(share: share, container: sharingContainer, folio: folio)
                .ignoresSafeArea()
        }
        .onAppear(){
        }
        .onDisappear() {
        }
    }
}

struct CloudSharingSheet_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
