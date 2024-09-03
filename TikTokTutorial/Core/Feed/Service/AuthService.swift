//
//  AuthService.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 7/8/24.
//

import Firebase
import FirebaseAuth

@MainActor
class AuthService {
    // MARK: We implement these functions across our viewModels (Login | Registration)
    // The view models are responsible for invoking the respective functions below
    // and allow us to propogate errors back to our viewModels to handle them within our catch block
    
    @Published var userSession: FirebaseAuth.User?
    
    func updateUserSession() {
        self.userSession = Auth.auth().currentUser
    }
    
    func login(withEmail email: String,
               password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.updateUserSession()
            print("DEBUG: Hello user \(result.user.uid)")
        } catch {
            print("DEBUG: User login failed in AUTH SERVICE: \(error.localizedDescription)")
            throw error
        }
        
    }
    
    func createUser(withEmail email: String, 
                    password: String,
                    username: String,
                    fullname: String) async throws {
        print("DEBUG: User info \(email) \(username) \(fullname)")
        
        do {
            // ???: Why is my code sense not working here?
            // !!!: Found these custom #pragma marks thru https://stackoverflow.com/questions/6662395/xcode-intellisense-meaning-of-letters-in-colored-boxes-like-f-t-c-m-p-c-k-etc
            // MARK: also explains xcode's icon labeling with code sense
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // different than uploading meta data (birthday, favorite sport, etc)
            self.updateUserSession()
            print("DEBUG: Hello user: \(result.user.uid)")
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        // implement
        print("DEBUG: USER \(userSession?.uid ?? "NO_UID") signed out")
        try? Auth.auth().signOut() // signs user out on backend
        self.userSession = nil     // updates routing logic by wiping user session
    }
}
