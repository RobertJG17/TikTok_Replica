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
    private let userService: UserService
    public let uid: String
    public let username: String
    
    @Environment(\.dismiss) private var dismiss

    init(userService: UserService, uid: String, username: String) {
        self.userService = userService
        self.uid = uid
        self.username = username
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    // profile header
                    ProfileHeaderView(userService: userService, uid: uid)
                    // post grid view
                    PostGridView()
                }
                .padding(.top)
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
    UserProfileView(userService: UserService(), uid: "S1siDV70inemV92IqWFAvDcClsY2", username: "Bibbity")
}
