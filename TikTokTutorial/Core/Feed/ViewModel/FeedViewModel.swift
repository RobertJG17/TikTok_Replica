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
            .init(
                userId: "user_id",
                id: NSUUID().uuidString,
                title: "post1",
                caption: "Buck Bunny!",
                mediaUrl: videoUrls[0],
                likes: 500,
                taggedUserIds: ["kdfjdlk", "dkfjdls"],
                likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]),
            .init(
                userId: "user_id",
                id: NSUUID().uuidString,
                title: "post2",
                caption: "ElephantsDream",
                mediaUrl: videoUrls[1],
                likes: 500,
                taggedUserIds: ["kdfjdlk", "dkfjdls"],
                likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]),
            .init(
                userId: "user_id",
                id: NSUUID().uuidString,
                title: "post3",
                caption: "ForBiggerBlazes",
                mediaUrl: videoUrls[2],
                likes: 500,
                taggedUserIds: ["kdfjdlk", "dkfjdls"],
                likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]),
            .init(
                userId: "user_id",
                id: NSUUID().uuidString,
                title: "post4",
                caption: "ForBiggerEscapes",
                mediaUrl: videoUrls[3],
                likes: 500,
                taggedUserIds: ["kdfjdlk", "dkfjdls"],
                likedUserIds: ["dfdkjslfj", "dlsfjsdkljfkl"]),
        ]
    }
    
    func playInitialVideoIfNecessary(scrollPosition: String?) {
        guard
            scrollPosition == nil,
            let post = posts.first, // constant assigned using an optional binding (BUT NOT PART OF CONDITION)
                                    // is constant declaration here necessary?
            player.currentItem == nil else { return }
        
        if let mediaUrl = post.mediaUrl {
            let item = AVPlayerItem(url: URL(string: mediaUrl)!)
            player.replaceCurrentItem(with: item)
        }
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
        
        if let mediaUrl = currentPost.mediaUrl {
            let playerItem = AVPlayerItem(url: URL(string: mediaUrl)! )
            player.replaceCurrentItem(with: playerItem)
        }
    }
}
