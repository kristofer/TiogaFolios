//
//  FolioTemplView.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/26/22.
//

import SwiftUI

struct FolioTemplView: View {
    @Environment(\.dismiss) private var dismiss

    var template: FolioTemplate
    @Binding var isActive: Bool

    @State private var tempTitle: String = ""
    @State private var tempDesc: String = ""

    //@Binding var shouldPopToRootView : Bool

    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0){
            TextField("Title", text: $tempTitle)
                .font(.largeTitle)
                .padding()
                .border(.secondary)

            TextField("", text: $tempDesc)
                .font(.body.italic())
                .padding()
                .border(.secondary)
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
            Text("Example Items:")
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
                var templ = template
                templ.title = tempTitle
                templ.desc = tempDesc
                let _ = Folio.createFolioFromTemplate(templ)
                Storage.shared.save()
                isActive = true
                //self.isActive = false
                dismiss()
                
            }) {
                HStack {
                    Spacer()
                    Text("Create Folio from Example")
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(10)
            .background(Color.accentColor)
            .cornerRadius(8)

        }
        .padding()
        .onAppear(){
            tempTitle = template.title
            tempDesc = template.desc
        }
    }
}

struct FolioTemplView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
