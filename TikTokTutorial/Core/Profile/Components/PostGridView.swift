//
//  PostGridView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct PostGridView: View {// 3 items of even width -2 pixels
    private let width = (UIScreen.main.bounds.width / 3) - 2
    private let posts: [Post]
    private let items = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    init(posts: [Post]) {
        self.posts = posts
    }
    
    var body: some View {
        LazyVGrid(columns: items, spacing: 2) {
            ForEach(posts) { post in
                // create
                Rectangle()
                .overlay(content: {
                    // TODO: Create Video Cell View
                    // should be able to pass in post
                    VideoCellView(post: post)
                })
                    .frame(width: width, height: 160)
                    .clipped()
            }
            
        }
    }
}


#Preview {
    PostGridView(
        posts: [
            Post(
                id: "post_id",
                videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                location: "orange",
                likes: 5,
                taggedUserIds: ["kdfjdlk", "dkfjdls"],
                likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]
            ),
            
            Post(
                id: "post_id",
                videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                location: "orange",
                likes: 5,
                taggedUserIds: ["kdfjdlk", "dkfjdls"],
                likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]
            )
        ]
    )
}
