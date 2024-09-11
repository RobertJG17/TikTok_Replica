//
//  UploadView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


enum MediaType {
    case photo
    case video
}

enum SelectedMedia: Equatable {
    case image(UIImage)
    case video(URL)
}


// should I even support different media types for uploads?
// might be easier if I only have to worry about a user adding a normal media post

struct UploadView: View {
    private let userService: UserService
    private let height = UIScreen.main.bounds.height
    private let width = UIScreen.main.bounds.width
    
    private var placeholder: String = "Enter http:// here..."
    private var mediaId: String = UUID().uuidString
        
    @State private var title: String = ""
    @State private var formattedTitle: String? = nil
    @State private var caption: String = ""
    @State private var selectedMedia: SelectedMedia? = nil
    @State private var mediaType: MediaType = .photo
    @State private var showMediaPicker: Bool = false
    @State private var urlString: String = ""
    
    @State private var isLoading: Bool = false
    
    private func formatTitle(title: String) -> String {
        return title.replacingOccurrences(of: " ", with: "_")
    }

    private var uploadButtonDisabled: Bool {
        return title.isEmpty || caption.isEmpty || selectedMedia == nil
    }
    
    private func toggleMediaPicker() {
        showMediaPicker.toggle()
    }
    
    private func emptySelectedMedia() {
        selectedMedia = nil
    }

    private func uploadMedia() {
        let post: Post = Post(
            userId: Auth.auth().currentUser!.uid,
            id: mediaId,
            title: title,
            caption: caption,
            mediaUrl: nil,
            likes: 0,
            taggedUserIds: [],
            likedUserIds: []
        )
       
        Task {
            do {
                isLoading.toggle()
                try await userService.publishInformation(
                    collection: FirestoreData.posts,
                    data: post
                )
                isLoading.toggle()
            } catch {
                print(error)
            }
        }
    }
        
    // MARK: Need user service here to make publish call, need to pass down existing user service to have reference to logged in user
    init(userService: UserService) {
        self.userService = userService
    }

    var body: some View {
        VStack {
            UploadTextField(
                publishedValue: $title,
                animationTriggerValue: $caption,
                label: "title",
                bottomPadding: 20
            )
            
            UploadTextField(
                publishedValue: $caption,
                animationTriggerValue: $title,
                label: "caption",
                bottomPadding: 100
            )
            
            MediaPickerButton(
                showMediaPicker: showMediaPicker,
                width: width, 
                height: height,
                title: title,
                caption: caption, 
                toggleMediaPicker: toggleMediaPicker
            )
            
            MediaPreview(
                title: title,
                caption: caption,
                selectedMedia: selectedMedia
            )
            
            HStack {
                ApplicationButton(
                    action: uploadMedia,
                    text: "Upload",
                    background: uploadButtonDisabled ? Color.gray : Color.black,
                    color: .white,
                    radius: 8,
                    message: "Upload Media button clicked!!"
                )
                    .disabled(uploadButtonDisabled)
                    .opacity(uploadButtonDisabled ? 0.7 : 1)
                
                
                ApplicationButton(
                    action: emptySelectedMedia,
                    systemImage: "trash",
                    background: Color.red,
                    color: .white,
                    radius: 8,
                    message: "Media Deleted!!"
                )
            }
            .frame(maxWidth: .infinity, maxHeight: height - height * 0.25)
            .animation(.bouncy, value: selectedMedia)

        }
        .sheet(isPresented: $showMediaPicker) {                                 // bool toggled when tapping MediaPicker Button
            MediaPicker(
                selectedMedia: $selectedMedia,
                mediaType: $mediaType,
                mediaId: mediaId,
                title: formattedTitle!
            )
        }
        .padding()
        .overlay {
            // Conditional Spinner
            if isLoading {
                ProgressView("Uploading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
    }
}

#Preview {
    UploadView(userService: UserService())
}
