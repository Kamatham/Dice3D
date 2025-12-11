//
//  BoardView.swift
//  Dice3D
//
//  Created by Raju on 05/12/25.
//

import SwiftUI

struct BoardView: View {
    private let columnsCount = 5
    private let rowsCount = 10
    
    @State private var currentPosition: Int = 0
    @State private var diceValue: Int = 1
    @State private var diceRolling: Bool = false
    @State private var isMovingToken: Bool = false
    @State private var showAnimation: Bool = false
    
    var isReversedAnimation: Bool {
        if currentPosition < 6 ||
            (currentPosition >= 10 && currentPosition < 16) ||
            (currentPosition >= 21 && currentPosition < 26) ||
            (currentPosition >= 31 && currentPosition < 36) ||
            (currentPosition >= 41 && currentPosition < 46)
        {
            return false // forward walk
        } else {
            return true // reverse walk
        }
    }
    
    /// Numbers laid out like a snakes & ladders board
    var boardNumbers: [Int] {
        var result: [Int] = []
        for row in (0..<rowsCount).reversed() {          // draw from top row to bottom
            let start = row * columnsCount + 1           // first number in this row
            let rowNumbers = Array(start..<(start + columnsCount))
            if row % 2 == 0 {
                result.append(contentsOf: rowNumbers)        // left → right
            } else {
                result.append(contentsOf: rowNumbers.reversed()) // right → left
            }
        }
        return result
    }

    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: columnsCount)
    }
    

   
        
    var body: some View {
        mainView
    }
    
    var mainView: some View {
        ZStack {
            if currentPosition == 50 {
                VStack {
                    GIFImage(name: "celebrate1")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Text("You won buddy!!")
                        .font(.largeTitle)
                    
                    Button("Start New Game", action: {
                        currentPosition = 0
                    })
                    
                    Spacer()
                    
                }
            } else {
                contentView
                    .padding()
                
                Group {
                    ladder40_48
                    ladder33_43
                    ladder20_36
                    ladder17_31
                    ladder3_15
                }.zIndex(-1)
                
                
                Group {
                    snake47_39
                    snake45_21
                    snake32_24
                    snake19_10
                    snake16_2
                }.zIndex(-1)
               // .opacity(0.37)
                    
            }
            
            
            
        }
    }
    
   
    var contentView: some View {
        VStack(spacing: 20) {
            Spacer()
            // Grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(boardNumbers, id: \.self) { number in
                    
                    self.cellView(number: number,
                                  isCurrent: number == currentPosition,
                                  isRolling: self.diceRolling)
                }
            }
            // animate highlight change when currentPosition changes
            .animation(.easeInOut(duration: 0.6), value: currentPosition)
            
            Spacer()
            
            Divider().background(.black)
            
            HStack {
                diceView
                Spacer()
                if self.currentPosition == 0 {
                    Image("standing")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                } else {
                   // Spacer()
                    Button("RESET", action: {
                        self.diceValue = 1
                        self.currentPosition = 0
                    })
                }
            }
        }
    }
    // MARK: - Dice View & Movement
    
    var diceView: some View {
        ZStack {
            if currentPosition == 0 {
                if diceRolling {
                    GIFImage(name: "dice3d")
                        .frame(width: 84, height: 84)
                        .scaleEffect(x: -1, y: 1)
                } else {
                    Button("START", action: {
                        rollDice()
                    })
                }
            } else {
                if diceRolling {
                    GIFImage(name: "dice3d")
                        .frame(width: 84, height: 84)
                } else {
                    Image("dice\(diceValue)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 58, height: 58)
                        .opacity(diceRolling ? 0 : 1.0)
                        .cornerRadius(8)
                        .onTapGesture {
                            rollDice()
                        }
                }
            }
        }
        .frame(width: 68, height: 68)
    }
    
    
    func cellView(number: Int, isCurrent: Bool, isRolling: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                )
            
            Text("\(number)")
                .font(.caption)
                .fontWeight(isCurrent ? .bold : .regular)
                .foregroundColor(isCurrent ? .yellow : .primary)
            
            if showAnimation {
                GIFImage(name: "walking")
                    .frame(width: 48, height: 48)
                    .opacity(isCurrent ? 1.0 : 0)
                    .scaleEffect(x: isReversedAnimation ? -1 : 1, y: 1) // chaitu
                    .zIndex(1)
            } else {
                Image("standing")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .opacity(isCurrent ? 1.0 : 0)
                    .scaleEffect(x: isReversedAnimation ? -1 : 1, y: 1) // chaitu
                    .zIndex(1)
            }

            
        }.frame(height: 52)
    }

    /// snakes & ladders: head → tail, bottom → top
    let getMovingCells: [Int : [Int]] = [ // trilok
        3:[3,7,15],
        17:[17,23,29,31],
        20: [20,22,28,34, 36],
        33: [33,38,43],
        40:[40,42,48],
        
        16: [16,14,8,2],
        19: [19, 10],
        32:[32,28,24],
        45:[45,37,33, 29,21],
        47: [47,43,39]
    ]
}



