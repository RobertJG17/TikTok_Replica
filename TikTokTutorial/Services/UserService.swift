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
import FirebaseStorage


// interface for uploading and retrieving data from firestore for a User
@MainActor
class UserService: ObservableObject {
    // MARK: Published property we use to update CurrentUserProfileView
    @Published var user: User?
    
    // MARK: Published property we use to update ExploreView
    @Published var userList: [User] = []
    
    // MARK: Published property we use to update PostGridView
    @Published var posts: [Post] = []
    
    @Published var isLoading: Bool = false
    @Published var result: FirebaseResult = FirebaseResult.nores
    
    
    // TTL durations (e.g., 5 minutes)
    public let ttlDuration: TimeInterval = 30

    
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
                throw FirebaseError.FetchError(message: "Error trying to run query collection w/ params: \(error)")
            }
            
        } else {
            do {
                return try await queryCollection(client: fsClient, collection: collection)
            } catch {
                throw FirebaseError.FetchError(message: "Error trying to run query collection w/ no params: \(error)")
            }
        }
    }

    func publishInformation(
        collection: FirestoreData,                  // users OR posts for now
        data: Any
    ) async throws {
        // MARK: Guard syntax verifies we are an authorized Firebase User
        guard ((Auth.auth().currentUser?.uid) != nil)
        else {
            throw FirebaseError.FbeAuth(message: "ERROR: Unable to access Firebase with current authorization status")
        }
        
        do {
            // don't need user need post
            switch collection {
            case FirestoreData.users:
                do {
                    guard let userData = data as? User else { throw FirebaseError.CastError(message: "Unable to cast data as User") }
                    let user = try Firestore.Encoder().encode(userData)
                    try await Firestore.firestore().collection(FirestoreData.users.rawValue).document(userData.id).setData(user)
                    print("SUCCESS: User published to firestore")
                } catch {
                    throw FirebaseError.PublishError(message: "Error in publishInformation switch, case FirestoreData.users: \(error)")
                }
            case FirestoreData.posts:
                do {
                    guard let userPost = data as? Post else { throw FirebaseError.CastError(message: "Unable to cast data as Post") }
                    let post = try Firestore.Encoder().encode(userPost)
                    try await Firestore.firestore().collection(FirestoreData.posts.rawValue).document(userPost.id).setData(post)
                    print("SUCCESS: Post published to firestore")
                    
                    uploadMediaToFirestore() { _ in }
                } catch {
                    throw FirebaseError.PublishError(message: "Error in publishInformation switch, case FirestoreData.posts: \(error)")
                }
            }
        } catch {
            throw error
        }
    }
    
    func uploadMediaToFirestore(completion: @escaping (Result<URL, Error>) -> Void) {
        if let fileURLString = UserDefaults.standard.string(forKey: "postMediaURL") {
            print("FILE URL STRING: ", fileURLString)
            let (storageRef, file, metadata) = buildFileAndMetaData(fileURLString: fileURLString)
            setupUploadTasks(storageRef: storageRef, file: file, metadata: metadata)
        } else {
            print("No file URL String")
        }
    }
    
    func setupUploadTasks(
        storageRef: StorageReference,
        file: URL,
        metadata: StorageMetadata
    ) {
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = storageRef.putFile(from: file, metadata: metadata)

        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // !!!: Also fires when the upload starts!
            print("Upload resumed")
            self.isLoading.toggle()
        }
        
        uploadTask.observe(.pause) { snapshot in
            print("Upload paused")
            self.isLoading.toggle()
        }

        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let _ = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
        }

        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("Upload succeeded \(snapshot.status)!")
            self.result = FirebaseResult.success
            self.isLoading.toggle()
        }

        uploadTask.observe(.failure) { snapshot in
            if let error = getStorageUploadErrorHandler(snapshot: snapshot) {
                print("in .failure closure, ERROR: \(error)")
                self.result = FirebaseResult.failure
            } else {
                print("UNHANDLED ERROR FROM .FAILURE CLOSURE")
            }
            
            self.isLoading.toggle()
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
            
            print("DEBUG: --USER LIST--: \(String(describing: self.userList))")
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
