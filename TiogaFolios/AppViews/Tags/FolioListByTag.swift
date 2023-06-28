//
//  FolioListByTag.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/24/22.
//

import SwiftUI


struct FolioListByTag: View {
    let tagkind: TagKind
    @ObservedObject var vm: ListTagVm

    init(_ tagkind: TagKind) {
        vm = ListTagVm()
        self.tagkind = tagkind
    }

    var body: some View {
        List {
            ForEach(vm.tags) { tag in
                if !Array(tag.folios! as Set as! Set<Folio>).isEmpty {
                    Section(header: Text(tag.title!)) {
                        ForEach(Array(tag.folios! as Set as! Set<Folio>), id: \.self) { folio in
                            VStack(spacing: 0) {
                                NavigationLink(
                                    destination: FolioDetailView(folio: folio )) {
                                        FolioCell(folio: folio)
                                    }
                            }
                            .listRowInsets(EdgeInsets(top: 2, leading: 8, bottom: 4, trailing: 4))
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            vm.refreshTags()
        }

        .onAppear(){
            vm.refreshTags()
        }
        .navigationBarTitle("Folios by Tag")
        .navigationBarTitleDisplayMode(.inline)
    }

}

struct FolioListByTag_Previews: PreviewProvider {
    static var previews: some View {
        FolioListByTag(TagKind.plain)
    }
}
