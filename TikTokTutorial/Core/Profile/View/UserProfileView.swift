//
//  UserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI
import FirebaseAuth

// user profile view very similar to curr user profile view
// same vars, no user service, and no log out button

struct UserProfileView: View {
    // MARK: New userService to not update current user information published across application
    private let userService = UserService()
    public let uid: String
    public let username: String
    @State public var posts: [Post]?
    
    @StateObject private var viewModel: PostGridViewModel
    @Environment(\.dismiss) private var dismiss

    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        
        let postGridViewModel = PostGridViewModel(userService: userService, uid: uid)
        self._viewModel = StateObject(wrappedValue: postGridViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    // profile header
                    ProfileHeaderView(userService: userService, uid: uid)
                    // post grid view
                    if let userPosts = posts {
                        PostGridView(posts: userPosts)
                    } else {
                        NullPostsView()
                    }
                }
                .padding(.top)
                .onReceive(viewModel.$posts) { publishedPosts in
                    if let retrievedPosts = publishedPosts {
                        print("DEBUG: PUBLISHED POSTS: ", retrievedPosts)
                        posts = retrievedPosts
                    }
                }
            }
        }

        .navigationTitle("User Profile")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Custom back arrow
                            .font(.title2)
                    }
                }
            }
        }
        
    }
}

#Preview {
    UserProfileView(uid: "S1siDV70inemV92IqWFAvDcClsY2", username: "Bibbity")
}

