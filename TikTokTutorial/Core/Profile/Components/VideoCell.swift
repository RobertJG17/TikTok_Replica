//
//  VideoCellView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI

struct VideoCell: View {// 3 items of even width -2 pixels
    let post: Post
   
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        // what to return?
        Text("Post")
    }
}

#Preview {
    VideoCell(post: 
        Post(
            userId: "user_id",
            id: "post_id",
            title: "post1",
            caption: "caption",
            mediaUrl: "orange",
            likes: 5,
            taggedUserIds: ["kdfjdlk", "dkfjdls"],
            likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]
        )
    )
}

