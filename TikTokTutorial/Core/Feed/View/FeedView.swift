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
    @State private var player = AVPlayer()
    
    // MARK: Declaring AV Player at root of Feed View allows us to govern
    // a single AV Player between FeedCells that will conditionally play or pause videos
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.posts) { post in
                    FeedCell(post: post, player: player)
                        .id(post.id)
                    
                        // Handles playback of first video
                        .onAppear { playInitialVideoIfNecessary() }
                }
            }
            .scrollTargetLayout()
        }
        // "Modifiers" return a view that wraps the original view and replaces it in the view hierarchy
        .onAppear{
            player.play()
        }
        .onDisappear{
            player.pause()
        }
        
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        
        // MARK: Handles onChange functionality for cycling videos on main feed
        // Does NOT handle initial playback of first video
        .onChange(of: scrollPosition) { _, newScrollPosition in
            // MARK: _ designates the unused oldScrollPosition
            playVideoOnChangeOfScrollPosition(postId: newScrollPosition)
        }
    
    }
    
    func playInitialVideoIfNecessary() {
        guard
            scrollPosition == nil,
            let post = viewModel.posts.first,
            player.currentItem == nil else { return }
        
        let item = AVPlayerItem(url: URL(string: post.videoUrl)!)
        player.replaceCurrentItem(with: item)
    }
    
    func playVideoOnChangeOfScrollPosition(postId: String?) {
        guard let currentPost = viewModel.posts.first(where: { $0.id == postId }) else { return }
        
        // remove video from stack on transition to show nothing as content of next video loads
        player.replaceCurrentItem(with: nil)
        
        let playerItem = AVPlayerItem(url: URL(string: currentPost.videoUrl)! )
        player.replaceCurrentItem(with: playerItem)
    }
}

#Preview {
    FeedView()
}
