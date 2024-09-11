//
//  Post.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/27/24.
//

import Foundation

struct Post: Identifiable, Codable {
    let userId: String                  // user id
    let id: String                      // id of post
    let title: String                   // title of post
    let caption: String                 // caption of post
    let mediaUrl: String?               // media of post (photo/video)
    let likes: Int                      // number of likes (count of likeIds)
    let taggedUserIds: [String]         // array of strings (ids of users tags
    let likedUserIds: [String]          // array of strings (ids of users who liked post)
}
