//
//  TagKindListView.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/23/22.
//

import SwiftUI

struct TagKindView: View {
    let tagkind: TagKind
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12).foregroundColor(Color.accentColor)
                Image(systemName: tagkind.imgtxtFor(tagkind: tagkind))
                    //.imageScale(.large)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(tagkind.rawValue)
                .font(.title2)
        }
        
    }
}

struct TagKindListView: View {
    
    // 1. Number of items will be display in row
    var columns: [GridItem] = [
        //GridItem(.flexible(minimum: 140)),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    // 2. Fixed height of card
    let height: CGFloat = 150
    let kinds: [TagKind] = TagKind.allCases
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                // 4. Populate into grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(kinds) { kind in
                        NavigationLink(
                            destination: FolioListByTag(kind)) {
                                TagKindView(tagkind: kind)
                                    .frame(height: height)
                                
                            }
                        
                    }
                }
                .padding()
            }
        }
    }
}

struct TagKindListView_Previews: PreviewProvider {
    static var previews: some View {
        TagKindListView()
        
    }
}
