//
//  ExploreView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    @Binding public var userList: [User]?
    @State private var selectedUser: User?
    @State private var posts: [Post]?
    
    private let publicUserService: UserService = UserService()
    
    init(userList: Binding<[User]?>) {
        self._userList = userList
        
        let exploreViewModel = ExploreViewModel(userService: publicUserService)
        self._viewModel = StateObject(wrappedValue: exploreViewModel)
    }
        
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(userList ?? []) { user in
                        NavigationLink {
                            UserProfileView(
                                user: user,
                                posts: $posts
                            )
                            .onAppear {
                                self.selectedUser = user
                                if let userId = selectedUser?.id, let username = selectedUser?.username {
                                    print("Fetching posts for \(username)")
                                    viewModel.fetchUserPost(userId: userId)
                                } else {
                                    print("no user id")
                                }
                            }
                            .onReceive(viewModel.$posts) { posts in
                                self.posts = posts
                            }
                        } label: {
                            UserCell(
                                username: user.username,
                                fullname: user.fullname
                            )
                        }
                    }
                }
            }
        }
        .highPriorityGesture(TapGesture())
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top)
    }
}

//#Preview {
//    ExploreView(userList: <#T##Binding<[User]?>#>)
//}
