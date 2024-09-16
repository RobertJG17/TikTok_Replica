//
//  NullPostsView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI

struct NullPostsView: View {
    private let userType: UserProfileViewTypes
    private var userService: UserService?
    private let height = UIScreen.main.bounds.width
    private var paddingTop: CGFloat {
        return (height / 2.0) - (height / 6.0)                      // since header occupies top 3rd
                                                                    // of screen, push view down a bit
    }
    
    init(userType: UserProfileViewTypes, userService: UserService?) {
        self.userType = userType
        self.userService = userService
    }
    
    
    var body: some View {
        // Tempoary, until I get some legit designs (Nic)
        VStack {
            switch(self.userType) {
            case UserProfileViewTypes.publicUser:
                Text("No user posts found")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .shadow(color:Color.orange, radius: 0.5, x: 1.5, y: 1.5)
            case UserProfileViewTypes.currentUser:
                NavigationLink {
                    if let service = userService {
                        UploadView(
                            userService: service
                        )
                    }
                } label: {
                    VStack {
                        Text("Upload a post!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "plus") // Custom back arrow
                            .font(.title2)
                            .padding(.top, 10)
                    }
                    
                }
            }
        }.overlay {
            if (self.userType == UserProfileViewTypes.publicUser) {
                HStack {
                    Text("🤔")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .opacity(0.3)
                    VStack {
                        Text("🤔")
                            .font(.system(size: 150, weight: .bold, design: .serif))
                            .opacity(0.19)
                    }
                    Text("🤔")
                        .font(.system(size: 60, weight: .bold, design: .serif))
                        .opacity(0.15)
                }
            }
            
        }
        .padding(.top, paddingTop)
    }
}

#Preview {
    NullPostsView(
        userType: UserProfileViewTypes.currentUser,
        userService: UserService()
    )
}
