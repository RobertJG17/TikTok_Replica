//
//  UploadView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/9/24.
//

import SwiftUI


enum MediaType {
    case photo
    case video
}

enum SelectedMedia {
    case image(UIImage)
    case video(URL)
}


struct UploadView: View {
    @State private var title: String = ""
    @State private var caption: String = ""
    @State private var selectedMedia: SelectedMedia? = nil
    @State private var mediaType: MediaType = .photo
    @State private var showMediaPicker: Bool = false
    @State private var showUploadTag: String = "picker_upload_tag"
    @State private var urlString: String = "Enter http:// here..."
    
    private let height = UIScreen.main.bounds.height
    private let width = UIScreen.main.bounds.width
    
    private let userService: UserService
    
    // need user service here to make publish call,
    // need to pass down existing user service
    // to have reference to logged in user
    init(userService: UserService) {
        self.userService = userService
    }

    var body: some View {
        VStack {
            VStack {
                Text("Title")
                    .font(.headline)

                // Title TextField
                TextField("Enter title", text: $title)
            }
            .padding(.bottom, 20)
            
            VStack {
                Text("Caption")
                    .font(.headline)

                // Title TextField
                TextField("Enter caption", text: $caption)
            }
            .padding(.bottom, 100)
               

            // Show the selected image or video thumbnail
            if let media = selectedMedia {
                switch(media) {
                case .image(let uiImage):
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                case .video(let url):
                    Text("Video URL: \(url.absoluteString)")
                        .padding()
                default:
                    Text(".image | .video case not hit")
                }
            } else {
                Text("No media selected")
                    .padding()
            }

            // Upload Type Picker
            Picker("Select UploadType Type", selection: $showUploadTag) {
                Text("Upload").tag("picker_upload_tag")
                Text("URL").tag("picker_url_tag")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            if (showUploadTag == "picker_url_tag") {
                TextField("", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        if (urlString.isEmpty) {
                            urlString = "Enter http:// here..."
                        }
                    }
                    .onChange(of: urlString) { oldValue, newValue in
                        if (oldValue.isEmpty && newValue.isEmpty) {
                            urlString = "Enter http:// here..."
                        }
                    }
                    .onTapGesture {
                        if (urlString ==  "Enter http:// here...") {
                            urlString = ""
                        }
                    }
                    .opacity(urlString == "Enter http:// here..." ? 0.4 : 1)
            } else {
                // Button to open the ImagePicker
                Button(action: {
                    showMediaPicker = true
                }) {
                    Image(systemName: "photo.on.rectangle") // Replace with your icon name or system image
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(maxWidth: width / 3, maxHeight: height / 3) // Adjust frame size
                }
            }
            
            // Button to upload
            Button(action: {
                // Handle the upload logic here
                uploadMedia()
            }) {
                Text("Upload")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty || caption.isEmpty || selectedMedia == nil)
            .frame(maxWidth: .infinity, maxHeight: height - height * 0.25)
            
        }
        .sheet(isPresented: $showMediaPicker) {
            MediaPicker(selectedMedia: $selectedMedia, mediaType: $mediaType)
        }
        .padding()
    }
    
    private func setTag(tag: String) {
        self.showUploadTag = tag
    }

    private func uploadMedia() {
        // Your upload logic here
        guard selectedMedia != nil else { return }
        
        // title
        // caption
        // selected
        
        // Example upload code
        print("Uploading image with title: \(title) and caption: \(caption)")
    }
}

#Preview {
    UploadView(userService: UserService())
}
