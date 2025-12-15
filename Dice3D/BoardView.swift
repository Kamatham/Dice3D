//
//  BoardView.swift
//  Dice3D
//
//  Created by Raju on 05/12/25.
//

import SwiftUI
import ImageIO

struct BoardView: View {
    @Environment(\.dismiss) var dismiss
    private let columnsCount = 5
    private let rowsCount = 10
    
    @State private var diceValue: Int = 1
    @State private var diceRolling: Bool = false
    @State private var isMovingToken: Bool = false
    @State private var showAnimation: Bool = false
    
    
    @State private var positionP1: Int = 0
    @State private var positionP2: Int = 0
    @State private var diceValueP1: Int = 1
    @State private var diceValueP2: Int = 1
    
    //@State private var gameMode: Int = 2
    let gameMode: Int
    let player1Name: String
    let player2Name: String
    let p1ImageName: String
    let p2ImageName: String
    let isDarkMode: Bool
    
    // 1 = Single Player, 2 = Two Players
    @State private var currentPlayer: Int = 1
    // 1 = P1, 2 = P2
    
    
    var isReversedAnimationP1: Bool {
        if positionP1 < 6 ||
            (positionP1 >= 10 && positionP1 < 16) ||
            (positionP1 >= 21 && positionP1 < 26) ||
            (positionP1 >= 31 && positionP1 < 36) ||
            (positionP1 >= 41 && positionP1 < 46)
        {
            return false // forward walk
        } else {
            return true // reverse walk
        }
    }
    
    var isReversedAnimationP2: Bool {
        if positionP2 < 6 ||
            (positionP2 >= 10 && positionP2 < 16) ||
            (positionP2 >= 21 && positionP2 < 26) ||
            (positionP2 >= 31 && positionP2 < 36) ||
            (positionP2 >= 41 && positionP2 < 46)
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
        VStack {
            HStack {
                Button("Back") {
                    dismiss()
                }.padding(.leading, 20)
                Spacer()
            }.padding(.top, 40)
            
            mainView
        }.background(isDarkMode ? Color.black : Color.white)
    }
    
    var mainView: some View {
        ZStack {
            if positionP1 == 50 || positionP2 == 50 {
                VStack {
                    GIFImage(name: "celebrate1")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    if positionP1 == 50 {
                        Text("\(player1Name) won the board!!")
                            .font(.largeTitle)
                    } else {
                        Text("\(player2Name) won the board!!")
                            .font(.largeTitle)
                    }
                    
                    Button("Start New Game", action: {
                        positionP1 = 0
                        positionP2 = 0
                    })
                    
                    Spacer()
                    
                }
            } else {
                contentView
                    .padding()
                
                
                Group {
                    snake47_39
                    snake45_21
                    snake32_24
                    snake19_10
                    snake16_2
                }.offset(y: -6)
                    .zIndex(-1)
                
                Group {
                    ladder40_48
                    ladder33_43
                    ladder20_36
                    ladder17_31
                    ladder3_15
                }.offset(y: -6)
                    .zIndex(-1)
                
                
                // .opacity(0.37)
                
            }
            
            
            
        }
    }
    
    
    var contentView: some View {
        VStack(spacing: 20) {
            //  Spacer()
            // Grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(boardNumbers, id: \.self) { number in
                    if currentPlayer == 1 {
                        self.cellView(number: number,
                                      isCurrent: number == positionP1,
                                      isRolling: self.diceRolling)
                    } else {
                        self.cellView(number: number,
                                      isCurrent: number == positionP2,
                                      isRolling: self.diceRolling)
                    }
                    
                }
            }
            
