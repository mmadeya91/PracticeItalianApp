//
//  AudioManager.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject{
    
    var player: AVAudioPlayer?
    
    func startPlayer(track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "wav") else {
            print("Resource not found: \(track)")
            return
        }
        
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.play()
        }catch{
            print("Fail to initialize player", error)
        }
    }
    
    func playPlause() {
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }
        
        if player.isPlaying {
            player.pause()
        }else {
            player.play()
        }
    }
}
