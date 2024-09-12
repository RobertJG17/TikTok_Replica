//
//  TabBarViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/12/24.
//

import SwiftUI
import Combine
import FirebaseAuth


enum UserServiceProperty {
    case user
    case posts
}

@MainActor
class TabBarViewModel: ObservableObject {
    @Published var user: User?
    @Published var posts: [Post]?
    @Published var userList: [User]?
    
    private var userService: UserService
    
    private var userCancellables = Set<AnyCancellable>()
    private var postsCancellables = Set<AnyCancellable>()
    private var userListCancellables = Set<AnyCancellable>()
    
    init(userService: UserService) {
        self.userService = userService
        setupUserPropertyObserver()
        setupPostsPropertyObserver()
    }
    
    func fetch(id: String?, property: UserServiceProperty) async {
        do {
            print("Id: ", id)
            guard let userId = id else { throw GenericErrors.Uninitialized }
            
            switch(property) {
            case UserServiceProperty.user:
                print("in user property switch")
                let snapshot = try await self.userService.fetchInformation(
                    collectionName: "users",
                    parameters: [
                        "id": userId
                    ]
                )
                try self.userService.updateCurrentUser(querySnapshot: snapshot)
                print("called updatedCurrentUser")
            case UserServiceProperty.posts:
                let snapshot = try await self.userService.fetchInformation(
                    collectionName: "posts",
                    parameters: [
                        "id": userId
                    ]
                )
                // MARK: Calling method to publish changes to variable, updating any potential subscribers
                try self.userService.updatePosts(querySnapshot: snapshot)
                
            }
        } catch {
            print("Error in profile view model fetch: \(error)")
        }
        
    }
    
    private func setupUserPropertyObserver() {
        userService.$user.sink { [weak self] user in
            print("USER FROM PROPERTY OBSERVER: ", user as Any)
            self?.user = user
            if let userId = user?.id {
                Task {
                    await self?.fetch(id: userId, property: .user)
                }
            }
            
        }.store(in: &userCancellables)
    }
    
    private func setupPostsPropertyObserver() {
        userService.$posts.sink { [weak self] posts in
            self?.posts = posts
            if let userId = self?.user?.id {
                Task {
                    await self?.fetch(id: userId, property: .posts)
                }
            }
            
            
        }.store(in: &postsCancellables)
    }
}


