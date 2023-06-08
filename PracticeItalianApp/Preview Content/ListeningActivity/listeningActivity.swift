//
//  listeningActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import SwiftUI
import AVKit

struct listeningActivity: View {
    @EnvironmentObject var audioManager: AudioManager
    var listeningActivityVM:ListeningActivityViewModel
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    
    var body: some View {
        
        ZStack{
            
            if let player = audioManager.player {
                VStack{
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        .frame(width: 300, height: 200)
                        .background(Color.blue.opacity(0.75))
                        .cornerRadius(20)
                    
                    Slider(value: $value, in: 0...player.duration) { editing
                        in
                        
                        print("editing", editing)
                        isEditing = editing
                        
                        if !editing {
                            player.currentTime = value
                        }
                    }
                    .scaleEffect(1.5)
                    .frame(width: 200, height: 20)
                    .tint(.orange)
                    .padding(.top, 50)
                    
                    HStack{
                        Text(DateComponentsFormatter.positional
                            .string(from: player.currentTime) ?? "0:00")
                        
                        Spacer()
                        
                        Text(DateComponentsFormatter.positional
                            .string(from: player.duration - player.currentTime) ?? "0:00")
                        
                    }.padding([.leading, .trailing], 40)
                        .padding(.top, 15)
                    
                    HStack{
                        PlaybackControlButton(systemName: "repeat") {
                            
                        }
                        Spacer()
                        PlaybackControlButton(systemName: "gobackward.10") {
                            
                        }
                        Spacer()
                        PlaybackControlButton(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                            audioManager.playPlause()
                        }
                        Spacer()
                        PlaybackControlButton(systemName: "goforward.10") {
                            
                        }
                        Spacer()
                        PlaybackControlButton(systemName: "stop.fill") {
                            
                        }
                    }
                }.padding([.leading, .trailing], 40)
                    .padding(.top, 15)
            }
        }.onAppear{
            //audioManager.startPlayer(track: listeningActivityVM.audioAct.track)
            
        }.onReceive(timer) { _ in
            guard let player = audioManager.player, !isEditing else {return}
            value = player.currentTime
        }
        
    }
}



struct listeningActivity_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    static var previews: some View {
        listeningActivity(listeningActivityVM: listeningActivityVM)
            .environmentObject(AudioManager())
    }
}
