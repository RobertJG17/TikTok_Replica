//
//  UserService.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

// interface for uploading and retrieving data from firestore for a User
@MainActor
class UserService {
    @Published var userInformation: User?
    
    func uploadUserData(_ user: User) async throws {
        do {
            let userData = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(userData)
        } catch {
            throw error
        }
    }
    
    func triggerUserUpdate(user: User) {
        userInformation = user
    }
    
    func fetchUserInformation() async -> User {
        let defaultUser = User(id: "DEFAULT_ID", username: "DEFAULT_USERNAME", email: "DEFAULT_EMAIL", fullname: "DEFAULT_FULLNAME") // fix
        let fsClient = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("no uid detected")
            triggerUserUpdate(user: defaultUser)
            return defaultUser
        }
        
        // use uid to get current user information from firestore users collection
        // fetch user information only scans users query/collections.
        // doesn't have any associate number of followers
        let usersCollection = fsClient.collection("users")
        let usersQuery = usersCollection.whereField("id", isEqualTo: uid)
        
        do {
            let querySnapshot = try await usersQuery.getDocuments()
            let user: User = retrieveUserFromDocument(querySnapshot: querySnapshot)
            
            triggerUserUpdate(user: user)

            return user
        } catch {
            triggerUserUpdate(user: defaultUser)
            print("Error when fetching data from firestore")
            
        }
        return defaultUser
    }
    
    func retrieveUserFromDocument(querySnapshot: QuerySnapshot) -> User {
        let userDocument = querySnapshot.documents.first
        let documentData = userDocument!
        
        let id = documentData["id"] as! String
        let username = documentData["username"] as! String
        let email = documentData["email"] as! String
        let fullname = documentData["fullname"] as! String
        
        return User(id: id, username: username, email: email, fullname: fullname)
    }
}
