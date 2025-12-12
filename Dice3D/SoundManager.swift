//
//  SoundManager.swift
//  Dice3D
//
//  Created by Raju on 11/12/25.
//

import Foundation

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var player: AVAudioPlayer?
    
    func playLadderSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Sound file not found. ------>>>")
            return
        }
        print("Sound fileName ------>>> \(fileName)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    func stopPlay() {
        player?.stop()
        player = nil
    }
}
