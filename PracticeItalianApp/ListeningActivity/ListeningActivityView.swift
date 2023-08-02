//
//  ListeningActivityView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/8/23.
//

import SwiftUI

struct ListeningActivityView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    @StateObject var listeningActivityQuestionsVM: ListeningActivityQuestionsViewModel
    @State private var showPlayer = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image("pot")
                .resizable()
                .scaledToFill()
                .frame(width: 80)
                .padding(.top, 100)
                .padding(.bottom, 20)
            
            ZStack {
                
                Color("DarkNavy")
                
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
                    
                    Text("Audio and Transcriptions by" + "\nVirginia Billie")
                        .multilineTextAlignment(.center)
                        .padding(.leading, 30)
                }.foregroundColor(.white)
                    .padding(20)
               
            }.frame(height: UIScreen.main.bounds.height * 2 / 3)
        }.ignoresSafeArea()
            .fullScreenCover(isPresented: $showPlayer) {listeningActivity(listeningActivityVM: listeningActivityVM, listeningActivityQuestionsVM: listeningActivityQuestionsVM)}
    }
}

struct ListeningActivityView_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    static let listeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))
    static var previews: some View {
        ListeningActivityView(listeningActivityVM: listeningActivityVM, listeningActivityQuestionsVM: listeningActivityQuestionsVM)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
