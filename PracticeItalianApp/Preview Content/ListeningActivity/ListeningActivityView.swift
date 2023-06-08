//
//  ListeningActivityView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/8/23.
//

import SwiftUI

struct ListeningActivityView: View {
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    @State private var showPlayer = false
    
    var body: some View {
        VStack(spacing: 0) {
            Image("pot")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height/3)
            
            ZStack {
                
                Color(red: 24/255, green: 23/255, blue: 22/255)
                
                VStack(alignment: .leading, spacing: 24){
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Conversation")
                        
                        Text(DateComponentsFormatter.abbreviated.string(from: listeningActivityVM.audioAct.duration) ??
                             listeningActivityVM.audioAct.duration.formatted() + "S")
                        
                    }
                    .opacity(0.7)
                    
                    Text(listeningActivityVM.audioAct.title)
                        .font(.title)
                    
                    Button(action: {
                        showPlayer = true
                    }
                           , label: {
                        Label("Play", systemImage: "play.fill")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(20)
                    })
                    
                    Text(listeningActivityVM.audioAct.description)
                    
                    Spacer()
                }.foregroundColor(.white)
                    .padding(20)
               
            }.frame(height: UIScreen.main.bounds.height * 2 / 3)
        }.ignoresSafeArea()
            .fullScreenCover(isPresented: $showPlayer) {listeningActivity(listeningActivityVM: listeningActivityVM)}
    }
}

struct ListeningActivityView_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    static var previews: some View {
        ListeningActivityView(listeningActivityVM: listeningActivityVM)
            .environmentObject(AudioManager())
    }
}
