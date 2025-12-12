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
    
    var avatarsList: [String] = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                Text("🎲 Snakes & Ladders")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                
                // Game Mode Picker
                Picker("Mode", selection: $gameMode) {
                    Text("Single Player").tag(1)
                    Text("Two Players").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Player 1 Input
                VStack(alignment: .leading, spacing: 10) {
                    Text("Player 1 Name")
                        .font(.headline)
                    
                    TextField("Enter Player 1 name", text: $player1Name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Choose Avatar")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(avatarsList, id: \.self) { avt in
                                GIFImage(name: avt)
                                    .frame(width: 40, height: 40)
                                    .padding(6)
                                    .background(p1ImageName == avt ? Color.green.opacity(0.7) : Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        p1ImageName = avt
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
                        
                        TextField("Enter Player 2 name", text: $player2Name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Choose Avatar")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(avatarsList, id: \.self) { avt in
                                    GIFImage(name: avt)
                                        .frame(width: 40, height: 40)
                                        .padding(6)
                                        .background(p2ImageName == avt ? Color.green.opacity(0.7) : Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            p2ImageName = avt
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
                        p2ImageName: p2ImageName
                    ).navigationBarBackButtonHidden(),
                    isActive: $startGame
                ) { EmptyView() }
                
                // Start Game Button
                Button(action: {
                    if !isDisabled {
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
