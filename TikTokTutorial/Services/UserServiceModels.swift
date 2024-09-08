//
//  UserServiceDefaults.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/8/24.
//

import Foundation

// MARK: Used in UserService
enum FirebaseError: Error {
    case FbeAuth(message: String)
    case FbeDataNull(message: String)
    case FbeUpdateError(message: String)
}

protocol FirebaseCollectionAlias {
    var firebaseUsers: String { get }
}

extension FirebaseCollectionAlias {
    var firebaseUsers: String {
        return "users"
    }
}
