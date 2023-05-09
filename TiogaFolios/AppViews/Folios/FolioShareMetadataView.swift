//
//  FolioShareMetadataView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 5/9/23.
//

import SwiftUI
import CloudKit

struct FolioShareMetadataView: View {
    var share: CKShare
    
    init(share: CKShare) {
        self.share = share
    }

    var body: some View {
        let participants: [String] = share.participants.filter { $0.role != .owner }.map { ($0.userIdentity.nameComponents?.formatted())! }
        let owner: [String]  = share.participants.filter { $0.role == .owner }.map { ($0.userIdentity.nameComponents?.formatted())! }
        if amOwner(share: share) {
            Text("Sharing with \(participants.joined(separator: ", "))")
                .font(.caption.italic())
        } else {
            Text("Shared with you by \(owner.joined(separator: ", "))")
                .font(.caption.italic())
        }
    }
    
    private func amOwner(share: CKShare) -> Bool {
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }

}

struct FolioShareMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
