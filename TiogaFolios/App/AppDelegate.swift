//
//  AppDelegate.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 12/21/22.
//

import Foundation

import CloudKit
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfig.delegateClass = SceneDelegate.self
    return sceneConfig
  }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
  func windowScene(
    _ windowScene: UIWindowScene,
    userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata
  ) {
    let shareStore = Storage.shared.sharedPersistentStore
    let persistentContainer = Storage.shared.container
    persistentContainer.acceptShareInvitations(
      from: [cloudKitShareMetadata], into: shareStore
    ) { _, error in
      if let error = error {
        print("acceptShareInvitation error :\(error)")
      }
    }
  }

}
