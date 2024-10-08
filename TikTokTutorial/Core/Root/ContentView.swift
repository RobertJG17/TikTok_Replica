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
    @StateObject var viewModel: ContentViewModel
    @StateObject private var authService: AuthService
    @StateObject private var userService: UserService
    
    init(authService: AuthService, userService: UserService) {
        _authService = StateObject(wrappedValue: authService)
        _userService = StateObject(wrappedValue: userService)
        let viewModel = ContentViewModel(authService: authService)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView(authService: authService, userService: userService)
            } else {
                LoginView(authService: authService)
            }
        }
    }
    
}

#Preview {
    ContentView(authService: AuthService(), userService: UserService())
}
