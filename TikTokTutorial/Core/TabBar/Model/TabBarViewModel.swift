//
//  TabBarViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/12/24.
//

import SwiftUI
import Combine
import FirebaseAuth


@MainActor
class TabBarViewModel: ObservableObject {
    @Published public var user: User?
    @Published public var posts: [Post]?
    @Published public var userList: [User]?
    
    private var userService: UserService
    
    private var userCancellables = Set<AnyCancellable>()
    private var postsCancellables = Set<AnyCancellable>()
    private var userListCancellables = Set<AnyCancellable>()
    
    init(userService: UserService) {
        self.userService = userService
        setupUserPropertyObserver()
        setupPostsPropertyObserver()
        setupUserListPropertyObserver()
    }
    
    
    func fetchCurrentUser(collection: String = FirestoreData.users.rawValue) {
        Task {
            do {
                guard let userId = Auth.auth().currentUser?.uid else { throw FirebaseError.FbeAuth(message: "No user id found in TabBarViewModel fetchCurrentUser") }
                
                let snapshot = try await self.userService.fetchInformation(
                    collectionName: collection,
                    parameters: [
                        FirestoreUserParameters.id.rawValue: userId
                    ]
                )
                
                try self.userService.updateCurrentUser(querySnapshot: snapshot)
            } catch {
                print(error)
            }
            
        }
    }
    
    func fetchPosts(collection: String, userId: String) {
        Task {
            do {
                guard (Auth.auth().currentUser?.uid != nil) else { throw FirebaseError.FbeAuth(message: "No user id found in TabBarViewModel fetchPosts") }
                let snapshot = try await self.userService.fetchInformation(
                    collectionName: FirestoreData.posts.rawValue,
                    parameters: [
                        FirestorePostParameters.userId.rawValue: userId
                    ]
                )
                try self.userService.updatePosts(querySnapshot: snapshot)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchUserList(collection: String) {
        Task {
            do {
                let snapshot = try await self.userService.fetchInformation(
                    collectionName: FirestoreData.users.rawValue,
                    parameters: nil
                )
                try self.userService.updateUserList(querySnapshot: snapshot)
            } catch {
                print(error)
            }
        }
    }

    
    
    // MARK: Subscribers for properties
    private func setupUserPropertyObserver() {
        userService.$user.sink { [weak self] user in
            self?.user = user
        }.store(in: &userCancellables)
    }
    
    private func setupPostsPropertyObserver() {
        userService.$posts.sink { [weak self] posts in
            self?.posts = posts
        }.store(in: &postsCancellables)
    }
    
    private func setupUserListPropertyObserver() {
        userService.$userList.sink { [weak self] userList in
            self?.userList = userList
        }.store(in: &userListCancellables)
    }
}
