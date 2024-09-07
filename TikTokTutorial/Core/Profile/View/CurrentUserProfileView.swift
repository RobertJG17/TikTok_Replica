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
    
    init(authService: AuthService, userService: UserService, uid: String) {
        self.authService = authService
        self.userService = userService
        self.uid = uid
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
