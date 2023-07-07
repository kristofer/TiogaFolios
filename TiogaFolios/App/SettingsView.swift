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
            VStack(alignment: .leading) {
                Text("Version: \(UIApplication.versionBuild())")
                Text("These are some app extras")
                Text("Will be more here soon")
//                NavigationLink("Digital Access Trust Details...") {
//                    TrustView()
//                }
//                .padding()
                
                NavigationLink("Archived Folios...") {
                    ArchivedListView()
                }
                .padding()
                NavigationLink("Manage Unattached Documents...") {
                    FileAssetList()
                }
                .padding()
                NavigationLink("Connect to Email...") {
                    Text("Gmail Info (not implemented yet)")
                }
                .padding()
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
                .padding()
                Button("Refresh All Data...") {
                    reloadAll()
                }
                .padding()
                
                Button("Deduplicate Tags") {
                    Tag.dedupeTags()
                    Storage.shared.save()
                }
                .padding()

//                Spacer()
//                Button("Delete All Tags") {
//                    deleteAll("Tag")
//                }
//                .padding(20.0)
//                .border(Color.blue, width: 1.0)
                //.disabled(true)
            }
            .navigationBarTitle("Settings")
            
        
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
