//
//  LoginViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 7/8/24.
//

import Foundation


class LoginViewModel: ObservableObject {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login(withEmail email: String, password: String) async {
        do {
            try await authService.login(withEmail: email, password: password)
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
        }
    }
}
