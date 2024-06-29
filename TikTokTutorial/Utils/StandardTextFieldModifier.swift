//
//  StandardTextFieldModifier.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/28/24.
//

import SwiftUI


struct StandardTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 24)
    }
}