            HStack {
                playerView(name: player1Name, isTurn: currentPlayer == 1, image: getStandingNameP1)
                Spacer()
                if gameMode == 2 {
                    playerView(name: player2Name, isTurn: currentPlayer == 2, image: getStandingNameP2)
                }
            }//.border(.red, width: 1.0)
            
            
            HStack {
                if gameMode == 2 { // chaitra
                    diceView1
                        .allowsHitTesting(currentPlayer == 1)
                        .opacity(currentPlayer == 1 ? 1 : 0.2)
                    Spacer()
                    diceView2
                        .allowsHitTesting(currentPlayer == 2)
                        .opacity(currentPlayer == 2 ? 1 : 0.2)
                } else {
                    diceView1
                    Spacer()
                }
                
            }.background(.brown.opacity(0.5))
                .cornerRadius(8)
            Spacer()
        }
    }
    // MARK: - Dice View & Movement
    
    func playerView(name: String, isTurn: Bool, image: String) -> some View {
        HStack {
            Text(name)
                .foregroundColor(isDarkMode ? .white : .black)
                .font(.headline)
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }.padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isTurn ? .green : .gray)
            )
    }
    
    var diceView1: some View {
        ZStack {
            if currentPlayer == 1 && diceRolling {
                GIFImage(name: "dice3d")
                    .frame(width: 84, height: 84)
                    .scaleEffect(x: -1, y: 1)
            } else {
                
                if positionP1 == 0 {

                    Button(action: {
                        rollDice()
                    }) {
                        Text("START")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(.vertical, 10)
                            .background(Color.clear)
                            .frame(width: 90)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 0.6)
                            ).padding(.leading, 30)
                    }
                    .padding(.leading)
                    
                }
                else {
                    Image("dice\(diceValueP1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 58, height: 58)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .shadow(radius: 2)
                        .onTapGesture {
                            rollDice()
                        }
                }
            }
        }
        .frame(width: 68, height: 68)
    }
    
    var diceView2: some View {
        ZStack {
            if currentPlayer == 2 && diceRolling {
                GIFImage(name: "dice3d")
                    .frame(width: 84, height: 84)
                    .scaleEffect(x: -1, y: 1)
            } else {
                
                if positionP2 == 0 {
                    Button(action: {
                        rollDice()
                    }) {
                        Text("START")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(isDarkMode ? .white : .black)
                            .padding(.vertical, 10)
                            .background(Color.clear)
                            .frame(width: 90)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 0.6)
                            ).padding(.trailing, 30)
                    }
                    .padding(.trailing)
                }
                else {
                    Image("dice\(diceValueP2)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 58, height: 58)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .shadow(radius: 2)
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
                        .fill(number%2 == 0 ? .cyan.opacity(0.2) :  .yellow.opacity(0.2))
                    
                )
            
            Text("\(number)")
                .font(.caption)
                .fontWeight(isCurrent ? .bold : .regular)
                .foregroundColor(isDarkMode ? .white : .black)
  
            // P1 token
            if positionP1 == number {
                if showAnimation && isCurrent && currentPlayer == 1 {
                    GIFImage(name: self.getAvatarName)
                        .frame(width: 52, height: 52)
                        .scaleEffect(x: isReversedAnimationP1 ? -1 : 1, y: 1)
                        .zIndex(1)
                }
                else {
                    VStack {
                        if let first = UIImage.firstFrame(fromGIF: self.getStandingNameP1) {
                            Image(uiImage: first)
                                .resizable()
                                .scaledToFit()
                                .frame(width: getSize(isCurrent), height: getSize(isCurrent))
                                .scaleEffect(x: isReversedAnimationP1 ? -1 : 1, y: 1)
                                .zIndex(1)
                        }
                    }
                }
            }
            
            // P2 token should show ONLY in two-player mode
            if gameMode == 2 && positionP2 == number  {
                if showAnimation && isCurrent && currentPlayer == 2 {
                    GIFImage(name: self.getAvatarName)
                        .frame(width: 52, height: 52)
                        .scaleEffect(x: isReversedAnimationP2 ? -1 : 1, y: 1)
                        .zIndex(1)
                } else {
                    VStack {
                        if let first = UIImage.firstFrame(fromGIF: self.getStandingNameP2) {
                            Image(uiImage: first)
                                .resizable()
                                .scaledToFit()
                                .frame(width: getSize(isCurrent), height: getSize(isCurrent))
                                .scaleEffect(x: isReversedAnimationP2 ? -1 : 1, y: 1)
                                .zIndex(1)
                        }
                    }
                }
            }
        }.frame(height: 52)
    }
    
    func getSize(_ isCurrent: Bool) -> CGFloat {
        return isCurrent ?  52.0 :  36.0
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
    BoardView(gameMode: 2, player1Name: "qqq", player2Name: "ccc", p1ImageName: "avatar2", p2ImageName: "avatar6", isDarkMode: false)
}

