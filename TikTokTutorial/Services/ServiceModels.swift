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
    case FbeGenericError(message: String)
    case FbeDataUploadError(message: String)
}

enum FirestoreData: String {
    case users
    case posts
}

enum FirebaseResult: String {
    case success
    case failure
    case nores
}
