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
    case filePicker
    case participantView(CKShare)
    case cloudSharingSheet(CKShare)
    case managingSharesView
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

class FolioVM: ObservableObject {
    @Published var folio: Folio
    @Published var assetList: [Asset]
    
    @Published var isImporting: Bool = false
    @Published var showAlert: Bool = false
    @Published var showError: Error? = nil
    @Published var errormsg = ""
    @Published var message: Message? = nil
        
    @Published var share: CKShare?
    @Published var showShareSheet = false

    let store = Storage.shared

    init(folio: Folio) {
        self.folio = folio
        self.assetList = Array(folio.assets as? Set<Asset> ?? [])
    }
    
    func refresh() {
        print("refreshing asset list")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.assetList = //Asset.fetchAssets(vc: self.store.vc, folio: self.folio)
                    Array(self.folio.assets as? Set<Asset> ?? [])
        }
    }
    
}

struct FolioDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var vm: FolioVM
    
    @State private var activeSheet: ActiveSheet?
    /**
     The next active sheet to present after dismissing the current sheet.
     ManagingSharesView uses this variable to switch to UICloudSharingController or participant view.
     */
    @State private var nextSheet: ActiveSheet?
    
    init(folio: Folio) {
        vm = FolioVM(folio: folio)
        //assets = FolioVM.assetsForFolio(folio)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(vm.folio.desc ?? "-")
                    .font(.body.italic())
            }
            Divider()
            FolioTagItems(folio: vm.folio)
            Divider()
            HStack {
                Text("Attached Documents").font(.caption2.italic())
                Spacer()
                Button("Edit List") { activeSheet = .editAssetsView(vm.folio) }
            }
            List { Section {
                ForEach(vm.assetList, id: \.self) { doc in
                    NavigationLink(
                        destination: FileAssetDetail(anAsset: doc, showAssignTo: false)) { //doc: doc)) {
                            AssetRow(asset: doc)
                        }
                }}
                
            }
            .refreshable {
                vm.refresh()
            }
            .onAppear(){
                vm.refresh()
            }
            .listStyle(PlainListStyle())
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
        }
        .padding()
        .toolbar { toolbarItems() } // title display here.
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $vm.showShareSheet, content: {
            if let share = vm.share {
                CloudSharingView(
                    share: share,
                    container: vm.store.ckContainer,
                    folio: vm.folio
                )
            } else {Text("Share unavailable")}
        })
        .sheet(item: $activeSheet, onDismiss: sheetOnDismiss) { item in
            sheetView(with: item)
        }
        
    }
    
    @ViewBuilder
    private func sheetView(with item: ActiveSheet) -> some View {
        switch item {
        case .filePicker:
            //            FilePicker(activeSheet: $activeSheet)
            EmptyView()
            
        case .cloudSharingSheet(_):
            /**
             Reserve this case for something like CloudSharingSheet(activeSheet: $activeSheet, share: share).
             */
            EmptyView()
            
        case .managingSharesView:
            //            ManagingSharesView(activeSheet: $activeSheet, nextSheet: $nextSheet)
            EmptyView()
            
            //
        case .sharePicker(let folio):
            //            AddToExistingShareView(activeSheet: $activeSheet, photo: photo)
            EmptyView()
            
            
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
            
        case .participantView(let share):
            //            ParticipantView(activeSheet: $activeSheet, share: share)
            EmptyView()
            
        }
    }
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack {
                Image(systemName: "magazine")
                    .foregroundColor(Color.accentColor)
                Text(vm.folio.title ?? "")
                    .font(.body.bold())
                    .foregroundColor(Color.accentColor)
                Spacer()
                Menu {
                    Button("Edit Folio Name...") { activeSheet = .deltaFolioView(vm.folio) }
                    Button("Change Tags...") { activeSheet = .taggingView(vm.folio) }
                    Button("Add to Folio...", action: addtofolio)
                    Button("Scan to Folio...") { activeSheet = .scanningView(vm.folio) }
                    Button("Add Note...") { activeSheet = .addNoteView(vm.folio) }
                    Button("Share Folio...", action: sharefolio)
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
        }
    }
    
    /**
     Present the next active sheet, if necessary.
     Dispatch asynchronously to the next run loop so the presentation occurs after the current sheet's dismissal.
     */
    private func sheetOnDismiss() {
        guard let nextActiveSheet = nextSheet else {
            return
        }
        switch nextActiveSheet {
        case .cloudSharingSheet(let share):
            DispatchQueue.main.async {
                //persistenceController.presentCloudSharingController(share: share)
            }
        default:
            DispatchQueue.main.async {
                activeSheet = nextActiveSheet
            }
        }
        nextSheet = nil
        vm.refresh()
    }
        
    func addtofolio() {
        self.vm.isImporting = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.vm.isImporting = true
        }
    }

    func sharefolio() {
        self.vm.message = Message(text: "sharing is unavailable")
        //        if !store.isShared(object: folio) {
        //          Task {
        //            await createShare(folio)
        //          }
        //        }
        //        showShareSheet = true
        
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
                print("error: found an RTFD file",selectedFile,range3)
            } else {
                print("continue")
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
    
}

struct FolioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
