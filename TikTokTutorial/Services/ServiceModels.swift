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
    case PublishError(message: String)
    case FetchError(message: String)
    case GenericError
    case CastError(message: String)
    case FbeDataUploadError(message: String)
}

enum FirestoreData: String {
    case users
    case posts
}

enum FirestoreUserParameters: String {
    case id
}

enum FirestorePostParameters: String {
    case userId
}

enum FirebaseResult: String {
    case success
    case failure
    case nores
}

enum MediaType {
    case image
    case video
}

enum SelectedMedia: Equatable {
    case image(UIImage)
    case video(URL)
}

enum UserProfileViewTypes {
    case currentUser
    case publicUser
}
