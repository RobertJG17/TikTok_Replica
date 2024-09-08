//
//  CurrentUserProfileView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI
import FirebaseAuth

struct CurrentUserProfileView: View {
    private let authService: AuthService
    private let userService: UserService
    private let uid: String
    
    @State public var posts: [Post]?

    @StateObject private var viewModel: PostGridViewModel
    
    init(authService: AuthService, userService: UserService, uid: String) {
        self.authService = authService
        self.userService = userService
        self.uid = uid
        
        let postGridViewModel = PostGridViewModel(userService: userService, uid: uid)
        self._viewModel = StateObject(wrappedValue: postGridViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    // profile header
                    ProfileHeaderView(userService: userService, uid: uid)
                    
                    if let userPosts = posts {
                        PostGridView(posts: userPosts)
                    } else {
                        NullPostsView()
                    }
                }
                .padding(.top)
                .onReceive(viewModel.$posts) { publishedPosts in
                    if let retrievedPosts = publishedPosts {
//                        print("DEBUG: PUBLISHED POSTS FROM CURRENTUSERPROFILEVIEW: ", retrievedPosts)
                        posts = retrievedPosts
                    }
                }
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
    CurrentUserProfileView(authService: AuthService(), userService: UserService(), uid: "S1siDV70inemV92IqWFAvDcClsY2")
}
