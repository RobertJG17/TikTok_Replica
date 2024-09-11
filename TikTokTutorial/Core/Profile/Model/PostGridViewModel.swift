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
    private let uid: String = Auth.auth().currentUser!.uid
    
    init(userService: UserService) {
        self.userService = userService
        
        // MARK: attributes returned - id, videoUrl, location, likes, taggedUserIds, likedUserIds
        Task { await fetchPosts() }

        setupPostsPropertyObserver()
    }
    
    func fetchPosts() async {
        do {
            let snapshot = try await self.userService.fetchInformation(collectionName: "posts", parameters: ["id": self.uid])
            // MARK: Calling method to publish changes to variable, updating any potential subscribers
            try self.userService.updatePosts(querySnapshot: snapshot)
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

