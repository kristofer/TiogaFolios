//
//  FolioDetailView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 3/1/23.
//

import SwiftUI
import CoreData
import CloudKit
import UniformTypeIdentifiers


enum ActiveSheet: Identifiable, Equatable {
    case participantView(CKShare)
    case cloudSharingSheet(Folio)
    case managingSharesView(Folio)
    case sharePicker(Folio)
    case taggingView(Folio)
    case addNoteView(Folio)
    case deltaFolioView(Folio)
    case scanningView(Folio)
    case editAssetsView(Folio)
    /**
     Use the enumeration member name string as the identifier for Identifiable.
     In the case where an enumeration has an associated value, use the label, which is equal to the member name string.
     */
    var id: String {
        let mirror = Mirror(reflecting: self)
        if let label = mirror.children.first?.label {
            return label
        } else {
            return "\(self)"
        }
    }
}

@MainActor class FolioVM: ObservableObject {
    @Published var folio: Folio
    @Published var assetList: [Asset]
    
    @Published var isImporting: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Error? = nil
    @Published var errormsg = ""
    @Published var message: Message? = nil
    
    //@Published var share: CKShare?
    //@Published var showShareSheet = false
    
    let store = Storage.shared
    
    init(folio: Folio) {
        self.folio = folio
        self.assetList = Array(folio.assets as? Set<Asset> ?? [])
        self.assetList.sort {
            $0.lastmodified! > $1.lastmodified!
        }
    }
    
    func refresh() {
        self.folio = self.folio.refetchFolio(vc: Storage.shared.vc)!
        tfDebug("refreshing asset list")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //self.folio.touch()
            self.assetList = Array(self.folio.assets as? Set<Asset> ?? [])
            self.assetList.sort {
                $0.lastmodified! > $1.lastmodified!
            }
        }
    }
    
    func flushChanges() {
        Storage.shared.vc.flushChanges()
    }
    
}

