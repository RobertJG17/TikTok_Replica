//
//  UserCell.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct UserCell: View {
    let username: String
    let fullname: String
    
    init(username: String, fullname: String) {
        self.username = username
        self.fullname = fullname
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color(.systemGray5))
            VStack(alignment: .leading) {
                Text(username)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(fullname)
                    .font(.footnote)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    UserCell(username: "username", fullname: "fullname")
}
