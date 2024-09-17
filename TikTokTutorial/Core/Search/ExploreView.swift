//
//  ExploreView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    @State private var posts: [Post]?
    public var userList: [User]?
    
    private let publicUserService: UserService = UserService()
    
    init(userList: [User]?) {
        self.userList = userList
        
        let exploreViewModel = ExploreViewModel(userService: publicUserService)
        self._viewModel = StateObject(wrappedValue: exploreViewModel)
    }
        
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if let users = userList {
                        ForEach(users) { user in
                            NavigationLink {
                                UserProfileView(
                                    user: user,
                                    posts: posts
                                )
                                .onAppear {
                                    print("Fetching posts for \(user.username)")
                                    viewModel.fetchUserPost(userId: user.id)
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
