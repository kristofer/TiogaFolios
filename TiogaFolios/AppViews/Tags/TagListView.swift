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
                    NavigationLink( destination: TagView(tag: tag)) {
                        Label("\(String(describing: (tag.title ?? "huh?")))",
                              systemImage: tag.imgtxtFor(tagkind: TagKind(rawValue: tag.kind!)! )
                                  )
                        }
                }
                .onDelete(perform: deleteTags)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await vm.reload()
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
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
#if os(iOS)
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
#else
            
#endif

//            Text("Select a tag")
//        }
    }

    func didDismiss() {
        vm.showNewTag = false
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
