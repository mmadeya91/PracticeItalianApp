//
//  SoundManager.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/24/23.
//

import Foundation
import AVKit

class SoundManager{
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case correct
        case wrong
        case introMusic
    }
    
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}
