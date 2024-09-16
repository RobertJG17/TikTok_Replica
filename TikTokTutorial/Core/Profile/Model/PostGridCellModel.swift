//
//  PostGridCellModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/14/24.
//

import Combine
import SwiftUI
import FirebaseStorage

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func downloadImage(from url: URL) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: url.absoluteString)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            if let imageData = data {
                print("image data: \(imageData)")
                self?.image = UIImage(data: imageData)
            }
        }
    }
}

