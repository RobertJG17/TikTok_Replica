//
//  UserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI
import FirebaseAuth


struct UserProfileView: View {
    @Binding private var posts: [Post]?
    private var user: User?
    
    // MARK: New userService to not update current user information published across application
    init(user: User, posts: Binding<[Post]?>) {
        self.user = user
        self._posts = posts
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    ProfileHeader(username: user?.username)
   
                    // TODO: Find some way to capture loading state after fetching posts
                    Group {
                        if let userPosts = posts, !userPosts.isEmpty {
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

//#Preview {
//    UserProfileView(user: User(id: "", username: "", email: "", fullname: "", bio: "", profileImageUrl: ""))
//}

