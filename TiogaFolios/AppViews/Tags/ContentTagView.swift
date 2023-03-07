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
    
    @Binding var activeSheet: ActiveSheet?

    var tfolio: Folio

    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        tfolio = folio
        viewModel = FlexTagViewModel()
        viewModel.initTags(f: tfolio)
    }
    
    var body: some View {
        VStack{
            Text("Tags assigned")
            FlexiblePicker<SelectableTagModel>(inputData: $viewModel.tags, item: tfolio)
            Spacer()
            Button("Done.") { activeSheet = nil }
                .buttonStyle(.bordered)
        }
        .onAppear(){
            viewModel.initTags(f: tfolio)
        }
        .onDisappear() {
            Storage.shared.save()
        }
    }
    
}

struct ContentTagView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        
    }
}
