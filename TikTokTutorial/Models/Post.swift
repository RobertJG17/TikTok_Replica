//
//  Post.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/27/24.
//

import Foundation
import Firebase

struct Post: Identifiable, Codable {
    let userId: String                  // user id
    let id: String                      // id of post
    let title: String                   // title of post
    let caption: String                 // caption of post
    let likes: Int                      // number of likes (count of likeIds)
    let taggedUserIds: [String]         // array of strings (ids of users tags
    let likedUserIds: [String]          // array of strings (ids of users who liked post)
    var imageUrl: String?
    var timestamp: Timestamp?
    
    init(
        userId: String,
        id: String,
        title: String,
        caption: String,
        mediaUrl: String?,
        likes: Int,
        taggedUserIds: [String],
        likedUserIds: [String],
        imageUrl: String? = nil,
        timestamp: Timestamp? = nil
    ) {
        self.userId = userId
        self.id = id
        self.title = title
        self.caption = caption
        self.likes = likes
        self.taggedUserIds = taggedUserIds
        self.likedUserIds = likedUserIds
        self.imageUrl = imageUrl
        self.timestamp = timestamp
    }
    
    // Initializer to create a Post from Firestore document
    init?(from document: QueryDocumentSnapshot) {
        let data = document.data()
        
        print("DATA: \(data["imageUrl"])")
        
        // Extract fields safely
        guard let userId = data["userId"] as? String,
              let id = data["id"] as? String,
              let title = data["title"] as? String,
              let caption = data["caption"] as? String,
              let likes = data["likes"] as? Int,
              let taggedUserIds = data["taggedUserIds"] as? [String],
              let likedUserIds = data["likedUserIds"] as? [String] else {
            print("Error: Missing or incorrect data in Firestore document")
            return nil
        }
        
        // Convert imageUrl if it exists
        let imageUrl: String? = {
            if let imageUrl = data["imageUrl"] as? String {
                return imageUrl
            }
            return nil
        }()
        
        // Convert timestamp if it exists
        let timestamp: Timestamp? = {
            if let timestamp = data["timestamp"] as? Timestamp {
                return timestamp
            }
            return nil
        }()
        
        // Initialize the Post
        self.userId = userId
        self.id = id
        self.title = title
        self.caption = caption
        self.likes = likes
        self.taggedUserIds = taggedUserIds
        self.likedUserIds = likedUserIds
        self.imageUrl = imageUrl // Assuming `imageUrl` isn't available from the document
        self.timestamp = timestamp
    }
}
