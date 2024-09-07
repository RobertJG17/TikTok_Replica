//
//  ExploreView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    @State public var userList: [User]?
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
        
        let exploreViewModel = ExploreViewModel(userService: userService)
        self._viewModel = StateObject(wrappedValue: exploreViewModel)
    }
        
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(userList ?? []) { user in
                        NavigationLink {
                            UserProfileView(
                                userService: userService,
                                uid: user.id,
                                username: user.username
                            )
                        } label: {
                            UserCell(username: user.username, fullname: user.fullname)
                                .onTapGesture {
                                    print("User tapped: \(user)")
                                }
                        }
                    }
                }
            }
            .onReceive(viewModel.$userList) { list in
                if let publishedList = list {
                    self.userList = publishedList
                } else {
                    print("no users in list")
                }
            }
        }
        .highPriorityGesture(TapGesture())
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top)
    }
}

#Preview {
    ExploreView(userService: UserService())
}
