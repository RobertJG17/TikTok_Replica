//
//  UserService.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


// interface for uploading and retrieving data from firestore for a User
@MainActor
class UserService: ObservableObject {
    // MARK: Published property we use to update CurrentUserProfileView
    @Published var user: User?
    
    // MARK: Published property we use to update ExploreView
    @Published var userList: [User] = []
    
    // MARK: Published property we use to update PostGridView
    @Published var posts: [Post] = []
    
    // Cached data
    public var userCache: Cache<User>?
    public var userListCache: Cache<[User]>?
    public var postsCache: Cache<[Post]>?
    
    // TTL durations (e.g., 5 minutes)
    public let ttlDuration: TimeInterval = 30
    
            
    func uploadUserData(_ user: User) async throws {
        do {
            let userData = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection(FirestoreCollection.users.rawValue).document(user.id).setData(userData)
            print("SUCCESS: user data published to firestore")
        } catch {
            throw error
        }
    }
    
    func isCacheValid<T>(for cache: Cache<T>?) -> Bool {
        if let cacheData = cache {
            return Date().timeIntervalSince(cacheData.timestamp) < ttlDuration
        } else {
            return false
        }
    }
    
    func invalidateCache(property: String) {
        switch(property) {
        case "user":
            userCache = nil
            break
        case "userList":
            userListCache = nil
            break
        case "posts":
            postsCache = nil
            break
        default:
            print("default case in invalidate")
        }
    }
    
    func closeConnectionToFirestore(firestoreClient: Firestore) async throws {
        do {
            try await firestoreClient.terminate()
        } catch {
            throw FirebaseError.FbeAuth(message: "Failed to terminate Firestore instance")
        }
    }
    
    // MARK: Async API Routing function, accepts Firestore collection name and query parameters
    func fetchInformation(collectionName: String, parameters: [String: String]?) async throws -> QuerySnapshot {
        print("DEBUG: fetch information initiated")
        
        // MARK: Guard syntax verifies we are an authorized Firebase User
        guard ((Auth.auth().currentUser?.uid) != nil)
        else {
            throw FirebaseError.FbeAuth(message: "ERROR: Unable to access Firebase with current authorization status")
        }
        
        let fsClient = Firestore.firestore()                                    // initialize firestore client
        let collection = fsClient.collection(collectionName)
                
        // MARK: Using conditional assignment to unwrap parameters - if they exist
        if let unwrappedParameters = parameters {
            do {
                // MARK: Use unwrapped parameters to configure a custom firebase query
                return try await queryCollectionWithParams(client: fsClient, collection: collection, parameters: unwrappedParameters)
            } catch {
                // MARK: Custom Firebase enum conforms to Error protocol, allowing us to implement custom error handling
                throw FirebaseError.FbeUpdateError(message: "ERROR: Unable to update current user: \(error)")
            }
            
        } else {
            do {
                return try await queryCollection(client: fsClient, collection: collection)
            } catch {
                throw FirebaseError.FbeUpdateError(message: "ERROR: Unable to update user list: \(error)")
            }
        }
    }
    
    // ???: Function responsible for handling query with no parameters
    func queryCollection(client: Firestore, collection: CollectionReference) async throws -> QuerySnapshot {
        do {
            
            let querySnapshot = try await collection.getDocuments()
            try await self.closeConnectionToFirestore(firestoreClient: client)
            return querySnapshot
        } catch {
            throw error
        }
    }
    
    // ???: Function responsible for handling parameter driven query
    func queryCollectionWithParams(client: Firestore, collection: CollectionReference, parameters: [String: String]) async throws -> QuerySnapshot {
        do {
            // ???: Function responsible for applying multiple parameters to a query
            var query: Query = collection
            for (parameterKey, parameterValue) in parameters {
                query = query.whereField(parameterKey, isEqualTo: parameterValue)
            }
            let querySnapshot = try await query.getDocuments()
            try await self.closeConnectionToFirestore(firestoreClient: client)
            return querySnapshot
        } catch {
            throw error
        }
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
            
            userListCache = Cache(data: self.userList, timestamp: Date())
            print("DEBUG: --USER LIST--: \(String(describing: self.userListCache))")
        } catch {
            throw error
        }
    }
    
    // ???: Function responsible for parsing firebase document and triggering Published variable update to user
    func updateCurrentUser(querySnapshot: QuerySnapshot) throws {
        do {
            guard let userDocument = querySnapshot.documents.first else { throw FirebaseError.FbeDataNull(message: "ERROR: no data found in snapshot") }
            
            let id = userDocument["id"] as! String
            let username = userDocument["username"] as! String
            let email = userDocument["email"] as! String
            let fullname = userDocument["fullname"] as! String
            
            let currentUser = User(
                id: id,
                username: username,
                email: email,
                fullname: fullname
            )
            
            self.user = currentUser

            userCache = Cache(data: currentUser, timestamp: Date())
            print("DEBUG: --CURRENT USER--: \(String(describing: self.userCache))")
        } catch {
            throw error
        }
    }
    
    func updatePosts(querySnapshot: QuerySnapshot) throws {
        do {
            print("UPDATE POSTS QUERY SNAPSHOT: ", querySnapshot.metadata)
            guard querySnapshot.documents.first != nil else { throw FirebaseError.FbeDataNull(message: "ERROR: no data found in snapshot") }
            
            print("DEBUG: --USER POSTS-- \(String(describing: self.posts))")
            
            // only enter this function if cache is invalidated
//            postsCache = Cache(data: self.posts, timestamp: Date())
        } catch {
            
        }
    }
}
