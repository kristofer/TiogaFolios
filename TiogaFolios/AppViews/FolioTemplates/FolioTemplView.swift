//
//  FolioTemplView.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/26/22.
//

import SwiftUI

struct FolioTemplView: View {
    @Environment(\.presentationMode) var presentation
    var template: FolioTemplate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0){
            Text("\(template.title)")
                .font(.largeTitle)
                .padding()
            Text("\(template.desc)")
                .font(.body.italic())
                .padding()
            Divider()
            HStack{
                ForEach(Array(template.tags ?? []), id: \.self) { tag in
                    Text(tag.title)
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 1)
                        )
                        .padding(2)
                    
                }
            }
            Divider()
            Text("Items in the template:")
                .font(.body.bold())
            List {
                ForEach(Array(template.assets ?? []), id: \.self) { tag in
                    HStack{
                        Image(systemName: "doc")
                        Text(tag.title)
                    }
                    .padding(2)
                    
                }
            }
            .listStyle(PlainListStyle())
            Button(action: {
                let _ = Folio.createFolioFromTemplate(template)
                Storage.shared.save()
                presentation.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Create Folio from Template")
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(10)
            .background(Color.accentColor)
            .cornerRadius(8)

        }
        .padding()
    }
}

struct FolioTemplView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
