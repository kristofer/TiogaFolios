/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A SwiftUI view that manages existing shares.
*/

import SwiftUI
import CoreData
import CloudKit

struct ManagingSharesView: View {
    @Binding var activeSheet: ActiveSheet?
    @Binding var nextSheet: ActiveSheet?
    var folio: Folio

    @State private var toggleProgress: Bool = false

    var body: some View {
        VStack {
            //SharePickerView(activeSheet: $activeSheet, selection: $selection) {
            if  let share = Storage.shared.existingShare(folio: folio) {
                    actionButtons(for: share)
                }
            //}
//            if toggleProgress {
//                ProgressView()
//            }
        }
    }
    
    @ViewBuilder
    private func actionButtons(for share: CKShare) -> some View {
        let persistentStore = share.persistentStore
        let isPrivateStore = (persistentStore == Storage.shared.privatePersistentStore)
        
        Button(isPrivateStore ? "Manage Participants" : "View Participants") {
            if let share = Storage.shared.existingShare(folio: folio) {
                nextSheet = .participantView(share)
                activeSheet = nil
            }
        }
        
        Button(isPrivateStore ? "Stop Sharing" : "Remove Me") {
            if let share = Storage.shared.existingShare(folio: folio) {
                purgeShare(share, in: persistentStore)
            }
        }

        Button("Manage With UICloudSharingController") {
            if let share = Storage.shared.existingShare(folio: folio) {
                nextSheet = .cloudSharingSheet(share)
                activeSheet = nil
            }
        }
    }
    
    private func purgeShare(_ share: CKShare, in persistentStore: NSPersistentStore?) {
        toggleProgress.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            Storage.shared.purgeObjectsAndRecords(with: share, in: persistentStore)
            toggleProgress.toggle()
            activeSheet = nil
        }
    }
}
