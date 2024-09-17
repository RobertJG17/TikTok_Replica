//
//  VideoCellView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/7/24.
//

import SwiftUI

struct PostGridCellView: View {
    @StateObject private var viewModel: ImageViewModel = ImageViewModel()
    @State private var gradientAnimation = GradientAnimation()
    @State private var isLoading: Bool = false
    @State private var image: UIImage?
    private var imageUrl: String?
   
    init(imageUrl: String?) {
        self.imageUrl = imageUrl
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let uiImage = image, !isLoading {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill() // Use .scaledToFit() if you want to maintain the aspect ratio
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped() // Ensures the image fits within the bounds of the frame
                } else if isLoading {
                    PulsingLoader()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(alignment: .center) {
                            LoadingBars()
                        }
                    
                } else {
                    Color.black // Placeholder color
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        .onAppear {
            if let imgUrl = self.imageUrl {
                viewModel.downloadImage(from: URL(string: imgUrl)!)
                self.isLoading = true
            }
        }
        .onReceive(viewModel.$image) { publishedImage in
            if let img = publishedImage {
                self.image = img
                self.isLoading = false
            }
        }

    }
}
