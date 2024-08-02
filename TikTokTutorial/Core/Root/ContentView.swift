//
//  ContentView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/25/24.
//

import SwiftUI
import FirebaseAuth

// Swift UI Level up
// Learn how to build content sharing app with SwiftUI Framework
struct ContentView: View {
    @StateObject var viewModel = ContentViewModel(authService: AuthService())
    
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
