//
//  UploadButton.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/10/24.
//

import SwiftUI


struct ApplicationButton: View {
    // pass in action, Text, background, color, radius
    var action: () -> Void
    var text: String?
    var systemImage: String?
    var background: Color
    var color: Color
    var radius: CGFloat
    var message: String?
    
    var body: some View {
        Button(action: {
            print(message ?? "no message on button click")
            action()
        }) {
            if let unwrappedText = text {
                Text(unwrappedText)
                    .padding()
                    .background(background)
                    .foregroundColor(color)
                    .cornerRadius(radius)
            }
            if let unwrappedImage = systemImage {
                Image(systemName: unwrappedImage)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
