//
//  TagListView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import SwiftUI

@MainActor class ListTagVm: ObservableObject {

    @Published var tags: [Tag]

    @Published var showNewTag = false
    @Published var newTag: Tag?

    init() {
        tags = Tag.allTags()
        newTag = nil;
    }
    
    func refreshTags() {
        tags = Tag.allTags()
    }
    func reload() async {
        refreshTags()
    }
}

struct TagListView: View {
    
    //@Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var vm: ListTagVm

    init() {
        vm = ListTagVm()
    }
    
    
    var body: some View {
//            NavigationView {
            List {
                ForEach(vm.tags) { tag in
                    NavigationLink( destination: TagDetailView(tag: tag)) {
                        TagCell(tag: tag)
                        }
                }
                .onDelete(perform: deleteTags)
            }
            .listStyle(PlainListStyle())
            .onAppear {
                vm.refreshTags()
            }
            .refreshable {
                await vm.reload()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action:  {
                        Tag.dedupeTags()
                        Storage.shared.save()
                        vm.refreshTags()
                    }) {
                    HStack {
                        Text("DeDupe")
                        }
                    }

                }
                ToolbarItem {
                    Button(action:  {
                        vm.showNewTag = true
                    }) {
                    HStack {
                        Text("Add Tag")
                        Image(systemName: "plus")
                        }
                    }
                    .sheet(isPresented: $vm.showNewTag, onDismiss: didDismiss)
                    {
                        TagEditView(objectPassed: vm.newTag, show: $vm.showNewTag)
                    }
                }
            }
            .navigationBarTitle("Tags (Categories)")
            .navigationBarTitleDisplayMode(.inline)
    }

    func didDismiss() {
        tfDebug("didDismiss on tag create")
        vm.showNewTag = false
        vm.refreshTags()
    }
    
    func willAppear() {
        vm.refreshTags()
    }
    
    private func deleteTags(offsets: IndexSet) {
        withAnimation {
            offsets.map { vm.tags[$0] }.forEach(Storage.shared.vc.delete)

            Storage.shared.save()
            vm.refreshTags()
        }
    }
    
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
