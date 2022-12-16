//
//  ContentView.swift
//  FlexiblePickerExample
//
//  Created by Jędrzej Chołuj on 23/01/2022.
//

import SwiftUI

class FlexTagViewModel: ObservableObject {
    
    @Published var tags: [SelectableTagModel] = Tag.allTagsSelectable()
    
    func initTags(f: Folio?) {
        if let f = f, let ftags = f.tags {
            let ftags = Array(ftags) as! [Tag]
                for ftag in ftags {
                    //let ftag = (tag as Tag)
                    for i in 0..<self.tags.count {
                        if self.tags[i].displayedTag.id?.uuidString == ftag.id?.uuidString {
                            self.tags[i].isSelected = true
                        }
                    }
                }
            
        }
        
    }
}

struct ContentTagView: View {
    
    @ObservedObject var viewModel: FlexTagViewModel
    var tfolio: Folio
    
    var body: some View {
        VStack{
            Text("Tags assigned")
            FlexiblePicker<SelectableTagModel>(inputData: $viewModel.tags, item: tfolio)
        }
        .onAppear(){
            viewModel.initTags(f: tfolio)
        }
        .onDisappear() {
            Storage.shared.save()
        }
    }
    
    init(item: Folio) {
        tfolio = item
        viewModel = FlexTagViewModel()
        viewModel.initTags(f: tfolio)
    }
    
}

struct ContentTagView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        
    }
}
