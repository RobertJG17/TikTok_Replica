//
//  MediaPickerButton.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/10/24.
//

import SwiftUI


struct MediaPickerButton: View {
    private var showMediaPicker: Bool
    private let width: CGFloat
    private let height: CGFloat
    private let title: String
    private let caption: String
    private let toggleMediaPicker: () -> Void

    
    init(showMediaPicker: Bool, width: CGFloat, height: CGFloat, title: String, caption: String, toggleMediaPicker: @escaping () -> Void) {
        self.showMediaPicker = showMediaPicker
        self.width = width
        self.height = height
        self.title = title
        self.caption = caption
        self.toggleMediaPicker = toggleMediaPicker
    }
    
    var body: some View {
        Button(action: {
            self.toggleMediaPicker()
        }) {
            Image(systemName: "photo.on.rectangle")                 // Replace with your icon name or system image
                .resizable()                                        // Make the image resizable
                .aspectRatio(contentMode: .fit)                     // Maintain aspect ratio
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(width: 100, height: 100)
        }
        .position(CGPoint(x: width - (width * 0.55), y: height - (height * 0.95)))
        .animation(.bouncy, value: title)
        .animation(.bouncy, value: caption)
    }
}
