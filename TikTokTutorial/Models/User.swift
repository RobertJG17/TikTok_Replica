//
//  User.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/5/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let username: String
    let email: String
    let fullname: String
    var bio: String?
    var profileImageUrl: String?
}
