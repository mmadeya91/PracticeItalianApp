//
//  listeningActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import SwiftUI


struct listeningActivity: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    var listeningActivityVM:ListeningActivityViewModel
    var isPreview: Bool = false
    
    @StateObject var listeningActivityQuestionsVM: ListeningActivityQuestionsViewModel
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @State private var showDialogueQuestions: Bool = false
    @State private var questionNumber = 0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    
    
    var body: some View {
        GeometryReader{geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            ZStack{                
                
                VStack{
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size:36))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }.padding(.top, 45)
                    
                    VStack{
                        VStack{
                            VStack{
                                Text("Ricetta di Pasta Carbonara")
                                    .font(Font.custom("Papyrus", size: 17)).padding(.top, 5)
                                
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .frame(width:150, height: 60).background(.white).cornerRadius(10).padding(10)
                                
                                Image("pot")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.bottom, 20)
                                
                            }.frame(width: 190, height: 150)
                                .background(.teal)
                                .cornerRadius(20)
                            
                        }.frame(width: 205, height: 160)
                            .cornerRadius(5)
                            .background(.black)
                            .padding(.top, 15)
                        
                        
                        if let player = audioManager.player {
                            VStack(spacing: 4){
                                
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
                                .padding(.top, 30)
                                
                                HStack{
                                    Text(DateComponentsFormatter.positional
                                        .string(from: player.currentTime) ?? "0:00")
                                    
                                    Spacer()
                                    
                                    Text(DateComponentsFormatter.positional
                                        .string(from: player.duration - player.currentTime) ?? "0:00")
                                    
                                }.padding(5)
                            }
                            
                            HStack{
                                let color: Color = audioManager.isLooping ? .teal : .black
                                PlaybackControlButton(systemName: "repeat", color: color) {
                                    audioManager.toggleLoop()
                                }
                                Spacer()
                                PlaybackControlButton(systemName: "gobackward.10") {
                                    player.currentTime -= 10
                                }
                                Spacer()
                                PlaybackControlButton(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                                    audioManager.playPlause()
                                }
                                Spacer()
                                PlaybackControlButton(systemName: "goforward.10") {
                                    player.currentTime += 10
                                }
                                Spacer()
                                let slowColor: Color = audioManager.isSlowPlayback ? .teal : .black
                                
                                PlaybackControlButton(systemName: "tortoise.fill", color: slowColor) {
                                    if !audioManager.isSlowPlayback {
                                        player.rate = 0.5
                                        audioManager.togglePlayback()
                                    }else {
                                        player.rate = 1.0
                                        audioManager.togglePlayback()
                                    }
                                }
                                //                        PlaybackControlButton(systemName: "stop.fill") {
                                //                            audioManager.stop()
                                //                        }
                            }.padding([.leading, .trailing], 15)
                        }
                        
                    }.frame().background(.white).cornerRadius(10).shadow(radius: 10).padding(.top, 10)
                    VStack{
                        HStack{
                            Text("Questions")
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .padding(.leading, 10)
                            Spacer()
                            Text(String(questionNumber+1) + "/5")
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .padding(.trailing, 10)
                        }.frame(width: 350, height: 40)
                        
                        
                        VStack{
                            
                            
                            Text(listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].question)
                                .font(Font.custom("Arial Hebrew", size: 16))
                                .multilineTextAlignment(.center)
                                .bold()
                                .padding([.leading, .trailing], 5)
                                .frame(width: 350)
                                .padding([.top, .bottom], 15)
                                .background(.teal.opacity(0.5))
                                .border(width: 2, edges: [.bottom], color: .black)
                            
                            
                            
                            radioButtonsLAComprehension(correctAnswer: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].answer, choicesIn: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].choices, questionNumber: $questionNumber)
                            
                            
                            
                            
                        } .frame(width: 350)
                            .background(.white)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                    }
                    
                }.zIndex(1)
            }.ignoresSafeArea()
                .fullScreenCover(isPresented: $showDialogueQuestions) {
                    listeningActivityQuestions(ListeningActivityQuestionsVM: listeningActivityQuestionsVM)
                }
                .onAppear{
                    audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                    
                }.onReceive(timer) { _ in
                    guard let player = audioManager.player, !isEditing else {return}
                    value = player.currentTime
                }
        }
        
    }
}

struct radioButtonsLAComprehension: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    
    @State var correctChosen: Bool = false
    @Binding var questionNumber: Int
    
    var body: some View{
        VStack {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctLAComprehensionButton(choice: choicesIn[i], questionNumber: $questionNumber, correctChosen: $correctChosen).padding(.bottom, 3)
                } else {
                    incorrectLAComprehensionButton(choice: choicesIn[i], correctChosen: $correctChosen).padding(.bottom, 3)
                }
            }
        }
        
        
    }
}



struct listeningActivity_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    static let listeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))
    static var previews: some View {
        listeningActivity(listeningActivityVM: listeningActivityVM, isPreview: true, listeningActivityQuestionsVM: listeningActivityQuestionsVM)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
