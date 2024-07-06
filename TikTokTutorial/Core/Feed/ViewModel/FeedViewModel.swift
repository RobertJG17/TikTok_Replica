//
//  FeedViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/27/24.
//

import Foundation
import AVKit


class FeedViewModel: ObservableObject {
    // MARK: Defining a View Model - Model is reponsible for hosting video contents and functionality in a Class to
    // handle video interactions on feed from users.
    
    @Published var posts = [Post]()
    @Published var player = AVPlayer()
    @Published var userPausedVideo = false
    
    let videoUrls = [
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
    ]
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        self.posts = [
            .init(id: NSUUID().uuidString, videoUrl: videoUrls[0]),
            .init(id: NSUUID().uuidString, videoUrl: videoUrls[1]),
            .init(id: NSUUID().uuidString, videoUrl: videoUrls[2]),
            .init(id: NSUUID().uuidString, videoUrl: videoUrls[3])
        ]
    }
    
    func playInitialVideoIfNecessary(scrollPosition: String?) {
        guard
            scrollPosition == nil,
            let post = posts.first, // constant assigned using an optional binding (BUT NOT PART OF CONDITION)
                                    // is constant declaration here necessary?
            player.currentItem == nil else { return }
        
        let item = AVPlayerItem(url: URL(string: post.videoUrl)!)
        player.replaceCurrentItem(with: item)
    }
    
    func triggerPlaybackAction() {
        // used primarily for tap gesture
        // based on state of boolean, we either play the media or pause the media
        switch player.timeControlStatus {
        case .paused:
            player.play()
            break
        case .playing:
            player.pause()
            break
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }
    
    func playVideoOnChangeOfScrollPosition(postId: String?) {
        guard let currentPost = posts.first(where: { $0.id == postId }) else { return }
        
        // remove video from stack on transition to show nothing as content of next video loads
        player.replaceCurrentItem(with: nil)
        
        let playerItem = AVPlayerItem(url: URL(string: currentPost.videoUrl)! )
        player.replaceCurrentItem(with: playerItem)
    }
    
    
}
