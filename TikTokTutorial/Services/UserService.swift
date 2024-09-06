//
//  UserService.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


enum FirebaseError: Error {
    case FbeAuth(message: String)
    case FbeUserNull(message: String)
}

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
    
    func fetchInformation(collectionName: String, field: String) async throws {
        // initialize firestore client
        let fsClient = Firestore.firestore()
        
        // safely unpack uid
        if let uid = Auth.auth().currentUser?.uid {
            let collection = fsClient.collection(collectionName)
            let query = collection.whereField(field, isEqualTo: uid)

            do {
                let querySnapshot = try await query.getDocuments()
                retrieveData(collection: collectionName, snapshot: querySnapshot)
            } catch {
                throw error
            }
        } else {
            throw FirebaseError.FbeAuth(message: "Unable to access Firebase with current authorization status")
        }
    }
    
    func retrieveData(collection: String, snapshot: QuerySnapshot) {
        switch(collection) {
        case "users":
            retrieveUserFromDocument(querySnapshot: snapshot)
        default:
            print("exhaustive")
        }
    }
    
    func retrieveUserFromDocument(querySnapshot: QuerySnapshot) {
        do {
            guard let userDocument = querySnapshot.documents.first else { throw FirebaseError.FbeUserNull(message: "user authenticated, but not found in user collection") }
            let id = userDocument["id"] as! String
            let username = userDocument["username"] as! String
            let email = userDocument["email"] as! String
            let fullname = userDocument["fullname"] as! String
            
            triggerUserUpdate(
                user: User(
                    id: id,
                    username: username,
                    email: email,
                    fullname: fullname
                )
            )
        } catch {
            print("error encountered: \(error)")
            
            /*
             
             print("1 - Documents: ", querySnapshot.documents)
             print("2 - First Document: ", querySnapshot.documents.first ?? "no docs")
             
             Encountered error here since I had a user authenticated but didn't have the functionality
             to publish the user information to the user collection in Firestore.
             
             So when I went to the profile view, there was no username, as the authenticated user
             had no initialized data from the registration process. (resolved by re-adding user through registration flow)
             
             */
        }
    }
}
