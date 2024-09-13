//
//  UserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI
import FirebaseAuth


struct UserProfileView: View {
    @Binding private var user: User?
    private var posts: [Post]?
    
    // MARK: New userService to not update current user information published across application
    init(user: Binding<User?>) {
        self._user = user
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