#Preview {
    BoardView()
}

extension BoardView {
    
    
    private func rollDice() {
        // don’t allow rolling while already rolling or moving
        guard !diceRolling, !isMovingToken else { return }
        
        diceValue = Int.random(in: 1...6)
        diceRolling = true
        showAnimation = true
        // play GIF for a bit, then start moving token
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            diceRolling = false
            startMovingToken()
        }
    }
    
    private func startMovingToken() {
        guard currentPosition + diceValue <= 50 else {
            return
        }
        let target = min(50, currentPosition + diceValue)
        let steps = target - currentPosition
        guard steps > 0 else { return }
        
        isMovingToken = true
        SoundManager.shared.playLadderSound(fileName: "run_sound")
        moveStep(remainingSteps: steps)
    }
    
    private func moveStep(remainingSteps: Int) {
        guard remainingSteps > 0 else {
            isMovingToken = false
            showAnimation = false
            SoundManager.shared.stopPlay()
            handleSnakeOrLadder()
            return
        }
        
        // move one cell forward with animation
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPosition += 1
        }
        
        // schedule next step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            moveStep(remainingSteps: remainingSteps - 1)
        }
    }
    
    /// Called when the player has finished moving for this roll
    private func handleSnakeOrLadder() {
        
        guard let destinationPath = getMovingCells[currentPosition] else {
            print("NOT handleSnakeOrLadder --->>>")
            return
        }
        SoundManager.shared.stopPlay()
        print("handleSnakeOrLadder --->>>  \(destinationPath)")
        
        guard destinationPath.count > 1 else {
            currentPosition = destinationPath.last ?? 0
            return
        }
        
        // 🔊 Play ladder sound
        if destinationPath.last! > currentPosition {
            SoundManager.shared.playLadderSound(fileName: "ladder_sound")
        }
        
        // 🔊 Play Snake sound
        if destinationPath.last! < currentPosition {
            SoundManager.shared.playLadderSound(fileName: "snake_sound")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            isMovingToken = true
            moveAlongPath(destinationPath, index: 1)
            // index 0 is the current square
        })
        
    }
    
    /// Move step-by-step along a predefined path (used for snake / ladder)
    private func moveAlongPath(_ path: [Int], index: Int) {
        guard index < path.count else {
            isMovingToken = false
            showAnimation = false
            SoundManager.shared.stopPlay()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPosition = path[index]
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            moveAlongPath(path, index: index + 1)
        }
    }

    var snake47_39: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 170)
                .rotationEffect(Angle(degrees: 16.0))
                .offset(x: 0, y: -249)
        }
    }
    var snake45_21: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 334)
                .rotationEffect(Angle(degrees: 16.0))
                .offset(x: 20, y: -136)
        }
    }
    
    var snake32_24: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 160)
                .rotationEffect(Angle(degrees: -92.0))
                .offset(x: 0, y: -88)
        }
    }
    
    var snake19_10: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 150)
            // .rotationEffect(Angle(degrees: 0))
                .offset(x: -104, y: 84)
        }
    }
    
    
    var snake16_2: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 240)
                .rotationEffect(Angle(degrees: 14.5))
                .offset(x: 54, y: 114)
        }
    }
    
    
    var ladder33_43: some View {
        Group {
            Image("ladder2").resizable()
                .frame(width: 280, height: 114)
                .scaledToFill()
                .offset(x: -5, y: -190)
        }
    }
    
    var ladder17_31: some View {
        Group {
            Image("ladder2").resizable()
                .frame(width: 200, height: 276)
                .scaledToFill()
                .rotationEffect(Angle(degrees: -54.0))
                .offset(x: -38, y: -50)
            //
        }
    }
    
    var ladder40_48: some View {
        Group {
            Image("ladder3").resizable()
                .frame(width: 160, height: 180)
                .scaledToFill()
                .rotationEffect(Angle(degrees: 31.5))
                .offset(x: -79, y: -240)
        }
    }
    
    var ladder20_36: some View {
        Group {
            Image("ladder2").resizable()
                .frame(width: 160, height: 370)
                .scaledToFill()
                .rotationEffect(Angle(degrees: 52.5))
                .offset(x: -0, y: -85)
            
        }
    }
    
    var ladder3_15: some View {
        Group {
            Image("ladder3")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 160)
                .rotationEffect(Angle(degrees: 28.5))
                .offset(x: 70, y: 152)
        }
    }
    

}
