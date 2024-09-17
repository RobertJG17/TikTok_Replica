//
//  CurrentUserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI
import FirebaseAuth

struct CurrentUserProfileView: View {
    private var user: User?
    private var posts: [Post]?
    
    
    private var userService: UserService
    private var authService: AuthService
    
    init(user: User?, posts: [Post], userService: UserService, authService: AuthService) {
        self.user = user
        self.posts = posts
        self.userService = userService
        self.authService = authService
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    // profile header
                    ProfileHeaderView(username: user?.username)
                    
                    // TODO: Find some way to capture loading state after fetching posts
                    Group {
                        if posts != nil && !posts!.isEmpty {
                            PostGridView(posts: posts)
                        } else {
                            NullPostsView(
                                userType: UserProfileViewTypes.currentUser,
                                userService: userService
                            )
                        }
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

//#Preview {
//    CurrentUserProfileView(
//        user: User(id: "", username: "", email: "", fullname: "", bio: "", profileImageUrl: ""),
//        userService: UserService(),
//        authService: AuthService()
//    )
//}
