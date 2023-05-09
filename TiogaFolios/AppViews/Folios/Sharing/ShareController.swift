//
//  ShareController.swift
//  ShareController
//
//  Created by Yang Xu on 2021/9/9.
//

import CloudKit
import Foundation
import SwiftUI
import UIKit

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let folio: Folio

    func makeCoordinator() -> NewCloudSharingCoordinator {
        NewCloudSharingCoordinator.shared
    }

    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = folio.title
        let controller = UICloudSharingController(share: share, container: container)
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        context.coordinator.folio = folio
        return controller
    }

    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {

    }
}

class NewCloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save share\(error)")
    }

    func itemTitle(for csc: UICloudSharingController) -> String? {
        folio?.title
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController){
        
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController){

        guard let folio = folio else {return}
        if !store.isOwner(object: folio) {
            //stack.deleteNote(folio)
            print("删除本地共享数据 - Delete local shared data")
        }
        else {
            // 应该处理掉ckshare,目前不起作用。已提交feedback，希望官方提供正式的恢复方式。
            // 目前我的处理思路是，先对停止共享的托管对象（例如note）在本地进行Deep Copy（包含所有关系数据）
            // 然后调用purgeObjectsAndRecordsInZone删除网络上的共享自定义Zone
            // ckshare should be disposed of, currently does not work. Feedback has been submitted, and we hope that the official will provide a formal recovery method.
            // At present, my processing idea is to perform a deep copy (including all relational data) locally on the managed object (such as note) that has stopped sharing
            // Then call purgeObjectsAndRecordsInZone to delete the shared custom Zone on the network
        }
    }
    static let shared = NewCloudSharingCoordinator()
    let store = Storage.shared
    var folio:Folio?
}


