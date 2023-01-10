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
            folio = Folio.createFolio(vc: Storage.shared.vc, title: "", desc: "")
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
    enum FocusField: Hashable {
      case field
    }


    @ObservedObject var vm: DeltaFolioVm
    @Binding var isPresented: Bool
    @FocusState private var focusedField: FocusField?

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
                TextField("Untitled", text: $vm.folio.title ?? "")
                    .focused($focusedField, equals: .field)
                    .onAppear {
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                                self.focusedField = .field
                           }
                    }
                TextField("description", text: $vm.folio.desc ?? "")
                Button(action: {
                    vm.folio.touch()
                    Storage.shared.save()
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
            .buttonStyle(.bordered)
            // will this be confusing?
            //FolioTemplListView()
        }
    }
    
    
}


struct FolioNewView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}
