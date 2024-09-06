//
//  ProfileHeaderView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ProfileHeaderView: View {
    // we observe state changes in our userInformation Published property
    @StateObject private var viewModel = ProfileHeaderViewModel()
    @State public var username: String?
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                // profile image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(Color(.systemGray5))
                
                // username
                Text("\(username ?? "-")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .onReceive(viewModel.$userInformation) { data in // on receive method call watches for changes to Published property
                        if let receivedData = data {
                            print("data: ", receivedData)
                            self.username = receivedData.username
                        } else {
                            print("no data")
                        }
                    }
                
                // stats view
                HStack(spacing: 16) {
                    UserStatView(value: 5, title: "Following")
                    UserStatView(value: 1, title: "Followers")
                    UserStatView(value: 7, title: "Likes")
                }
                
                // action button
                Button {
                    
                } label: {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 32)
                        .foregroundStyle(.black)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                Divider()
            }
        }
    }
}

#Preview {
    ProfileHeaderView()
}
