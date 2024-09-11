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
            /*Image(systemName: "photo.on.rectangle") */                // Replace with your icon name or system image
            Text("Upload Post")                                   // Make the image resizable
                .padding()
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .frame(width: .infinity, height: 100)
        }
        .position(CGPoint(x: width - (width * 0.55), y: height - (height * 0.95)))
        .animation(.bouncy, value: title)
        .animation(.bouncy, value: caption)
    }
}

#Preview {
    MediaPickerButton(
        showMediaPicker: true,
        width: UIScreen.main.bounds.width,
        height: UIScreen.main.bounds.height,
        title: "title",
        caption: "caption",
        toggleMediaPicker: {} 
    )
}
