//
//  UploadTextField.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/10/24.
//

import SwiftUI

struct UploadTextField: View {
    @Binding var publishedValue: String
    @State var animationTriggerValue: String 
    var label: String
    var bottomPadding: CGFloat
    
    private func getTitleString() -> String {
        return "\(label[label.startIndex].uppercased())" +
               "\(label[label.index(after: label.startIndex) ..< label.endIndex])"
    }
    
    var body: some View {
        VStack {
            Text(getTitleString())
                .font(.system(size: 20, weight: .medium, design: .default))
                

            // Title TextField
                HStack {
                TextField("Enter \(label)", text: $publishedValue)
                if !publishedValue.isEmpty {
                    Button(action: {
                        publishedValue = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
            .animation(.bouncy, value: publishedValue)
        }
        .padding(.bottom, bottomPadding)
        .animation(.bouncy, value: animationTriggerValue)

    }
}