struct FolioDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var vm: FolioVM
    //@StateObject var vm: FolioVM
    
    @State private var activeSheet: ActiveSheet?
    /**
     The next active sheet to present after dismissing the current sheet.
     ManagingSharesView uses this variable to switch to UICloudSharingController or participant view.
     */
    @State private var nextSheet: ActiveSheet?
    @State private var share: CKShare?
    
    init(folio: Folio) {
        vm = FolioVM(folio: folio)
        //assets = FolioVM.assetsForFolio(folio)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.background)
                .shadow(radius: 10)
                .padding(5)
            VStack(alignment: .leading){
                // other header stuff in navigation section
                HStack {
                    Text(vm.folio.title ?? "")
                        .font(.title2.bold())
                        .foregroundColor(Color.accentColor)
                    Image(systemName: Folio.sharingState(vm.folio))
                        .foregroundColor(Color.accentColor)
                        .font(.system(size: 24))
                    Spacer()
                    Menu {
                        Button("Edit Folio Name...") { activeSheet = .deltaFolioView(vm.folio) }
                        Button("Change Tags...") { activeSheet = .taggingView(vm.folio) }
                        Divider()
                        Button("Add to Folio...", action: addtofolio)
                        Button("Scan to Folio...") { activeSheet = .scanningView(vm.folio) }
                        Button("Add Note...") { activeSheet = .addNoteView(vm.folio) }
                        Divider()
                        Button("Start Share Folio...") {
                            Task { await createShare(vm.folio) }
                            activeSheet = .cloudSharingSheet(vm.folio)
                        }
                        .disabled(self.share != nil)
                        Button("Manage Share") {
                            // manageParticipation(folio: vm.folio)
                            activeSheet = .cloudSharingSheet(vm.folio)
                        }
                        .disabled(self.share == nil)
                        Button("Delete Share") {
                            Task { await deleteShareFor(folio: vm.folio)}  }
                        .disabled(self.share == nil)
                    } label: {
                        Label("", systemImage: "contextualmenu.and.cursorarrow")
                    }
                    .alert(item: $vm.message) { message in
                        Alert(
                            title: Text(message.text),
                            dismissButton: .cancel()
                        )
                    }
                }
                HStack{
                    Text(vm.folio.desc ?? "-")
                        .font(.body.italic())
                        .foregroundColor(Color.accentColor)
                    Text(folioDateFormatter.string(from: vm.folio.lastmodified!))
                }
                if let share = share {
                    FolioShareMetadataView(share: share)
                }
                Divider()
                FolioTagItems(folio: vm.folio).foregroundColor(Color.accentColor)
                Divider()
                //NavigationLink("FOOBAR") {
                    FolioDetailAssetList(vm: vm)
                        .fileImporter(
                            isPresented: $vm.isImporting,
                            allowedContentTypes: [UTType.content, UTType.compositeContent],
                            allowsMultipleSelection: false
                        ) { result in
                            importFile(result)
                        }
                        .alert(isPresented: $vm.showAlert) {
                            Alert(title: Text("Unable to Archive File"),
                                  message: Text("\(vm.showError!.localizedDescription) \(self.vm.errormsg)"),
                                  dismissButton: .default(Text("Ok")))
                        }
                //}
            }
            .padding()
            .onAppear() {
                self.share = Storage.shared.getShare(vm.folio)
            }
            .toolbar { toolbarItems() } // title display here.
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $activeSheet, onDismiss: sheetOnDismiss) { item in
                sheetView(with: item)
            }
            
        }
    }
    
    @ViewBuilder
    private func sheetView(with item: ActiveSheet) -> some View {
        switch item {
            
        case .cloudSharingSheet(let folio):
            CloudSharingSheet(activeSheet: $activeSheet, folio: folio)
            
        case .participantView(let share):
            ParticipantView(activeSheet: $activeSheet, share: share)
            
        case .managingSharesView(let folio):
            ManagingSharesView(activeSheet: $activeSheet, nextSheet: $nextSheet, folio: folio)
            
        case .sharePicker(let folio):
            AddToExistingShareView(activeSheet: $activeSheet, folio: folio)
            
        case .taggingView(let folio):
            ContentTagView(activeSheet: $activeSheet, folio: folio)
            
        case .deltaFolioView(let folio):
            FolioDeltaView(activeSheet: $activeSheet, folio: folio)
            
        case .addNoteView(let folio):
            NewNoteView(activeSheet: $activeSheet, folio: folio)
            
        case .scanningView(let folio):
            ScannerView(activeSheet: $activeSheet, folio: folio)
            
        case .editAssetsView(let folio):
            FileAssetEditList(activeSheet: $activeSheet, folio: folio)
            
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            
        }
    }
    
    /**
     Present the next active sheet, if necessary.
     Dispatch asynchronously to the next run loop so the presentation occurs after the current sheet's dismissal.
     */
    private func sheetOnDismiss() {
        vm.refresh()
        guard let nextActiveSheet = nextSheet else {
            return
        }
        switch nextActiveSheet {
            //        case .cloudSharingSheet(let share):
            //            DispatchQueue.main.async {
            //                //Storage.shared.presentCloudSharingController(share: share)
            //            }
        default:
            DispatchQueue.main.async {
                activeSheet = nextActiveSheet
            }
        }
        nextSheet = nil
    }
    
    func addtofolio() {
        self.vm.isImporting = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vm.isImporting = true
        }
    }
    
    private let folioDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()

    // error The owner stopped sharing, or you don’t have permission to open it.
    
    // private
    func manageParticipation(folio: Folio) {
        self.share = Storage.shared.existingShare(folio: vm.folio)
        if let share = self.share {
            //share.title = folio.title + " Share"
            tfDebug("setting up for managing a share \(share.title)")
            nextSheet = .participantView(share)
            activeSheet = .managingSharesView(vm.folio)
        }
        
    }
    
    // private
    func deleteShareFor(folio: Folio) async {
        let thisContext = Storage.shared.container.viewContext
        
        if let share = self.share {
            
            let _ = try? folio.deepcopy(context: thisContext)
            Storage.shared.save()
            Tag.dedupeTags()
            Storage.shared.save()
            
            tfDebug("share \(share.title) will be deleted")
            let ckContainer = Storage.shared.cloudKitContainer
            let persistentStore = share.persistentStore
            
            do {
                Storage.shared.purgeObjectsAndRecords(with: share, in: persistentStore)
                
                try await ckContainer.privateCloudDatabase.deleteRecord(withID: share.recordID)
                thisContext.delete(folio)
            } catch {
                tfDebug("Failed to delete ckshare in icloud, error: \(error)")
            }
            self.share = nil
        } else {
            tfDebug("no share to delete")
        }
    }
    
    private var isShared: Bool {
        Storage.shared.isShared(object: vm.folio)
    }
    
    private var canEdit: Bool {
        Storage.shared.canEdit(object: vm.folio)
    }
    
    
    func createShare(_ folio: Folio) async {
        do {
            let (_, share, _) = try await Storage.shared.container.share([folio], to: nil)
            share[CKShare.SystemFieldKey.title] = folio.title
        } catch {
            tfDebug("Failed to create share")
        }
    }
    
    private func importFile(_ result: Result<[URL], Error> ) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            //trying to get access to url contents
            guard selectedFile.startAccessingSecurityScopedResource() else { return }
            //print(selectedFile)
            let teststr = selectedFile.absoluteString
            if let range3 = teststr.range(of: ".rtfd", options: .caseInsensitive) {
                // match
                self.vm.errormsg = "error: unable to archive an RTFD file, \(selectedFile)"
                tfDebug("error: found an RTFD file",selectedFile,range3)
            } else {
                tfDebug("continue")
            }
            
            let blob = try Data(contentsOf: selectedFile) as Data?
            
            let typeID = try selectedFile.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
            
            selectedFile.stopAccessingSecurityScopedResource()
            
            if let typeID = typeID, let blob = blob {
                let viewContext = Storage.shared.vc
                let fileasset = Asset(vc: viewContext, title: selectedFile.lastPathComponent,
                                      path: selectedFile.absoluteString,
                                      mimetype: UTType(typeID)?.preferredMIMEType! ?? Asset.defaultBlobMimeType(),
                                      uttype: typeID)
                fileasset.setBlob(blob)
                vm.folio.addToAssets(fileasset)
                vm.folio.touch()
                Storage.shared.save()
                vm.refresh()
            }
        } catch {
            // Handle failure.
            print(error.localizedDescription)
            vm.showAlert = true
            vm.showError = error
        }
    }
    
    // for the eventual showing of sharing statuses
    func string(for permission: CKShare.ParticipantPermission) -> String {
        switch permission {
        case .unknown:
            return "Unknown"
        case .none:
            return "None"
        case .readOnly:
            return "Read-Only"
        case .readWrite:
            return "Read-Write"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.Permission")
        }
    }
    
    func string(for role: CKShare.ParticipantRole) -> String {
        switch role {
        case .owner:
            return "Owner"
        case .privateUser:
            return "Private User"
        case .publicUser:
            return "Public User"
        case .unknown:
            return "Unknown"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.Role")
        }
    }
    
    func string(for acceptanceStatus: CKShare.ParticipantAcceptanceStatus) -> String {
        switch acceptanceStatus {
        case .accepted:
            return "Accepted"
        case .removed:
            return "Removed"
        case .pending:
            return "Invited"
        case .unknown:
            return "Unknown"
        @unknown default:
            fatalError("A new value added to CKShare.Participant.AcceptanceStatus")
        }
    }
    
}

struct FolioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
