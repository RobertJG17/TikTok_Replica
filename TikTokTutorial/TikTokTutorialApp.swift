//
//  TikTokTutorialApp.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/25/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

//@main
//struct TikTokTutorialApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

@main
struct TikTokTutorialApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let authService = AuthService()

    var body: some Scene {
        WindowGroup {
            ContentView(authService: authService)
        }
    }
}
