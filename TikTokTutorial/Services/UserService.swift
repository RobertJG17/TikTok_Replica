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
    @Published var uploadURL: URL?
    @Published var uploadError: Error?
    
    // Cached data
    public var userCache: Cache<User>?
    public var userListCache: Cache<[User]>?
    public var postsCache: Cache<[Post]>?
    
    // TTL durations (e.g., 5 minutes)
    public let ttlDuration: TimeInterval = 30
    
            
//    func uploadUserData(_ user: User) async throws {
//        do {
//            let userData = try Firestore.Encoder().encode(user)
//            try await Firestore.firestore().collection(FirestoreCollection.users.rawValue).document(user.id).setData(userData)
//            print("SUCCESS: user data published to firestore")
//        } catch {
//            throw error
//        }
//    }
    
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
                throw FirebaseError.FbeGenericError(message: "ERROR: Unable to update current user: \(error)")
            }
            
        } else {
            do {
                return try await queryCollection(client: fsClient, collection: collection)
            } catch {
                throw FirebaseError.FbeGenericError(message: "ERROR: Unable to update user list: \(error)")
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
                    guard let userData = data as? User else { throw FirebaseError.FbeGenericError(message: "Unable to cast data as User") }
                    let user = try Firestore.Encoder().encode(userData)
                    try await Firestore.firestore().collection(FirestoreData.users.rawValue).document(userData.id).setData(user)
                    print("SUCCESS: User published to firestore")
                } catch {
                    throw FirebaseError.FbeGenericError(message: "Error encountered when publishing data: \(error)")
                }
            case FirestoreData.posts:
                do {
                    // !!!: CODE TO UPLOAD DATA TO POSTS COLLECTION
                    guard let userPost = data as? Post else { throw FirebaseError.FbeGenericError(message: "Unable to cast data as Post") }
                    
                    print("USER POST: \(userPost)")
                    let post = try Firestore.Encoder().encode(userPost)
                    try await Firestore.firestore().collection(FirestoreData.posts.rawValue).document(userPost.id).setData(post)
                    print("SUCCESS: Post published to firestore")
                    
                    uploadMediaToFirestore() { result in
                        self.isLoading.toggle()
                        
                        switch result {
                        case .success(let url):
                            self.uploadURL = url
                        case .failure(let error):
                            self.uploadError = error
                        }
                    }
                } catch {
                    throw FirebaseError.FbeGenericError(message: "Error encountered when publishing data: \(error)")
                }
            }
        } catch {
            throw error
        }
    }
    
    func uploadMediaToFirestore(completion: @escaping (Result<URL, Error>) -> Void) {
        print("User DEFAULTS: ", UserDefaults.standard.dictionaryRepresentation())
        if let fileURLString = UserDefaults.standard.string(forKey: "postMediaURL") {
            print("FILE URL STRING: ", fileURLString)
            let (storageRef, file, metadata) = buildFileAndMetaData(fileURLString: fileURLString)
            setupUploadTasks(storageRef: storageRef, file: file, metadata: metadata)

        } else {
            print("No file URL String")
        }
    }
    
    func buildFileAndMetaData(
        fileURLString: String
    ) -> (StorageReference, URL, StorageMetadata) {
        let file = URL(string: fileURLString)!
        let fileName = file.lastPathComponent
        
        // Initialize Firebase Storage Client
        let storage = Storage.storage()
        // Initialize Firebase reference
        let reference = storage.reference()

        // Create the file metadata
        let metadata = StorageMetadata()
        
        // Create Storage Reference
        let storageRef = reference.child("TikTokTutorialMedia/\(fileName)")
        
        // Get the file extension and determine the content type
        let fileExtension = file.pathExtension
        metadata.contentType = parseContentType(forFileExtension: fileExtension)
        
        return (storageRef, file, metadata)
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
        }

        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
        }

        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("Upload paused")
            self.isLoading.toggle()

        }

        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File doesn't exist \(error)")
                    break
                case .unauthorized:
                    print("User doesn't have permission to access file \(error)")
                    break
                case .cancelled:
                    print("User canceled the upload \(error)")
                    break
                    
                // TODO: Figure out any other cases to handle to make this exhaustive
                /* ... */

                case .unknown:
                    print("Unknown error occurred, inspect the server response\(error)")
                    break
                default:
                    // TODO: Implement retry
                    print("A separate error occurred: \(error)")
                    break
                }
            }
            
            self.isLoading.toggle()
        }
    }
    
    // MARK: (Method) Parse content type for media
    func parseContentType(forFileExtension fileExtension: String) -> String {
        switch fileExtension.lowercased() {
        // Image MIME types
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "bmp":
            return "image/bmp"
        case "webp":
            return "image/webp"
        
        // Video MIME types
        case "mp4":
            return "video/mp4"
        case "mov":
            return "video/quicktime"
        case "avi":
            return "video/x-msvideo"
        case "mkv":
            return "video/x-matroska"
        
        // Default MIME type for unknown file types
        default:
            return "application/octet-stream"
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
