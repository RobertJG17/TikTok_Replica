//
//  VideoCellView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI

struct VideoCellView: View {// 3 items of even width -2 pixels
    let post: Post
   
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        // what to return?
        Text("Video")
    }
}

#Preview {
    VideoCellView(post: 
        Post(
            id: "post_id",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            location: "orange",
            likes: 5,
            taggedUserIds: ["kdfjdlk", "dkfjdls"],
            likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]
        )
    )
}

