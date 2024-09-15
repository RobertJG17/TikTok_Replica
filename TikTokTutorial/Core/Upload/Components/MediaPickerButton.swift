//
//  MediaPickerButton.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/10/24.
//

import SwiftUI
import Combine

enum MediaPickerTextFields: String {
    case title
    case caption
}

struct MediaPickerButton: View {
    @StateObject private var viewModel: DebounceViewModel
    @Binding private var title: String
    @Binding private var caption: String
    
    private var showMediaPicker: Bool
    private let width: CGFloat
    private let height: CGFloat
    
    private let toggleMediaPicker: () -> Void
        
    init(
        showMediaPicker: Bool,
        width: CGFloat,
        height: CGFloat,
        title: Binding<String>,
        caption: Binding<String>,
        toggleMediaPicker: @escaping () -> Void
    ) {
        self.showMediaPicker = showMediaPicker
        self.width = width
        self.height = height
        self._title = title
        self._caption = caption
        self.toggleMediaPicker = toggleMediaPicker

        let initFields = [
            MediaPickerTextFields.title.rawValue: title.wrappedValue,
            MediaPickerTextFields.caption.rawValue: caption.wrappedValue
        ]
        let debounceViewModel = DebounceViewModel(initialFields: initFields)
        self._viewModel = StateObject(wrappedValue: debounceViewModel)
    }

    var body: some View {
        Button(action: {
            self.toggleMediaPicker()
            print("Button disabled \(viewModel.isButtonDisabled)")
        }) {
            /*Image(systemName: "photo.on.rectangle") */                // Replace with your icon name or system image
            Image(systemName: "arrow.up.circle")                                  // Make the image resizable
                .resizable()
                .padding()
                .background(
                    viewModel.isButtonDisabled ?
                    Color.gray:
                    Color.black
                )
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .frame(width: width / 4.5, height: height/10)
                .opacity(
                    viewModel.isButtonDisabled ?
                        0.9:
                        1
                )
        }
        .position(CGPoint(x: width - (width * 0.55), y: height - (height * 0.95)))
        .animation(.bouncy, value: title)
        .animation(.bouncy, value: caption)
        .disabled(viewModel.isButtonDisabled)
        .onChange(of: title) { _, newValue in
            viewModel.updateField(MediaPickerTextFields.title.rawValue, value: newValue)
        }
        .onChange(of: caption) { _, newValue in
            viewModel.updateField(MediaPickerTextFields.caption.rawValue, value: newValue)
        }

    }
}

//#Preview {
//    MediaPickerButton(
//        showMediaPicker: true,
//        width: UIScreen.main.bounds.width,
//        height: UIScreen.main.bounds.height,
//        title: "title",
//        caption: "caption",
//        toggleMediaPicker: {}
//    )
//}
