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
    // MARK: Published property we use to update CurrentUserProfileView
    @Published var user: User?
    
    // MARK: Published property we use to update ExploreView
    @Published var userList: [User] = []
    
    // MARK: Published property we use to update PostGridView
    @Published var posts: [Post] = []
    
    private var isFetching = false
        
    func uploadUserData(_ user: User) async throws {
        do {
            let userData = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection(FirestoreCollection.users.rawValue).document(user.id).setData(userData)
            print("SUCCESS: user data published to firestore")
        } catch {
            throw error
        }
    }
    
    
    // MARK: Async API Routing function, accepts Firestore collection name and query parameters
    func fetchInformation(collectionName: String, parameters: [String: String]?) async throws {
        // MARK: DEBUG: Guard helps prevent multiple calls
        guard !isFetching else { return }
        isFetching = true
        print("DEBUG: fetch information initiated")
        
        // MARK: Guard syntax verifies we are an authorized Firebase User
        guard ((Auth.auth().currentUser?.uid) != nil)
        else {
            throw FirebaseError.FbeAuth(message: "ERROR: Unable to access Firebase with current authorization status")
        }
        
        // MARK: Using conditional assignment to unwrap parameters - if they exist
        if let unwrappedParameters = parameters {
            do {
                // MARK: Use unwrapped parameters to configure a custom firebase query
                let querySnapshot = try await queryCollectionWithParams(collectionName: collectionName, parameters: unwrappedParameters)
                // MARK: Calling method to publish changes to variable, updating any potential subscribers
                try updateCurrentUser(querySnapshot: querySnapshot)
                isFetching = false
            } catch {
                // MARK: Custom Firebase enum conforms to Error protocol, allowing us to implement custom error handling
                isFetching = false
                throw FirebaseError.FbeUpdateError(message: "ERROR: Unable to update current user: \(error)")
            }
            
        } else {
            do {
                let querySnapshot = try await queryCollection(collectionName: collectionName)
                try updateUserList(querySnapshot: querySnapshot)
                isFetching = false
               
            } catch {
                isFetching = false
                throw FirebaseError.FbeUpdateError(message: "ERROR: Unable to update user list: \(error)")
            }
        }
    }
    
    // ???: Function responsible for handling query with no parameters
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
    
    // ???: Function responsible for handling parameter driven query
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
    
    // ???: Function responsible for parsing users firebase document and triggering Published variable update to userList
    func updateUserList(querySnapshot: QuerySnapshot) throws {
        do {
            guard querySnapshot.documents.first != nil else { throw FirebaseError.FbeDataNull(message: "ERROR: no data found in snapshot") }
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
                
                /*print("User: \(user)")*/
                
                if !self.userList.contains(user) {
                    self.userList.append(user)
                }
            }
            
            print("SUCESS: user list updated")
        } catch {
            throw error
        }
        
        print("DEBUG: ****USER LIST*****: \(self.userList)")
    }
    
    // ???: Function responsible for parsing firebase document and triggering Published variable update to user
    func updateCurrentUser(querySnapshot: QuerySnapshot) throws {
        do {
            guard let userDocument = querySnapshot.documents.first else { throw FirebaseError.FbeDataNull(message: "ERROR: no data found in snapshot") }
            
            let id = userDocument["id"] as! String
            let username = userDocument["username"] as! String
            let email = userDocument["email"] as! String
            let fullname = userDocument["fullname"] as! String
            
            self.user = User(
                id: id,
                username: username,
                email: email,
                fullname: fullname
            )
            
            print("SUCESS: user list updated")
        } catch {
            throw error
        }
        
        print("DEBUG: ****CURRENT USER*****: \(String(describing: self.user))")
    }
}
