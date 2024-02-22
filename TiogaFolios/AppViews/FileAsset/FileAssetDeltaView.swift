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
    
//    func cancel() {
//        if creating {
//            self.asset.managedObjectContext?.delete(self.asset)
//        }
//    }

}

struct FileAssetDeltaView: View {

    enum FocusField: Hashable {
          case field
        }

    @Environment(\.dismiss) var dismiss


        @ObservedObject var vm: DeltaAssetVm
        @FocusState private var focusedField: FocusField?

        init(objectPassed: Asset? = nil) {
            if objectPassed == nil {
                vm = DeltaAssetVm()
            } else {
                vm = DeltaAssetVm(objectPassed: objectPassed)
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
                        vm.asset.touch()
                        Storage.shared.save()
                        //isPresented = false
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
//                    .foregroundColor(.white)
//                    .padding(10)
//                    .background(Color.accentColor)
//                    .cornerRadius(8)
                }
                .padding(20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                HStack(alignment: .top) {
                    Text(vm.asset.pathname ?? "no pathname")
                        .font(.caption.italic())
                    Spacer()
                    Text(vm.asset.source?.absoluteString ?? "no URL")
                        .font(.caption.italic())
                    Spacer()
                    Text(vm.asset.uttype ?? "no uttype")
                        .font(.caption.italic())
                    Spacer()
                    Text(vm.asset.lastmodified?.formatted() ?? "no date found.")
                        .font(.caption.italic())

                }
                .padding(5)
//                Button(action: {
//                    vm.cancel()
//                    isPresented = false
//                }) {
//                    HStack {
//                        Spacer()
//                        Text("Cancel")
//                        Spacer()
//                    }
//                }
//                .buttonStyle(.bordered)
//                .foregroundColor(Color.accentColor)
//                .padding(10)
//                .cornerRadius(8)
            }
        }

}

struct FileAssetDeltaView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}