extension BoardView {
    
    
    private func rollDice() {
        // don’t allow rolling while already rolling or moving
        guard !diceRolling, !isMovingToken else { return }
        
        diceValue = Int.random(in: 1...6)
        if currentPlayer == 1 {
            diceValueP1 = diceValue
        } else {
            diceValueP2 = diceValue
        }
        diceRolling = true
        showAnimation = true
        // play GIF for a bit, then start moving token
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            diceRolling = false
            startMovingToken()
        }
    }
    
    private func startMovingToken() {
        let pos = currentPlayer == 1 ? positionP1 : positionP2
        
        guard pos + diceValue <= 50 else {
            endTurn()
            return
        }
        
        let target = min(50, pos + diceValue)
        let steps = target - pos
        
        isMovingToken = true
      //  SoundManager.shared.playLadderSound(fileName: "run_sound")
        
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
            if currentPlayer == 1 {
                positionP1 += 1
            } else {
                positionP2 += 1
            }
        }
        
        // schedule next step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            moveStep(remainingSteps: remainingSteps - 1)
        }
    }
    
    /// Called when the player has finished moving for this roll
    private func handleSnakeOrLadder() {
        
        let pos = currentPlayer == 1 ? positionP1 : positionP2
        
        guard let path = getMovingCells[pos] else {
            endTurn()
            return
        }
        
        SoundManager.shared.stopPlay()
        
        if path.count > 1 {
            // Ladder or snake sound
            if path.last! > pos {
                SoundManager.shared.playLadderSound(fileName: "run_sound")
            } else {
                SoundManager.shared.playLadderSound(fileName: "snake_sound")
            }
            
            isMovingToken = true
            moveAlongPath(path, index: 1)
        } else {
            endTurn()
        }
    }
    
    /// Move step-by-step along a predefined path (used for snake / ladder)
    private func moveAlongPath(_ path: [Int], index: Int) {
        guard index < path.count else {
            isMovingToken = false
            showAnimation = false
            SoundManager.shared.stopPlay()
            endTurn()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            if currentPlayer == 1 {
                positionP1 = path[index]
            } else {
                positionP2 = path[index]
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            moveAlongPath(path, index: index + 1)
        }
    }
    
    private func endTurn() {
        // check for win
        if positionP1 == 50 || positionP2 == 50 {
            return
        }
        
        
        // SINGLE PLAYER → Do NOT switch player
        if gameMode == 1 {
            currentPlayer = 1
            return
        }
        
        // TWO PLAYER → normal switching
        currentPlayer = (currentPlayer == 1) ? 2 : 1
    }
    
    var snake47_39: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 170)
                .rotationEffect(Angle(degrees: 16.0))
                .offset(x: 0, y: -299)
        }
    }
    var snake45_21: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 328)
                .rotationEffect(Angle(degrees: 11.0))
                .offset(x: 18, y: -180)
        }
    }
    
    var snake32_24: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 160)
                .rotationEffect(Angle(degrees: -92.0))
                .offset(x: 0, y: -138)
        }
    }
    
    var snake19_10: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 120)
            // .rotationEffect(Angle(degrees: 0))
                .offset(x: -109, y: 42)
        }
    }
    
    
    var snake16_2: some View {
        Group {
            Image("snake")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 240)
                .rotationEffect(Angle(degrees: 14.5))
                .offset(x: 40, y: 70)
        }
    }
    
    
    var ladder33_43: some View {
        Group {
            Image("ladder2").resizable()
                .frame(width: 280, height: 114)
                .scaledToFill()
                .offset(x: -5, y: -240)
        }
    }
    
    var ladder17_31: some View {
        Group {
            Image("ladder2").resizable()
                .frame(width: 200, height: 276)
                .scaledToFill()
                .rotationEffect(Angle(degrees: -56.0))
                .offset(x: -40, y: -90)
            //
        }
    }
    
    var ladder40_48: some View {
        Group {
            Image("ladder3").resizable()
                .frame(width: 160, height: 180)
                .scaledToFill()
                .rotationEffect(Angle(degrees: 31.5))
                .offset(x: -79, y: -290)
        }
    }
    
    var ladder20_36: some View {
        Group {
            Image("ladder2").resizable()
                .frame(width: 160, height: 370)
                .scaledToFill()
                .rotationEffect(Angle(degrees: 52.5))
                .offset(x: -0, y: -135)
            
        }
    }
    
    var ladder3_15: some View {
        Group {
            Image("ladder3")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 160)
                .rotationEffect(Angle(degrees: 28.5))
                .offset(x: 76, y: 110)
        }
    }
    
    
    var getAvatarName: String {
        if currentPlayer == 1 {
            return self.p1ImageName
        } else {
            return self.p2ImageName
        }
    }
    
    var getStandingNameP1: String {
        return self.p1ImageName
    }
    var getStandingNameP2: String {
        return self.p2ImageName
    }
}

extension UIImage {
    static func firstFrame(fromGIF named: String) -> UIImage? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "gif"),
              let data = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
