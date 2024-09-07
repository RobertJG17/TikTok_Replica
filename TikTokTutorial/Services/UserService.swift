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
    case FbeNullColl(message: String)
    case FbeUpdatePublishProperty(message: String)
}

// interface for uploading and retrieving data from firestore for a User
@MainActor
class UserService {
    // MARK: Published property we use to update CurrentUserProfileView
    @Published var userInformation: User?
    
    // MARK: Published property we use to update ExploreView
    @Published var userList: [User] = []
    
    func uploadUserData(_ user: User) async throws {
        do {
            let userData = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(userData)
        } catch {
            throw error
        }
    }
    
    func triggerUserUpdate(user: User) {
        print("user updated")
        self.userInformation = user
    }
    
    // MARK: Async API Routing function, accepts Firestore collection name and query parameters
    func fetchInformation(collectionName: String, parameters: [String: String]?) async throws {
        // MARK: Guard syntax verifies we are an authorized Firebase User
        guard ((Auth.auth().currentUser?.uid) != nil)
        else {
            throw FirebaseError.FbeAuth(message: "Unable to access Firebase with current authorization status")
        }
        
        // MARK: Using conditional assignment to unwrap parameters - if they exist
        if let unwrappedParameters = parameters {
            // MARK: Use unwrapped parameters to configure a custom firebase query
            let querySnapshot = try await queryCollectionWithParams(collectionName: collectionName, parameters: unwrappedParameters)
            do {
                // MARK: Calling method to publish changes to variable, updating any potential subscribers
                try updateCurrentUser(querySnapshot: querySnapshot)
            } catch {
                // MARK: Custom Firebase enum conforms to Error protocol, allowing us to implement custom error handling
                throw FirebaseError.FbeUpdatePublishProperty(message: "error when attempting to update published property current user: \(error)")
            }
            
        } else {
            let querySnapshot = try await queryCollection(collectionName: collectionName)
            do {
                try updateUserList(querySnapshot: querySnapshot)
            } catch {
                throw FirebaseError.FbeUpdatePublishProperty(message: "error when attempting to update published property user list: \(error)")
            }
        }
    }
    
    func queryCollection(collectionName: String) async throws -> QuerySnapshot {
        do {
            let fsClient = Firestore.firestore()                    // initialize firestore client
            let collection = fsClient.collection(collectionName)
            let querySnapshot = try await collection.getDocuments()
            return querySnapshot
        } catch {
            throw error
        }
    }
    
    func queryCollectionWithParams(collectionName: String, parameters: [String: String]) async throws -> QuerySnapshot {
        do {
            // parameters = ["uid": "uid_value"]
            let fsClient = Firestore.firestore()                    // initialize firestore client
            let collection = fsClient.collection(collectionName)
            let query = getFilteredCollection(collection: collection, parameters: parameters)
            let querySnapshot = try await query.getDocuments()
            return querySnapshot
        } catch {
            throw error
        }
    }
    
    // ???: Function responsible for applying multiple parameters to a query
    func getFilteredCollection(collection: CollectionReference, parameters: [String: String]) -> Query {
        var query: Query?
        
        for (parameterKey, parameterValue) in parameters {
            if let validQuery = query {
                query = validQuery.whereField(parameterKey, isEqualTo: parameterValue)
            } else {
                query = collection.whereField(parameterKey, isEqualTo: parameterValue)
            }
        }
        
        return query!
    }
    
    func updateUserList(querySnapshot: QuerySnapshot) throws {
        do {
            guard querySnapshot.documents.first != nil else { throw FirebaseError.FbeNullColl(message: "no collection found") }
            querySnapshot.documents.forEach { user in
                let userAttributes = user.data()
                
                guard let id: String = (userAttributes["id"] ?? "") as? String else { return }
                guard let username: String = (userAttributes["username"] ?? "") as? String else { return }
                guard let email: String = (userAttributes["email"] ?? "") as? String else { return }
                guard let fullname: String = (userAttributes["fullname"] ?? "") as? String else { return }
                guard let bio: String = (userAttributes["bio"] ?? "") as? String else { return }
                guard let profileImageUrl: String = (userAttributes["profileImageUrl"] ?? "") as? String else { return }
                
                let user = User(
                    id: id,
                    username: username,
                    email: email,
                    fullname: fullname,
                    bio: bio,
                    profileImageUrl: profileImageUrl
                )
    
                self.userList.append(user)
            }
        } catch {
            throw error
        }
    }
    
    func updateCurrentUser(querySnapshot: QuerySnapshot) throws {
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
            throw error
            
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
