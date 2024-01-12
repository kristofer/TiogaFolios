//
//  CloudSharingSheet.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 5/10/23.
//

import SwiftUI
import CloudKit
import CoreData


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
            let persistentStore = share.persistentStore
            let isPrivateStore = (persistentStore == Storage.shared.privatePersistentStore)
            CloudSharingView(share: share, container: sharingContainer, folio: folio)
                .ignoresSafeArea()
            Button(isPrivateStore ? "Stop Sharing" : "Remove Me") {
//                if let share = Storage.shared.existingShare(folio: folio) {
//                    purgeShare(share, in: persistentStore)
//                }
            }
            .padding(20)
        }
        .onAppear(){
        }
        .onDisappear() {
        }
    }
    
//    private func purgeShare(_ share: CKShare, in persistentStore: NSPersistentStore?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            Storage.shared.purgeObjectsAndRecords(with: share, in: persistentStore)
//            Task { await Storage.shared.delShare(share) }
//            activeSheet = nil
//        }
//    }

}

struct CloudSharingSheet_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
