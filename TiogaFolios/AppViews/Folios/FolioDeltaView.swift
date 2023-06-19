//
//  FolioNewView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/11/21.
//

import SwiftUI

class DeltaFolioVm: ObservableObject {
    @Published var folio: Folio
    @Published var isChecked: Bool
    var ttitle: String
    
    init(folio: Folio) {
        self.folio = folio
        ttitle = "Editing Folio"
        //if folio.locked { tfDebug("folio \(folio.title) locked.") }
        isChecked = folio.locked
    }
    
    func cancel() { }
    
}

struct FolioDeltaView: View {
    enum FocusField: Hashable {
        case field
    }
    
    @ObservedObject var vm: DeltaFolioVm
    @Binding var activeSheet: ActiveSheet?
    //@FocusState private var focusedField: FocusField?
    
    var title:String = "Archive This Folio"
    
    init(activeSheet: Binding<ActiveSheet?>, folio: Folio) {
        _activeSheet = activeSheet
        vm = DeltaFolioVm(folio: folio)
    }
    
    var body: some View {
        VStack {
            Form {
                Text(vm.ttitle).font(.headline)
                Text("title")
                TextEditor(text: $vm.folio.title ?? "")
                    //.focused($focusedField, equals: .field)
                    //.onAppear {
                    //    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
//                            self.focusedField = .field
//                        }
//                    }
                Text("description")
                TextEditor(text: $vm.folio.desc ?? "")
                Toggle(title, isOn: $vm.isChecked)
                if vm.isChecked {
                    Text("Folio Locked!")
                }
                
                //Divider()
                Button(action: {
                    vm.folio.locked = vm.isChecked
                    vm.folio.touch()
                    Storage.shared.save()
                    activeSheet = nil
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
        }
    }
}


struct FolioNewView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}
