//
//  Preview.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/10/24.
//

import SwiftUI


// need selectedMedia, title, caption
struct MediaPreview: View {
    public var title: String
    public var caption: String
    public var selectedMedia: SelectedMedia?
    
    var body: some View {
        if let media = selectedMedia {
            switch(media) {                                          // don't need switch since media is of type MediaType (2 possible cases that we cover)
            case .image(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            case .video(let url):
                Text("Video URL: \(url.absoluteString)")
                    .padding()
            }
        } else {
            Text("No media selected")
                .padding()
                .font(.system(size: 24, weight: .bold, design: .default)) // System font customization
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.black, Color.red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .animation(.bouncy, value: title)
                .animation(.bouncy, value: caption)
                .animation(.bouncy, value: selectedMedia)
        }

    }
}
