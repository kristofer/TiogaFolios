//
//  TagRestrictView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 2/29/24.
//

import SwiftUI

class RestrictTagViewModel: ObservableObject {
    
    @Published var tags: [SelectableTagModel] = Tag.allTagsSelectable()
    
    func initTags(f: FolioListViewModel) {
        //if let f = f, let ftags = f.hiddenTagsSelected {
            let ftags = Array(f.hiddenTagsSelected) as! [Tag]
                for ftag in ftags {
                    //let ftag = (tag as Tag)
                    for i in 0..<self.tags.count {
                        if self.tags[i].displayedTag.id?.uuidString == ftag.id?.uuidString {
                            self.tags[i].isSelected = true
                        }
                    }
                }
            
        //}
        
    }
}

struct TagRestrictView: View {
    
    @ObservedObject var vm: RestrictTagViewModel
    var flvm: FolioListViewModel
    
    init(flvm: FolioListViewModel) {
        self.flvm = flvm
        vm = RestrictTagViewModel()
        vm.initTags(f: flvm)
    }

    var body: some View {
        VStack{
            FlexiblePicker<SelectableTagModel,FolioListViewModel>(inputData: $vm.tags, item: flvm)
        }
        .onAppear(){
            vm.initTags(f: flvm)
        }
        .onDisappear() {
            //Storage.shared.save()
        }
        // turn on/off
        // list of tags, select "must have tag to be shown"
        // should this be a special view?
    // this can be used to create a special "demo docs" view
        // maybe also a "secret view"?
    }
}

#Preview {
    EmptyView()
}
