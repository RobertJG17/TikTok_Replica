//
//  AuthService.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 7/8/24.
//

import Firebase
import FirebaseAuth
import Combine

@MainActor
class AuthService: ObservableObject {
    // MARK: We implement these functions across our viewModels (Login | Registration)
    // The view models are responsible for invoking the respective functions below
    // and allow us to propogate errors back to our viewModels to handle them within our catch block
    
    @Published var userSession: FirebaseAuth.User?
    let AuthUserService = UserService()                     // instance of UserService
                                                            // to publish user data on register
                                                            // separate from user service managed
                                                            // throughout application
    
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
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // different than uploading meta data (birthday, favorite sport, etc)
            self.updateUserSession()
            
            // writes data to firebase table leveraging firestore generated UUID
            try await uploadUserData(withEmail: email, id: result.user.uid, username: username, fullname: fullname)
            print("DEBUG: Hello user: \(result.user.uid)")
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        print("DEBUG: USER \(userSession?.uid ?? "NO_UID") signed out")
        try? Auth.auth().signOut() // signs user out on backend
        self.userSession = nil     // updates routing logic by wiping user session
    }
    
    // User service implementation is not as intricate as AuthService
    private func uploadUserData(withEmail email: String,
                                id: String,
                                username: String,
                                fullname: String) async throws {
        
        let user = User(
            id: id,
            username: username,
            email: email,
            fullname: fullname
        )
        
        try await AuthUserService.publishInformation(
            collection: FirestoreData.users,
            data: user
        )
    }
}
