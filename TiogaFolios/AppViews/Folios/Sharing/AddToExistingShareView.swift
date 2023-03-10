/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A SwiftUI view that adds a photo to an existing share.
*/

import SwiftUI
import CoreData
import CloudKit

struct AddToExistingShareView: View {
    @Binding var activeSheet: ActiveSheet?
    var folio: Folio
    
    @State private var toggleProgress: Bool = false
    @State private var selection: String?

    var body: some View {
        ZStack {
            SharePickerView(activeSheet: $activeSheet, selection: $selection) {
                Button("Add") { shareFolio(folio, shareTitle: selection) }
                .disabled(selection == nil)
            }
            if toggleProgress {
                ProgressView()
            }
        }
    }
    
    private func shareFolio(_ unsharedFolio: Folio, shareTitle: String?) {
        toggleProgress.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let persistenceController = Storage.shared
            if let shareTitle = shareTitle, let share = persistenceController.share(with: shareTitle) {
                persistenceController.shareObject(unsharedFolio, to: share)
            }
            toggleProgress.toggle()
            activeSheet = nil
        }
    }
}
