//
//  UserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI
import FirebaseAuth


struct UserProfileView: View {
    private var posts: [Post]?
    private var user: User?
    
    init(user: User, posts: [Post]?) {
        self.user = user
        self.posts = posts
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    ProfileHeaderView(username: user?.username)
   
                    Group {
                        if posts != nil && !posts!.isEmpty {
                            PostGridView(posts: posts)
                        } else {
                            NullPostsView(
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

