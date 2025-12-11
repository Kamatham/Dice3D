//
//  LaunchScreenView.swift
//  Dice3D
//
//  Created by Raju on 05/12/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.8
    @State private var rotation: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background color
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Animated dice GIF
                GIFImage(name: "dice3d")
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotation))
                
                // App title or logo text
                Text("Dice3D")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .scaleEffect(scale)
            }
        }
        .onAppear {
            // Start fade in and scale animations
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1.0
                scale = 1.0
            }
            
            // Subtle continuous rotation animation
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                rotation = 360.0
            }
        }
    }
}

