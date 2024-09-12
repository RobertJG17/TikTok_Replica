//
//  NotificationCell.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct NotificationCell: View {
    var body: some View {
        // profile icon next to action next to description
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundStyle(Color(.systemGray5))
            
            HStack {
                
                // MARK: Concatenation operator '+' allows merging of text regardless of Modifiers applied
                Text("max.verstappen")
                    .font(.footnote)
                    .fontWeight(.semibold) + Text(" ") +
                Text("Liked one of your posts fkl;sjsdfkl;sdsldjfkl")
                    .font(.footnote) + Text(" ") +
                Text("3d")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Rectangle()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.horizontal)
    }
}

#Preview {
    NotificationCell()
}
