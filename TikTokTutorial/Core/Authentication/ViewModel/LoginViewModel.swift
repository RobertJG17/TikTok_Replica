//
//  LoginViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 7/8/24.
//

import Foundation
import SwiftUI


class LoginViewModel: ObservableObject {
    private var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            try await authService.login(withEmail: email, password: password)
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
}
