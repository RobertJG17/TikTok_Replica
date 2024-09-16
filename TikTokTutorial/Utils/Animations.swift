//
//  Animations.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/15/24.
//


import SwiftUI

struct GradientAnimation {
    @State private var animationProgress: Double = 0
    
    let gradient = [Color.purple, Color.orange]
    let startPoint = UnitPoint(x: -0.15, y: -0.15)
    let endPoint = UnitPoint(x: 1, y: 1)
    
    var animation: Animation {
        Animation.linear(duration: 0.5)
            .repeatForever(autoreverses: true)
    }
    
    func start() {
        withAnimation(animation) {
            self.animationProgress = 1
        }
    }
    
    func stop() {
        // To stop the animation, you can reset the progress or make it stop gracefully
        // This example does not handle stopping the animation
    }
}

struct PulsingLoader: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(Color.purple)
            .frame(width: 50, height: 50)
            .scaleEffect(scale)
            .opacity(Double(2 - scale))
            .animation(
                Animation.easeInOut(duration: 1.25)
                    .repeatForever(autoreverses: true),
                value: scale
            )
            .onAppear {
                self.scale = 1.5
            }
    }
}

struct ShimmerView: View {
    @State private var offset: CGFloat = -1.0

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.white.opacity(0.3), Color.gray.opacity(0.3)]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.clear, .black]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .offset(x: offset)
        )
        .frame(width: 100, height: 100)
        .animation(
            Animation.linear(duration: 1.5)
                .repeatForever(autoreverses: false),
            value: offset
        )
        .onAppear {
            self.offset = 200
        }
    }
}

struct DotWave: View {
    @State private var offset = [0.0, 0.0, 0.0]

    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.purple)
                    .frame(width: 12, height: 12)
                    .offset(y: offset[i])
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: offset[i]
                    )
            }
        }
        .onAppear {
            self.offset = [-10, 0, 10]
        }
    }
}

struct LoadingBars: View {
    @State private var animationProgress: CGFloat = 0

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { i in
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: 10, height: 30)
                    .scaleEffect(CGSize(width: 1, height: animationProgress))
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: animationProgress
                    )
            }
        }
        .onAppear {
            self.animationProgress = 1.0
        }
    }
}

