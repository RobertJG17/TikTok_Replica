//
//  FeedCell.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct FeedCell: View {
    let post: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.pink)
                .containerRelativeFrame([.horizontal, .vertical])
                .overlay {
                    Text("Post \(post)")
                        .foregroundStyle(.white)
                }
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("carlos.sainz")
                            .fontWeight(.semibold)
                        
                        // MARK: Post caption
                        Text("Rocket ship, prepare for takeoff!!")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 28) {
                        
                        // MARK: User profile icon
                        Circle()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(.gray)
                        
                        // MARK: Action button group (could break out into separate view)
                        Button {
                            
                        } label: {
                            VStack {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(.white)
                                Text("27")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                            
                        }
                        
                        Button {
                            
                        } label: {
                            VStack {
                                Image(systemName: "ellipsis.bubble.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(.white)
                                Text("27")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "bookmark.fill")
                                .resizable()
                                .frame(width: 22, height: 28)
                                .foregroundStyle(.white)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.bottom, 80)
            }
            .padding()
        }
    }
}

#Preview {
    FeedCell(post: 2)
}
