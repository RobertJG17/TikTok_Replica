//
//  ExploreView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct ExploreView: View {
    @Binding public var userList: [User]?
    @State private var selectedUser: User?
    
    
    // TODO: Create @Binding public var posts: [Post]?
    // TODO: Cretea User Service
    
    
    init(userList: Binding<[User]?>) {
        self._userList = userList
    }
        
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(userList ?? []) { user in
                        NavigationLink {
                            UserProfileView(user: $selectedUser)
                                .onAppear {
                                    selectedUser = user
                                }
                        } label: {
                            UserCell(
                                username: user.username,
                                fullname: user.fullname
                            )
                                .onTapGesture {
                                    print("User tapped: \(user)")
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
