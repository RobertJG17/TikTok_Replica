//
//  AuthService.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 7/8/24.
//

import Foundation
import Firebase


class AuthService {
    // MARK: We implement these functions across our viewModels (Login | Registration)
    // The view models are responsible for invoking the respective functions below
    // and allow us to propogate errors back to our viewModels to handle them within our catch block
    
    func login(withEmail email: String,
               password: String) async throws {
        print("DEBUG: Login with email \(email)")
    }
    
    func createUser(withEmail email: String, 
                    password: String,
                    username: String,
                    fullname: String) async throws {
        print("DEBUG: User info \(email) \(username) \(fullname)")
    }
    
    func signOut() {
        
    }
}
