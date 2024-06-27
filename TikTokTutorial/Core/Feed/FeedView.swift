//
//  FeedView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0 ..< 10) { post in
                    FeedCell(post: post)
                }
            }
            .scrollTargetLayout()
        }
        // "Modifiers" return a view that wraps the original view and replaces it in the view hierarchy
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
    }
}

#Preview {
    FeedView()
}
