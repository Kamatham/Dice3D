//
//  WelcomeView.swift
//  Dice3D
//
//  Created by Raju on 11/12/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var gameMode: Int = 1   // 1 = Single Player, 2 = Two Players
    @State private var player1Name: String = ""
    @State private var player2Name: String = ""
    
    @State private var p1ImageName: String = "avatar1"
    @State private var p2ImageName: String = "avatar2"
    
    @State private var startGame: Bool = false
    @State private var isDarkMode: Bool = false
    @State private var isAutoPlayer: Bool = false
    
    var avatarsList: [String] = ["avatar1", "avatar2", /*"avatar3", "avatar4",*/ "avatar5", "avatar6", "avatar7"]
    
    var body: some View {
        NavigationView {
            mainView
                .background(isDarkMode ? .black : .white)
                .onAppear {
                    isAutoPlayer = false
                }
        }
    }
    
    var mainView: some View {
        VStack(spacing: 30) {
            
            Text("🎲 Snakes & Ladders")
                .font(.largeTitle.bold())
                .padding(.top, 40)
                .foregroundColor(isDarkMode ? .white : .black)
            
            // Game Mode Picker
            Picker("Mode", selection: $gameMode) {
                Text("Single Player")
                    .tag(1)
                
                Text("Two Players")
                    .tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(isDarkMode ? Color.white.opacity(0.25) : Color.black.opacity(0.45))
            .padding(.horizontal)
            
            HStack {
                Text("Dark Mode")
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                Spacer()
                
                Toggle("", isOn: $isDarkMode)
                    .labelsHidden()
            }
            .padding(.horizontal)
            
            // Player 1 Input
            VStack(alignment: .leading, spacing: 10) {
                Text("Player 1 Name")
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                
                
                TextField("Enter Player 1 name", text: $player1Name)
                    .padding(8)
                    .background(isDarkMode ? Color.black.opacity(0.6) : Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 0.5)
                    )
                    .foregroundColor(isDarkMode ? .white : .black)

                
                Text("Choose Avatar")
                    .foregroundColor(isDarkMode ? .white : .black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(avatarsList, id: \.self) { avt in
                            if let first = UIImage.firstFrame(fromGIF: avt) {
                                Image(uiImage: first)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: avt.plusSize, height: avt.plusSize)
                                    .padding(6)
                                    .background(p1ImageName == avt ? Color.green.opacity(0.7) : Color.gray.opacity(0.5))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        p1ImageName = avt
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Player 2 Input
            if gameMode == 2 {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Player 2 Name")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    TextField("Enter Player 1 name", text: $player2Name)
                        .padding(8)
                        .background(isDarkMode ? Color.black.opacity(0.6) : Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 0.5)
                        )
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    Text("Choose Avatar")
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(avatarsList, id: \.self) { avt in
                                if let first = UIImage.firstFrame(fromGIF: avt) {
                                    Image(uiImage: first)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: avt.plusSize, height: avt.plusSize)
                                        .padding(6)
                                        .background(p2ImageName == avt ? Color.green.opacity(0.7) : Color.gray.opacity(0.5))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            p2ImageName = avt
                                        }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .transition(.opacity)
            }
            
            Spacer()
            
            // NavigationLink
            NavigationLink(
                destination: BoardView(
                    gameMode: gameMode,
                    player1Name: player1Name.isEmpty ? "Player 1" : player1Name,
                    player2Name: player2Name.isEmpty ? "Player 2" : player2Name,
                    p1ImageName: p1ImageName,
                    p2ImageName: p2ImageName,
                    isDarkMode: isDarkMode,
                    autoPlayer: isAutoPlayer,
                ).navigationBarBackButtonHidden(),
                isActive: $startGame
            ) { EmptyView() }
            
            // Start Game Button
            Button(action: {
                if !isDisabled {
                    if player2Name.lowercased() == "raju" ||
                        player2Name.lowercased() == "trilok" { // Hack for FUN
                        self.isAutoPlayer = true
                    }
                    startGame = true
                }
            }) {
                Text("START GAME")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isDisabled ? Color.gray : Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    var isDisabled: Bool {
        if gameMode == 1 {
            return player1Name.isEmpty
        } else {
            return player1Name.isEmpty || player2Name.isEmpty
        }
    }
}

#Preview {
    WelcomeView()
}

extension String {
    var plusSize: CGFloat {
        if self == "avatar4" || self == "avatar5" {
            return 45.0
        } else {
            return 40.0
        }
    }
}
