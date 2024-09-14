//
//  ExploreViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/6/24.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {
    // MARK: Published property we want to attach to UserService published property
    @Published var posts: [Post]?
    private var userService: UserService
    private var cancellables = Set<AnyCancellable>()

    init(userService: UserService) {
        self.userService = userService
        setupUserPostPropertyObserver()
    }
    
    // TODO: ALTER IMPLEMENTATION FOR FETCHING A USERS POSTS
    // !!!: parmeter no longer a default, will have to leverage user to pass in id
    func fetchUserPost(userId: String, collection: String = FirestoreData.posts.rawValue) {
        Task {
            do {
                let snapshot = try await self.userService.fetchInformation(
                    collectionName: collection,
                    parameters: [FirestorePostParameters.userId
                        .rawValue: userId ]
                )
                try self.userService.updatePosts(querySnapshot: snapshot)
            } catch {
                print(error)
            }
        }
    }
    
    private func setupUserPostPropertyObserver() {
        userService.$posts.sink { [weak self] posts in
            self?.posts = posts
        }.store(in: &cancellables)
    }
}
