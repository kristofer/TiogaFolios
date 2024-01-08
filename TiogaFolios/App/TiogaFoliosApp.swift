//
//  TiogaFoliosApp.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 11/15/22.
//

import SwiftUI
import CloudKit

@main
struct TiogaFoliosApp: App {
    let store = Storage.shared
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var mainActive:Bool = false
    @State private var encourageiCloudLogin = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if self.mainActive {
                    MainView()
                        .environment(\.managedObjectContext, store.vc)
                        .environment(\.font, Font.custom("Baskerville", size: 16))
                        .actionSheet(isPresented: $encourageiCloudLogin) {
                            ActionSheet(
                                title: Text("Not logged into iCloud"),
                                message: Text("Without being logged into iCloud, this app will save everything only on this device. If you login to iCloud, the app will work from multiple devices and allow for sharing with others."),
                                buttons: [
                                    .cancel { print(self.encourageiCloudLogin) },
                                    .default(Text("Take me to iCloud Login")){
                                        tfDebug("sending to prefs:root=CASTLE")
                                        let settingsCloudKitUrl = URL(string:"App-Prefs:root=CASTLE")
                                        if let url = settingsCloudKitUrl {
                                            if #available(iOS 10, *) {
                                                if UIApplication.shared.canOpenURL(url) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                            } else {
                                                UIApplication.shared.openURL(url)
                                            }
                                        }
                                    },
                                ]
                            )
                        }
                } else {
                    SplashView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.mainActive = true
                    }
                }
                CKContainer.default().accountStatus { (accountStat, error) in
                    if (accountStat == .available) {
                        tfDebug("iCloud is available")
                        encourageiCloudLogin = false
                    }
                    else {
                        tfDebug("iCloud is not available")
                        encourageiCloudLogin = true
                    }
                }
            }
        }
        .onChange(of: scenePhase) { _ in
            tfDebug("NOT calling persistence Save()")
            //Storage.shared.save()
        }
    }
}

extension UIApplication {
    static var _versionBuild = ""
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: Constants.CFBundleShortVersionString) as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        if _versionBuild != "" { return _versionBuild }
        
        let version = appVersion(), build = appBuild()
        NSLog("\(version),\(build)")
        _versionBuild = version == build ? "v\(version)" : "v\(version),(\(build))"
        return _versionBuild
    }
}
