//
//  UploadView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/9/24.
//

import SwiftUI

struct UploadView: View {
    @State private var title: String = ""
    @State private var caption: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var mediaType: MediaType = .photo // or .video

    var body: some View {
        VStack {
            // Title TextField
            TextField("Enter title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Caption TextField
            TextField("Enter caption", text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Show the selected image or video thumbnail
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .padding()
            } else {
                Text("No media selected")
                    .padding()
            }

            // Button to open the ImagePicker
            Button(action: {
                showImagePicker = true
            }) {
                Text("Select Photo/Video")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Button to upload
            Button(action: {
                // Handle the upload logic here
                uploadMedia()
            }) {
                Text("Upload")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty || caption.isEmpty || selectedImage == nil)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, mediaType: $mediaType)
        }
        .padding()
    }

    private func uploadMedia() {
        // Your upload logic here
        guard let image = selectedImage else { return }
        // Example upload code
        print("Uploading image with title: \(title) and caption: \(caption)")
    }
}

