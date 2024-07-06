//
//  StandardTextFieldModifier.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/28/24.
//

import SwiftUI


struct StandardTextFieldModifier: ViewModifier {
    private var displayErrorBorder: Bool
    
    init(displayErrorBorder: Bool) {
        self.displayErrorBorder = displayErrorBorder
    }
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 24)
            .shadow( // MARK: ERROR SHADOW
                color: displayErrorBorder ? Color.red : Color(.systemGray6),
                radius: displayErrorBorder ? 2 : 0,
                x: displayErrorBorder ? 2 : 0,
                y: displayErrorBorder ? 2 : 0
            )
    }
}
