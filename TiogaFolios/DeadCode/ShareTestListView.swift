////
////  NoteListView.swift
////  ShareDataViaCloudKitAndCoreData
////
////  Created by Yang Xu on 2021/9/9.
////
//
//import CoreData
//import SwiftUI
//
//struct ShareTestListView: View {
////    @FetchRequest(entity: Folio.entity(),
////                  sortDescriptors: [NSSortDescriptor(keyPath: \Folio.lastmodified, ascending: false)],
////                  animation: .default)
//    private var folios = Folio.fetchFolios(vc: Storage.shared.vc) //FetchedResults<Folio>
//    private let stack = Storage.shared
//    @State private var id = UUID()
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(folios) { (folio: Folio) in
//                    NavigationLink {
//                        FolioMiniDetailView(folio: folio)
//                    }
//                    label: {
//                        HStack {
//                            Text(folio.title!)
//                            if stack.isShared(object: folio) {
//                                if stack.isOwner(object: folio) {
//                                    Image(systemName: "person.2.fill")
//                                        .foregroundColor(.accentColor)
//                                } else {
//                                    Image(systemName: "person.fill")
//                                        .foregroundColor(.green)
//                                }
//                            }
////                            if !canEdit(note) {
////                                Image(systemName: "pencil.slash")
////                                    .foregroundColor(.red)
////                            }
//                        }
//                        .id(id)
//                    }
////                    .swipeActions {
////                        if canEdit(note) {
////                            Button(role: .destructive) {
////                                withAnimation {
////                                    //stack.deleteNote(note)
////                                }
////                            }
////                            label: {
////                                Label("Del", systemImage: "trash")
////                            }
////                        }
////                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem {
//                    Button {
//                        withAnimation {
//                            //stack.addNote()
//                        }
//                    }
//                    label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//            .navigationTitle("Folio Sharing")
//            .onAppear { id = UUID() }
//        }
//    }
//
//    private func canEdit(_ note: Note) -> Bool {
//        stack.canEdit(object: note)
//    }
//}
//
//struct NoteListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareTestListView()
//    }
//}
