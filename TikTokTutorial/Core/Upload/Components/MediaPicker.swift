//
//  ImagePicker.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/9/24.
//

import SwiftUI
import UIKit


struct MediaPicker: UIViewControllerRepresentable {
    @Binding var selectedMedia: SelectedMedia?
    @Binding var mediaType: MediaType

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = mediaType == .photo ? ["public.image"] : ["public.movie"]
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: MediaPicker

        init(_ parent: MediaPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
               self.parent.selectedMedia = .image(image)
           } else if let videoURL = info[.mediaURL] as? URL {
               self.parent.selectedMedia = .video(videoURL)
           }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

