//
//  VideoCellView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI

struct VideoCell: View {// 3 items of even width -2 pixels
    let post: TemporaryFeedModel
   
    init(post: TemporaryFeedModel) {
        self.post = post
    }
    
    var body: some View {
        // what to return?
        Text("Post")
    }
}

#Preview {
    VideoCell(post: 
        TemporaryFeedModel(id: "", mediaUrl: "")
    )
}

