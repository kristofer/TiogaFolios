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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Version: \(UIApplication.versionBuild())")
//                NavigationLink("Digital Access Trust Details...") {
//                    TrustView()
//                }
//                .padding()
                NavigationLink("Manage Tags...") {
                    TagListView()
                }
                .padding()
                NavigationLink("Manage Documents...") {
                    FileAssetList()
                }
                .padding()
                NavigationLink("Connect to Email...") {
                    Text("Gmail Info")
                }
                .padding()
                Button("Test Fetching TD...") {
                    Task(priority: .medium) {
                        let foo = TestFetch(viewContext)
                        await foo.runTest()
                    }
                }
                .padding()
                Button("Test Fetching Zip Code Web Site...") {
                    Task(priority: .medium) {
                        let foo = TestFetch(viewContext)
                        await foo.runTest2()
                    }
                }
                .padding()
                Button("Refresh All Data...") {
                    reloadAll()
                }
                .padding()
                Button("Create New Text Note...") {
                    newTextAlertShowing = true
                }
                .sheet(isPresented: $newTextAlertShowing, onDismiss: reloadAll, content: {
                    VStack {
                        Label("Name", systemImage: "pencil")
                        TextField("Name: ", text: $newTextDoc)
                            .padding(20.0)
                        Label("Contents", systemImage: "pencil")
                        TextEditor(text: $newTextContent)
                            .padding(20.0)
                        Button("Create", action: {
                            newTextAlertShowing = false
                            makeNewTextDoc(named:newTextDoc)
                        })
                    }
                })
                .padding()
                
                Spacer()
                Button("Delete All Tags") {
                    //deleteAll("Tag")
                }
                .padding(20.0)
                .border(Color.blue, width: 1.0)
                .disabled(true)
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
            print("Delete all data in \(entityName) error :", error)
        }
    }
    
    func reloadAll() {
        viewContext.refreshAllObjects()
    }
    func makeNewTextDoc(named: String) {
        print("\(named) \(UTType.text.identifier)")
        let pt = named+".txt"
        let newDoc = Asset(vc: viewContext, title: pt, path: pt, mimetype: "text/plain", uttype: UTType.plainText.identifier)
        newDoc.setBlob(newTextContent.data(using: .utf8) ?? "".data(using: .utf8)!)
        //try? viewContext.save()
        Storage.privdb.save()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
