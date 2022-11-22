//
//  ChooseFolio.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/21/22.
//

import SwiftUI

struct ChooseFolio: View {
    @State private var selection: UUID?
    @ObservedObject var vm = FolioListViewModel()
    
    
    var body: some View {
        NavigationView {
            List(vm.folios, id: \.self, selection: $selection) { folio in
                Text(folio.title!)
            }
        }
        .navigationTitle("Current Folios")
        //.toolbar { EditButton() }
        
        .onAppear(perform: {
            vm.fetchData()
        })
        .toolbar { EditButton() }

        
    }
}

struct ChooseFolio_Previews: PreviewProvider {
    static var previews: some View {
        ChooseFolio()
    }
}
