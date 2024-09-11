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
        picker.mediaTypes = ["public.image", "public.movie"]
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
                saveImageToTemporaryDirectory(image: image, fileName: "temp_media.jpg")
           } else if let videoURL = info[.mediaURL] as? URL {
               self.parent.selectedMedia = .video(videoURL)
               saveVideoToTemporaryDirectory(videoURL: videoURL, fileName: "temp_media.mp4")

           }
            picker.dismiss(animated: true)
        }
        
        func saveImageToTemporaryDirectory(image: UIImage, fileName: String) {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Failed to convert UIImage to Data.")
                return
            }
    
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
    
            do {
                try imageData.write(to: fileURL)
                UserDefaults.standard.set(fileURL.absoluteString, forKey: "postMediaURL")
                print("Image saved successfully to \(fileURL)")
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    
        func saveVideoToTemporaryDirectory(videoURL: URL, fileName: String) {
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
    
            do {
                try FileManager.default.copyItem(at: videoURL, to: fileURL)
                UserDefaults.standard.set(fileURL.absoluteString, forKey: "postMediaURL")
                print("Video saved successfully to \(fileURL)")
            } catch {
                print("Failed to save video: \(error)")
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

