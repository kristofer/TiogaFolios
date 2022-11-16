//
//  FolioNewView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import SwiftUI

class DeltaFolioVm: ObservableObject {
    @Published var folio: Folio
    var ttitle: String
    var creating = false
    
    init(objectPassed: Folio? = nil) {
        if objectPassed == nil {
            creating = true
            folio = Folio.createFolio(vc: Storage.privdb.vc(), title: "Untitled", desc: "description")
            ttitle = "Creating New Folio"
        } else {
            creating = false
            folio = objectPassed!
            ttitle = "Editing Folio"
        }
    }
    
    func cancel() {
        if creating {
            self.folio.managedObjectContext?.delete(self.folio)
        }
    }

}

struct FolioDeltaView: View {
    @ObservedObject var vm: DeltaFolioVm
    @Binding var isPresented: Bool
    
    init(objectPassed: Folio? = nil, show: Binding<Bool>) {
        if objectPassed == nil {
            vm = DeltaFolioVm()
            self._isPresented = show
        } else {
            vm = DeltaFolioVm(objectPassed: objectPassed)
            self._isPresented = show
        }
    }

    
    var body: some View {
        VStack {
            Form {
                Text(vm.ttitle).font(.headline)
//                HStack{
//                    Label("As of \(vm.folio.modified!, style: .date), \(vm.folio.modified!, style: .time)", systemImage: "folder")
//                }
                TextField("", text: $vm.folio.title ?? "foo")
                TextField("", text: $vm.folio.desc ?? "bar")
                Button(action: {
                    try? Storage.privdb.vc().save()
                    isPresented = false
                }) {
                    HStack {
                        Spacer()
                        Text("Save Folio")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding(20)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            
            Button(action: {
                vm.cancel()
                isPresented = false
            }) {
                HStack {
                    Spacer()
                    Text("Cancel")
                    Spacer()
                }
            }
            .foregroundColor(Color.accentColor)
            .padding(10)
            .cornerRadius(8)
        }
    }
    
    
}


struct FolioNewView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}
