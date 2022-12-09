//
//  FolioListByTag.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/24/22.
//

import SwiftUI

//struct TagKindView: View {
//    let tagkind: TagKind
//    var body: some View {
//        VStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 12).foregroundColor(Color.accentColor)
//                Image(systemName: tagkind.imgtxtFor(tagkind: tagkind))
//                    //.imageScale(.large)
//                    .font(.system(size: 60, weight: .bold))
//                    .foregroundColor(.white)
//            }
//
//            Text(tagkind.rawValue)
//                .font(.title2)
//        }
//
//    }
//}


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
                            destination: FolioView(folio: folio )) {
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
        .navigationBarTitle(tagkind.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
    init(tagkind: TagKind) {
        self.tagkind = tagkind
        self.tags = Tag.allByKind(tagkind: tagkind)
        
    }
}

struct FolioListByTag_Previews: PreviewProvider {
    static var previews: some View {
        FolioListByTag(tagkind: TagKind.plain)
    }
}
