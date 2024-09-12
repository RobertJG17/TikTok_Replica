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
    
    private var isButtonDisabled: Bool {
        print("Bool test: \(title != "" && caption != "")")
        return title == "" && caption == ""
    }

    
    init(
        showMediaPicker: Bool,
        width: CGFloat,
        height: CGFloat,
        title: String,
        caption: String,
        toggleMediaPicker: @escaping () -> Void
    ) {
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
            print("Button disabled \(isButtonDisabled)")
        }) {
            /*Image(systemName: "photo.on.rectangle") */                // Replace with your icon name or system image
            Image(systemName: "arrow.up.circle")                                  // Make the image resizable
                .resizable()
                .padding()
                .background(
                    isButtonDisabled ?
                    Color.gray:
                    Color.black
                )
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .frame(width: width / 4.5, height: height/10)
                .opacity(
                    isButtonDisabled ?
                        0.9:
                        1
                )
        }
        .position(CGPoint(x: width - (width * 0.55), y: height - (height * 0.95)))
        .animation(.bouncy, value: title)
        .animation(.bouncy, value: caption)
        .disabled(isButtonDisabled)
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
