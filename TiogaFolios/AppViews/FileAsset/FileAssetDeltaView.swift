//
//  FileAssetDeltaView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/30/22.
//

import SwiftUI

class DeltaAssetVm: ObservableObject {
    @Published var asset: Asset
    var ttitle: String
    var creating = false
    
    init(objectPassed: Asset? = nil) {
        if objectPassed == nil {
            creating = true
            asset = Asset()
            ttitle = "Creating New Asset"
        } else {
            creating = false
            asset = objectPassed!
            ttitle = "Editing Asset"
        }
    }
    
    func cancel() {
//        if creating {
//            self.asset.managedObjectContext?.delete(self.asset)
//        }
    }

}

struct FileAssetDeltaView: View {

    enum FocusField: Hashable {
          case field
        }


        @ObservedObject var vm: DeltaAssetVm
        @Binding var isPresented: Bool
        @FocusState private var focusedField: FocusField?

        init(objectPassed: Asset? = nil, show: Binding<Bool>) {
            if objectPassed == nil {
                vm = DeltaAssetVm()
                self._isPresented = show
            } else {
                vm = DeltaAssetVm(objectPassed: objectPassed)
                self._isPresented = show
            }
        }

        
        var body: some View {
            VStack {
                Form {
                    Text(vm.ttitle).font(.headline)
                    TextField("", text: $vm.asset.title ?? "foo")
                        .font(.body.bold())
                        .focused($focusedField, equals: .field)
                        .onAppear {
                              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                                    self.focusedField = .field
                               }
                        }
                    TextField("", text: $vm.asset.desc ?? "bar")
                    Button(action: {
                        Storage.privdb.save()
                        isPresented = false
                    }) {
                        HStack {
                            Spacer()
                            Text("Save")
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
                VStack(alignment: .leading) {
                    Text(vm.asset.pathname ?? "no pathname")
                        .font(.caption.italic())
                    Text(vm.asset.source?.absoluteString ?? "no source")
                        .font(.caption.italic())
                    Text(vm.asset.uttype ?? "no uttype")
                        .font(.caption.italic())

                }
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

struct FileAssetDeltaView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}
