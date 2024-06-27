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
        .onTapGesture {
            videoTapGestureHandler()
        }
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .onChange(of: scrollPosition) { _, newScrollPosition in
            // MARK: _ designates the unused oldScrollPosition
            playVideoOnChangeOfScrollPosition(postId: newScrollPosition)
        }
    }
    
    func videoTapGestureHandler() {
        // MARK: Using player rate and error properties to check state of av player https://stackoverflow.com/questions/5655864/check-play-state-of-avplayer
        let isVideoPlaying = player.rate != 0 && player.error == nil
        
        // based on state of boolean, we either play the media or pause the media
        switch isVideoPlaying {
        case false:
            player.play()
            break
        case true:
            player.pause()
            break
        }
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
