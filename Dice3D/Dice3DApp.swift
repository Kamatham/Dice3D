//
//  Dice3DApp.swift
//  Dice3D
//
//  Created by Raju on 05/12/25.
//

import SwiftUI

@main
struct Dice3DApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var showLaunchScreen = true

    var body: some View {
        ZStack {
            if showLaunchScreen {
                LaunchScreenView()
                    .transition(.opacity)
            } else {
                BoardView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Hide launch screen after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showLaunchScreen = false
                }
            }
        }
    }
}
