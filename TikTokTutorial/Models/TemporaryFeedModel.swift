//
//  TemporaryFeedModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/14/24.
//

import Foundation
import Firebase

struct TemporaryFeedModel: Identifiable, Codable {
    let id: String                      // id of post
    let mediaUrl: String
}
