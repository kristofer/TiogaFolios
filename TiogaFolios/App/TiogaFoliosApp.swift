//
//  TiogaFoliosApp.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/15/22.
//

import SwiftUI

@main
struct TiogaFoliosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
