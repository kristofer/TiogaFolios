//
//  CloudSharingController.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/15/22.
//

import CloudKit
import SwiftUI

struct CloudSharingView: UIViewControllerRepresentable {
  let share: CKShare
  let container: CKContainer
  let folio: Folio

  func makeCoordinator() -> CloudSharingCoordinator {
    CloudSharingCoordinator(folio: folio)
  }

  func makeUIViewController(context: Context) -> UICloudSharingController {
    // 1
    share[CKShare.SystemFieldKey.title] = folio.title
    // 2
    let controller = UICloudSharingController(share: share, container: container)
    controller.modalPresentationStyle = .formSheet
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {
  }
}

final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
  let store = Storage.shared
  let folio: Folio
  init(folio: Folio) {
    self.folio = folio
  }

  func itemTitle(for csc: UICloudSharingController) -> String? {
    folio.title
  }

  func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
    print("Failed to save share: \(error)")
  }

  func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
    print("Saved the share")
  }

  func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
  }
}
