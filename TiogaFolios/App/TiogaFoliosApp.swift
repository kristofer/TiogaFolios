//
//  TiogaFoliosApp.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/15/22.
//

import SwiftUI

@main
struct TiogaFoliosApp: App {
    let store = Storage.privdb
    @Environment(\.scenePhase) var scenePhase
    @State var mainActive:Bool = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if self.mainActive {
                    MainView()
                        .environment(\.managedObjectContext, store.vc())
                } else {
                    SplashView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.mainActive = true
                    }
                }
            }

        }
        .onChange(of: scenePhase) { _ in
            //print("calling persistence Save()")
            Storage.privdb.save()
        }
    }
}

extension UIApplication {
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: Constants.CFBundleShortVersionString) as! String
        // CFBundleShortVersionString
    }

    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()

        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}
