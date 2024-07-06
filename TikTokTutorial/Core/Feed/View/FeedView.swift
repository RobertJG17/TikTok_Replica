//
//  FeedView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI
import AVKit

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var scrollPosition: String?
    
    // MARK: Declaring AV Player at root of Feed View allows us to govern
    // a single AV Player between FeedCells that will conditionally play or pause videos
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.posts) { post in
                    FeedCell(post: post, viewModel: viewModel)
                        .id(post.id)
                    
                    // Handles playback of first video
                        .onAppear { viewModel.playInitialVideoIfNecessary(scrollPosition: scrollPosition) }
                }
            }
            .scrollTargetLayout()
        }
        // "Modifiers" return a view that wraps the original view and replaces it in the view hierarchy
        .onAppear {
            if !viewModel.userPausedVideo {
                viewModel.player.play()
            }
        }
        .onDisappear {
            let timeControlStatus = viewModel.player.timeControlStatus
            if (timeControlStatus == .playing) {
                viewModel.userPausedVideo = false
            } else {
                viewModel.userPausedVideo = true
            }
            
            viewModel.player.pause()
        }
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        
        // MARK: Handles onChange functionality for cycling videos on main feed
        // Does NOT handle initial playback of first video
        .onChange(of: scrollPosition) { _, newScrollPosition in
            // MARK: _ designates the unused oldScrollPosition
            viewModel.playVideoOnChangeOfScrollPosition(postId: newScrollPosition)
        }
    
    }
}

#Preview {
    FeedView()
}
