//
//  listeningActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import SwiftUI
import AVKit

struct listeningActivity: View {
    @State private var value: Double = 0.0
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .frame(width: 300, height: 200)
                .background(Color.blue.opacity(0.75))
                .cornerRadius(20)
            
            Slider(value: $value, in: 0...60 )
                .scaleEffect(1.5)
                .frame(width: 200, height: 20)
                .tint(.orange)
                .padding(.top, 50)
            
            HStack{
                Text("0:00")
                
                Spacer()
                
                Text("1:00")
                
            }.padding([.leading, .trailing], 40)
                .padding(.top, 15)
            
            HStack{
                PlaybackControlButton(systemName: "repeat", action: {
                    
                })
                Spacer()
                PlaybackControlButton(systemName: "gobackward.10", action: {
                    
                })
                Spacer()
                PlaybackControlButton(systemName: "play.circle.fill", fontSize: 44, action: {
                    
                })
                Spacer()
                PlaybackControlButton(systemName: "goforward.10", action: {
                    
                })
                Spacer()
                PlaybackControlButton(systemName: "stop.fill", action: {
                    
                })
                
            }.padding([.leading, .trailing], 40)
                .padding(.top, 15)
            
        }
    }
}



struct listeningActivity_Previews: PreviewProvider {
    static var previews: some View {
        listeningActivity()
    }
}
