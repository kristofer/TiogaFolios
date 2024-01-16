////
////  NoteDetailView.swift
////  NoteDetailView
////
////  Created by Yang Xu on 2021/9/9.
////
//
//import CloudKit
//import CoreData
//import Foundation
//import SwiftUI
//import UIKit
//
//struct FolioMiniDetailView: View {
//    let folio: Folio
//    private let store = Storage.shared
//    @State private var showShareController = false
//    @FetchRequest private var assets: FetchedResults<Asset>
//    @State var sharing = false
//
//    init(folio: Folio) {
//        self.folio = folio
//        _assets = FetchRequest(entity: Asset.entity(),
//                               sortDescriptors: [NSSortDescriptor(keyPath: \Asset.lastmodified, ascending: false)],
//                               predicate: NSPredicate(format: "%K = %@", #keyPath(Asset.folio), folio),
//                              animation: .default)
//    }
//
//    var body: some View {
//        List {
//            ForEach(assets) { asset in
//                Text(asset.title ?? "")
//                    .swipeActions {
//                        if canEdit {
//                            Button(role: .destructive) {
//                                //stack.deleteMemo(memo)
//                            }
//                            label: {
//                                Label("Del", systemImage: "trash")
//                            }
//                            Button {
//                                //stack.changeMemoText(memo)
//                            }
//                            label: {
//                                Label("Edit", systemImage: "square.and.pencil")
//                            }
//                            .tint(.orange)
//                        }
//                    }
//            }
//        }
//        .toolbar {
//            ToolbarItem {
//                HStack {
//                    if sharing {
//                        ProgressView()
//                    }
//
//                    Button {
//                        if isShared {
//                            showShareController = true
//                        } else {
//                            // 先出现弹窗，后生成ckshare，用户体验会更好些
////                            openSharingController(note: note)
//                            // 生成ckshare后弹窗
//                            // The pop-up window appears first, then ckshare is generated, the user experience will be better
//                            // openSharingController(note: note)
//                                                         // popup window after generating ckshare
//                            Task.detached {
//                                await createShare(folio)
//                            }
//                        }
//                    }
//                    label: {
//                        Image(systemName: "square.and.arrow.up")
//                    }
////                    if canEdit {
////                        Button {
////                            withAnimation {
////                                stack.addMemo(note)
////                            }
////                        }
////                        label: {
////                            Image(systemName: "plus")
////                        }
////                    }
//                }
//                .controlGroupStyle(.navigation)
//            }
//        }
//        .navigationTitle(folio.title ?? "")
//        .sheet(isPresented: $showShareController) {
//            let share = store.getShare(folio)!
//            let sharingContainer = Storage.shared.ckContainer
//            CloudSharingView(share: share, container: sharingContainer, folio: folio)
//                .ignoresSafeArea()
//        }
//    }
//
//    private func openSharingController(folio: Folio) {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter { $0.activationState == .foregroundActive }
//            .map { $0 as? UIWindowScene }
//            .compactMap { $0 }
//            .first?.windows
//            .filter { $0.isKeyWindow }.first
//
//        let sharingController = UICloudSharingController {
//            (_, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
//            store.container.share([folio], to: nil) { _, share, container, error in
//                if let actualShare = share {
//                    folio.managedObjectContext?.performAndWait {
//                        actualShare[CKShare.SystemFieldKey.title] = folio.title
//                    }
//                }
//                completion(share, container, error)
//            }
//        }
//
//        keyWindow?.rootViewController?.present(sharingController, animated: true)
//    }
//
//    private var isShared: Bool {
//        store.isShared(object: folio)
//    }
//
//    private var canEdit: Bool {
//        store.canEdit(object: folio)
//    }
//
//    func createShare(_ folio: Folio) async {
//        sharing = true
//        do {
//            let (_, share, _) = try await store.container.share([folio], to: nil)
//            share[CKShare.SystemFieldKey.title] = folio.title
//        } catch {
//            tfDebug("Failed to create share")
//            sharing = false
//        }
//        sharing = false
//        showShareController = true
//    }
//}
