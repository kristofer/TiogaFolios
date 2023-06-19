//
//  FolioListByTag.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/24/22.
//

import SwiftUI


struct FolioListByTag: View {
    let tagkind: TagKind
    var tags: [Tag]
    
    var body: some View {
        List {
            ForEach(tags) { tag in
                Section(header: Text(tag.title!)) {
                    ForEach(Array(tag.folios! as Set as! Set<Folio>), id: \.self) { folio in
                        VStack(spacing: 0) {
                        NavigationLink(
                            destination: FolioDetailView(folio: folio )) {
                                FolioCell(folio: folio)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 4, trailing: 0))

                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear(){
            
        }
        .navigationBarTitle("Folios by Tag")
        //.navigationBarTitleDisplayMode(.inline)
    }
    init(_ tagkind: TagKind) {
        self.tagkind = tagkind
        self.tags = Tag.allTags() //allByKind(tagkind: tagkind)
        
    }
}

struct FolioListByTag_Previews: PreviewProvider {
    static var previews: some View {
        FolioListByTag(TagKind.plain)
    }
}
