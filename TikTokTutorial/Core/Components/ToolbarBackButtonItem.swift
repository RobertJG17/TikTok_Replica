//
//  ToolbarBackButtonItem.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/11/24.
//

import SwiftUI

// Pure View Component
struct ToolbarBackButtonItem: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
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

//#Preview {
//    ToolbarBackButtonItem()
//}

