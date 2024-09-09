//
//  PostGridViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import Foundation
import Combine
import FirebaseAuth


@MainActor
class PostGridViewModel: ObservableObject {
    @Published var posts: [Post]?
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserService
    public let uid: String
    
    init(userService: UserService, uid: String) {
        self.userService = userService
        self.uid = uid
        
        if (!self.userService.isCacheValid(for: self.userService.postsCache)) {
            // MARK: attributes returned - id, videoUrl, location, likes, taggedUserIds, likedUserIds
            Task { await fetchPosts() }
        } else {
            self.userService.invalidateCache(property: "posts")
        }
        
        setupPostsPropertyObserver()
    }
    
    func fetchPosts() async {
        do {
            if (!self.userService.isCacheValid(for: self.userService.postsCache)) {
                let snapshot = try await self.userService.fetchInformation(collectionName: "posts", parameters: ["id": self.uid])
                // MARK: Calling method to publish changes to variable, updating any potential subscribers
                try self.userService.updatePosts(querySnapshot: snapshot)
            } else {
                self.userService.invalidateCache(property: "posts")
            }
        } catch {
            print(error)
        }
    }
    
    private func setupPostsPropertyObserver() {
        userService.$posts.sink { [weak self] userPosts in
            self?.posts = userPosts
        }.store(in: &cancellables)
    }
}

