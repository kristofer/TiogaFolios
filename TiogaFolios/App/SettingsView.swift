//
//  SettingsView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//
import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var entityNames: FetchedResults<Tag>
    
    @State var newTextAlertShowing = false
    @State var newTextDoc = "untitled"
    @State var newTextContent = "untitled"
    @State private var demomode = false
    
    var body: some View {
        NavigationView {
            Form {
                //                Text("Settings")
                //                    .font(.title2)
                Text("Version: \(UIApplication.versionBuild())")
                    .font(.title3)
                Section(header: Text("Demo Mode"), content: {
                    Toggle(isOn: $demomode) {
                        Text("Enable Demo Folios")
                    }
                    .padding()
                    .buttonStyle(.bordered)
                })
                //                NavigationLink("Digital Access Trust Details...") {
                //                    TrustView()
                //                }
                //                .padding()
                Section(header: Text("Archive and Documents"), content: {
                        NavigationLink("Show Archived Folios...") {
                            ArchivedListView()
                        }
                        .padding()
                    
//                        NavigationLink("Manage Unattached Documents...") {
//                            FileAssetList()
//                        }
//                        .padding()
                })
                //                NavigationLink("Connect to Email...") {
                //                    Text("Gmail Info (not implemented yet)")
                //                }
                //                .padding()
                //                Button("Test Fetching TD...") {
                //                    Task(priority: .medium) {
                //                        let foo = TestFetch(viewContext)
                //                        await foo.runTest()
                //                    }
                //                }
                //                .padding()
                //                Button("Test Fetching Zip Code Web Site...") {
                //                    Task(priority: .medium) {
                //                        let foo = TestFetch(viewContext)
                //                        await foo.runTest2()
                //                    }
                //                }
                //                .padding()
                Section(header: Text("Extras"), content: {
                    
                    Button("Refresh All Data...") {
                        reloadAll()
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    
                    Button("Dump All Data to JSON...") {
                        jsonify()
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    
                    Button("Deduplicate Tags") {
                        Tag.dedupeTags()
                        Storage.shared.save()
                    }
                    .padding()
                    .buttonStyle(.bordered)
                })
                //                Spacer()
                //                Button("Delete All Tags") {
                //                    deleteAll("Tag")
                //                }
                //                .padding(20.0)
                //                .border(.accentColor, width: 1.0)
                //.disabled(true)
                
            }
            .navigationBarTitle("Settings")
        }
    }
    
    func deleteAll(_ entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
        } catch {
            tfDebug("Delete all data in \(entityName) error :", error)
        }
    }
    
    func reloadAll() {
        viewContext.refreshAllObjects()
    }
    
    // work on export tools
    // https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/
    func jsonify() {
        //        let folios = Folio.fetchFolios(vc: viewContext)
        //        for f in folios {
        //            let str = f.toJSON()
        //            print("folio json: \(String(describing: str))")
        //        }
        let tags = Tag.allTags()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        for t in tags {
            //let str = t.toJSON()
            let jsonData = (try? encoder.encode(t))!
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            
            print("tag json: \(String(describing: reqJSONStr))")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
