//
//  FolioView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import SwiftUI
import CoreData
import os
import UniformTypeIdentifiers
import CloudKit

struct FolioView: View {
    @ObservedObject var folio: Folio
    
    @State private var isEditing = false
    @State private var addingItems = false
    @State private var showTagSelection = false
    
    @State private var isImporting: Bool = false
    @State private var showAlert: Bool = false
    @State private var showError: Error? = nil
    @State private var errormsg = ""
    @State private var message: Message? = nil
    
    @State var newTextAlertShowing = false
    @State var newTextDoc = "untitled"
    @State var newTextContent = "untitled"
    
    @State private var share: CKShare?
    @State private var showEditSheet = false
    private let store = Storage.shared
    @State private var showShareSheet = false

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(folio.desc ?? "-")
                    .font(.body.italic())
                //Spacer()

                .background(
                    NavigationLink(destination: ContentTagView(item: folio), isActive: $showTagSelection) {
                        EmptyView()
                    })
                
            }
            
            Divider()
            FolioTagItems(folio: folio)
            Divider()
            
            Text("Attached Documents").font(.caption2.italic())
            List { Section {
                ForEach(Array(folio.assets as? Set<Asset> ?? []),
                        id: \.self) { doc in
                    NavigationLink(
                        destination: FileAssetDetail(anAsset: doc, showAssignTo: false)) { //doc: doc)) {
                            AssetRow(asset: doc)
                        }
                }}
                
                Section {
                  if let share = share {
                    ForEach(share.participants, id: \.self) { participant in
                      VStack(alignment: .leading) {
                        Text(participant.userIdentity.nameComponents?.formatted(.name(style: .long)) ?? "")
                          .font(.headline)
                        Text("Acceptance Status: \(string(for: participant.acceptanceStatus))")
                          .font(.subheadline)
                        Text("Role: \(string(for: participant.role))")
                          .font(.subheadline)
                        Text("Permissions: \(string(for: participant.permission))")
                          .font(.subheadline)
                      }
                      .padding(.bottom, 8)
                    }
                  }
                } header: {
                  Text("Shared With")
                }

            }
            .listStyle(PlainListStyle())
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType.content, UTType.compositeContent],
                allowsMultipleSelection: false
            ) { result in
                importFile(result)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Unable to Archive File"),
                      message: Text("\(showError!.localizedDescription) \(self.errormsg)"),
                      dismissButton: .default(Text("Ok")))
            }
        }
        .padding()
        //.navigationTitle(folio.title ?? "?wha?")
        //.foregroundColor(Color.accentColor)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet, content: {
          if let share = share {
            CloudSharingView(
              share: share,
              container: store.ckContainer,
              folio: folio
            )
          } else {Text("Share unavailable")}
        })
        .onAppear(perform: {
          self.share = store.getShare(folio)
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "magazine")
                        .foregroundColor(Color.accentColor)
                    Text(folio.title ?? "")
                        .font(.body.bold())
                        .foregroundColor(Color.accentColor)
                    Spacer()
                    Menu {
                        Button("Edit Folio Name...", action: editfolio)
                        Button("Change Tags...") {
                            self.showTagSelection = true
                        }
                        Button("Add to Folio...", action: addtofolio)
                        Button("Add Note...", action: addnotetofolio)
                        Button("Share Folio...", action: sharefolio)
                    } label: {
                        Label("", systemImage: "contextualmenu.and.cursorarrow")
                    }
                    .alert(item: $message) { message in
                        Alert(
                            title: Text(message.text),
                            dismissButton: .cancel()
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            FolioDeltaView(objectPassed: folio, show: $isEditing)
        }
    }
    
    func editfolio() { self.isEditing = true }

    func addtofolio() {
        self.isImporting = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isImporting = true
        }
    }

    func addnotetofolio() {
        folio.addToAssets(Asset.makeNewTextDoc(named: "Untitled", content: " "))
        Storage.shared.save()
    }
    
    func reloadAll() {
        Storage.shared.vc.refreshAllObjects()
    }

    func sharefolio() {
        //self.message = Message(text: "share this folio...")
        if !store.isShared(object: folio) {
          Task {
            await createShare(folio)
          }
        }
        showShareSheet = true

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
                self.errormsg = "error: unable to archive an RTFD file, \(selectedFile)"
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
                folio.addToAssets(fileasset)
                folio.touch()
                Storage.shared.save()
                //vm.fetchData()
            }
        } catch {
            // Handle failure.
            print(error.localizedDescription)
            showAlert = true
            showError = error
        }
    }
    
}

struct FolioView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

// MARK: Returns CKShare participant permission
extension FolioView {
  private func string(for permission: CKShare.ParticipantPermission) -> String {
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

  private func string(for role: CKShare.ParticipantRole) -> String {
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

  private func string(for acceptanceStatus: CKShare.ParticipantAcceptanceStatus) -> String {
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
  
  private func createShare(_ folio: Folio) async {
    do {
      let (_, share, _) =
      try await store.container.share([folio], to: nil)
      share[CKShare.SystemFieldKey.title] = folio.title
      self.share = share
    } catch {
      print("Failed to create share")
    }
  }

}

