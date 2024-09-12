//
//  TikTokTutorialApp.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/25/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
    return true
  }
}

@main
struct TikTokTutorialApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userService = UserService()
    private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            ContentView(
                authService: authService,
                userService: userService
            )
        }
    }
}

/*
    ORIGINAL MAIN
 
    @main
    struct TikTokTutorialApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
    }
*/
