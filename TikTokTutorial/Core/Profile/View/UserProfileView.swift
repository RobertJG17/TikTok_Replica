//
//  UserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI
import FirebaseAuth


struct UserProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    private var username: String
    
    // MARK: New userService to not update current user information published across application
    private var publicUserService = UserService()
        
    init(username: String) {
        self.username = username
        let profileViewModel = ProfileViewModel(userService: publicUserService)
        self._viewModel = StateObject(wrappedValue: profileViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    ProfileHeader(username: username)
   
                    // TODO: Find some way to capture loading state after fetching posts
                    Group {
                        if let userPosts = viewModel.posts, !userPosts.isEmpty {
                            PostGrid(posts: userPosts)
                        } else {
                            NullPosts(
                                userType: UserProfileViewTypes.publicUser,
                                userService: nil
                            )
                        }
                    }
                }
                .padding(.top)
            }
        }

        .navigationTitle("User Profile")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                ToolbarBackButtonItem()
            }
        }
    }
}

#Preview {
    UserProfileView()
}

