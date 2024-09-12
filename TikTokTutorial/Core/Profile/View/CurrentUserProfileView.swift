//
//  CurrentUserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI
import FirebaseAuth

struct CurrentUserProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var user: User?
    @State private var posts: [Post]?
    
    
    // MARK: Authentication and User Service dependency injection flow continue
    private var authService: AuthService
    private var userService: UserService
        
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        
        let profileViewModel = ProfileViewModel(userService: userService)
        self._viewModel = StateObject(wrappedValue: profileViewModel)
    }
    
    private func userDidUpdate(user: Published<User?>.Publisher.Output) {
        self.user = user
    }
    
    private func postsDidUpdate(posts: Published<[Post]?>.Publisher.Output) {
        self.posts = posts
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    // profile header
                    ProfileHeader(user: user)
                        .onReceive(viewModel.$user) { publishedUser in
                            userDidUpdate(user: publishedUser)
                        }
                    
                    // TODO: Find some way to capture loading state after fetching posts
                    Group {
                        if let userPosts = posts, !userPosts.isEmpty {
                            PostGrid(posts: userPosts)
                        } else {
                            NullPosts(
                                userType: UserProfileViewTypes.currentUser,
                                userService: userService
                            )
                        }
                    }
                    .onReceive(viewModel.$posts) { publishedPosts in
                        postsDidUpdate(posts: publishedPosts)
                    }
                }
                .padding(.top)
            }
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out") {
                        authService.signOut()
                        // call service
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.black)
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(authService: AuthService(), userService: UserService())
}
