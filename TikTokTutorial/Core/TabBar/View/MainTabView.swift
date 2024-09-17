//
//  MainTabView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI
import FirebaseAuth

struct MainTabView: View {
    @StateObject private var viewModel: TabBarViewModel
    @State private var user: User?
    @State private var posts: [Post]?
    @State private var userList: [User]?
    @State private var selectedTab = 0
    private var authService: AuthService
    private var userService: UserService

    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        
        let tabBarViewModel = TabBarViewModel(userService: userService)
        self._viewModel = StateObject(wrappedValue: tabBarViewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab){
            FeedView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill": "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Home")
                    }
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
             
            ExploreView(
                userList: userList
            )
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "person.2.fill": "person.2")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Friends")
                    }
                }
                .tag(1)
                .onAppear {
                    selectedTab = 1
                    viewModel.fetchUserList(collection: FirestoreData.users.rawValue)
                }
                .onReceive(viewModel.$userList) { publishedUserList in
                    if let currentUserList = publishedUserList {
                        self.userList = currentUserList
                    } else {
                        print(FirebaseError.GenericError)
                    }
                }
            
            UploadView(
                userService: userService
            )
                .tabItem { Image(systemName: "plus") }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            NotificationsView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "heart.fill": "heart")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                        Text("Inbox")

                    }
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            
            CurrentUserProfileView(
                user: user,
                posts: posts ?? [],
                userService: userService,
                authService: authService
            )
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 4 ? "person.fill": "person")
                            .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                        Text("Profile")
                    }
                }
                .tag(4)
                .onAppear {
                    selectedTab = 4
                    viewModel.fetchCurrentUser(collection: FirestoreData.users.rawValue)
                }
                .onReceive(viewModel.$user) { publishedUser in
                    if let currentUser = publishedUser {
                        self.user = currentUser
                        viewModel.fetchPosts(collection: FirestoreData.posts.rawValue, userId: currentUser.id)
                    } else {
                        print(FirebaseError.GenericError)
                    }
                }
                .onReceive(viewModel.$posts) { publishedPosts in
                    if let currentPosts = publishedPosts {
                        self.posts = currentPosts
                    } else {
                        print(FirebaseError.GenericError)
                    }
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainTabView(authService: AuthService(), userService: UserService())
}
