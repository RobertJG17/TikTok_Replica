//
//  PostGridView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct PostGrid: View {
    private var posts: [Post]

    private let width = (UIScreen.main.bounds.width / 3) - 2                // ???: 3 items of even width -2 pixels
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
                    VideoCell(
                        post: post
                    )
                })
                    .frame(width: width, height: 160)
                    .clipped()
            }
        }
    }
}


#Preview {
    PostGrid(
        posts: []
    )
}
