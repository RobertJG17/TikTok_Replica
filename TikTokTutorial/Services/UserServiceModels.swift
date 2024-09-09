//
//  UserServiceDefaults.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/8/24.
//

import Foundation
import FirebaseFirestore

// MARK: Used in UserService
enum FirebaseError: Error {
    case FbeAuth(message: String)
    case FbeDataNull(message: String)
    case FbeUpdateError(message: String)
}

enum FirestoreCollection: String {
    case users = "users"
    case posts = "posts"
    // Add other collections as needed
}


