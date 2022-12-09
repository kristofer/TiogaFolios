//
//  TagListView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import SwiftUI

struct TagListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        //entity: Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.lastmodified, ascending: false)],
        //predicate: NSPredicate(format: "kindValue == %i", TagKind.folio.rawValue),
        animation: .default)
    private var tags: FetchedResults<Tag>

    @State var showNewTag = false
    @State private var newTag: Tag?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tags) { tag in
                    NavigationLink(
                        destination: TagView(tag: tag)) {
                            Label("\(String(describing: (tag.title ?? "nil folio name")))", systemImage: tag.imgtxtFor(tagkind: TagKind(rawValue: tag.kind!) ?? TagKind.plain))
                        }
                }
                .onDelete(perform: deleteFolios)
            }
            .listStyle(PlainListStyle())
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action:  {
                        self.showNewTag = true
                        // if newTag == nil {
                            newTag = Tag.createTag(vc: viewContext, named: "NewTag", kind: .plain)
                        // }
                    }) {
                    HStack {
                        Text("Add Tag")
                        Image(systemName: "plus")
                        }
                    }
                    .sheet(isPresented: $showNewTag, onDismiss: didDismiss)
                    {
                        TagEditView(showNewTag: $showNewTag,
                                    currentTag: newTag!)
                    }
                }
            }
#if os(iOS)
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
#else
            
#endif

            Text("Select a tag")
        }
    }

    func didDismiss() {
        showNewTag = false
    }
    
    private func deleteFolios(offsets: IndexSet) {
        withAnimation {
            offsets.map { tags[$0] }.forEach(viewContext.delete)

            Storage.privdb.save()
        }
    }
    
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
