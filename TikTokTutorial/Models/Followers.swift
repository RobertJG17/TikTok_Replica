//
//  Followers.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import Foundation

struct Followers: Identifiable, Codable {
    let id: String                  // id of post
    let count: Int                  // follower count
    let location: [String]            // array of follower ids
}
