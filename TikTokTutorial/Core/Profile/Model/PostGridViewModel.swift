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
        Task { await fetchPosts() }                     // attributes returned: username, fullname, email, uid
        setupPostsPropertyObserver()
    }
    
    func fetchPosts() async {
        do {
            try await self.userService.fetchInformation(collectionName: "posts", parameters: ["id": self.uid])
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

