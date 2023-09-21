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
    @Environment(\.dismiss) var dismiss
    var listeningActivityVM:ListeningActivityViewModel
    var isPreview: Bool = false
    
    @StateObject var listeningActivityQuestionsVM: ListeningActivityQuestionsViewModel
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @State private var showDialogueQuestions: Bool = false
    @State private var questionNumber = 0
    @State private var wrongChosen = false
    @State private var correctChosen = false
    @State private var animatingBear = false
    @State private var progress: CGFloat = 0.0
    @State var showUserCheck: Bool = false
    
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
                
                if showUserCheck {
                    userCheckNavigationPopUpListeningActivity(showUserCheck: $showUserCheck)
                        .transition(.slide)
                        .animation(.easeIn)
                        .padding(.leading, 5)
                        .padding(.top, 60)
                        .zIndex(2)
                }
                
                
                VStack{
    
                    VStack{
                        VStack{
                            NavBar()
                                .padding(.top, 60)
                                .padding(.bottom, 20)
                                .padding([.leading, .trailing], 15)
                            VStack{
        
                                Image("pot")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(60)
                                    .overlay( RoundedRectangle(cornerRadius: 60)
                                        .stroke(.black, lineWidth: 3))
                                    .shadow(radius: 10)
                                
                                Text("Ricetta di Pasta Carbonara")
                                    .font(Font.custom("Futura", size: 18))
                                    .frame(width: 130, height: 80)
                                    .multilineTextAlignment(.center)
                                
                            }
                            
                        }
                        
                        
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
                                .scaleEffect(1.25)
                                .frame(width: 220, height: 20)
                                .tint(.orange)
                                .padding(.top, 5)
                                
                                HStack{
                                    Text(DateComponentsFormatter.positional
                                        .string(from: player.currentTime) ?? "0:00")
                                    
                                    Spacer()
                                    
                                    Text(DateComponentsFormatter.positional
                                        .string(from: player.duration - player.currentTime) ?? "0:00")
                                    
                                }.padding(5)
                            }.padding([.leading, .trailing], 35)
                            
                            HStack{
                                let color: Color = audioManager.isLooping ? .teal : .black
                               
                                PlaybackControlButton(systemName: "repeat", color: color) {
                                    audioManager.toggleLoop()
                                }.padding(.leading, 20)
                                Spacer()
                                PlaybackControlButton(systemName: "gobackward.10") {
                                    player.currentTime -= 10
                                }
                                Spacer()
                                PlaybackControlButton(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                                    audioManager.playPlause()
                                }.padding([.top, .bottom], 3)
                                Spacer()
                                PlaybackControlButton(systemName: "goforward.10") {
                                    player.currentTime += 10
                                }
                                Spacer()
                                let slowColor: Color = audioManager.isSlowPlayback ? .teal : .black
                                
                                PlaybackControlButton(systemName: "tortoise.fill", color: slowColor){
                                    if !audioManager.isSlowPlayback {
                                        player.rate = 0.5
                                        audioManager.togglePlayback()
                                    }else {
                                        player.rate = 1.0
                                        audioManager.togglePlayback()
                                    }
                                  
                                }.padding(.trailing, 20)
                                
                            
                            }
                            .frame(width: 360).background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .padding([.leading, .trailing], 15)
                            .padding(.top, 10)
                            
    
                        }
                        
                    }.padding(.bottom, 10)
                    VStack{
    
                        VStack{
                            
                            
                            Text(listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].question)
                                .font(Font.custom("Arial Hebrew", size: 17))
                                .multilineTextAlignment(.center)
                                .bold()
                                .padding([.leading, .trailing], 5)
                                .frame(width: 350)
                                .padding([.top, .bottom], 15)
                                .background(.teal.opacity(0.5))
                                .border(width: 2.5, edges: [.bottom], color: .black)
                            
                            
                            if questionNumber != 4 {
                                radioButtonsLAComprehension(correctAnswer: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].answer, choicesIn: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].choices, questionNumber: $questionNumber, wrongChosen: $wrongChosen, correctChosen: $correctChosen, showDialogueQuestions: $showDialogueQuestions)
                            }
                            
                            
                            
                            
                        } .frame(width: 350)
                            .background(Color("WashedWhite"))
                            .cornerRadius(5)
                            .shadow(radius: 5)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 2.5)
                            )
                    }
                    
                 
                    
                }.zIndex(1)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: 110, y: animatingBear ? 500 : 750)
                
                if correctChosen{
                    
                    let randomInt = Int.random(in: 1..<4)
                    
                    Image("bubbleChatRight"+String(randomInt))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(y: 425)
                }
                      
                if wrongChosen{
                    
                    let randomInt2 = Int.random(in: 1..<4)
                    
                    Image("bubbleChatWrong"+String(randomInt2))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(y: 425)
                }
            }.ignoresSafeArea()
                .fullScreenCover(isPresented: $showDialogueQuestions) {
                    listeningActivityQuestions(isPreview: false, ListeningActivityQuestionsVM: listeningActivityQuestionsVM)
                }
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                    
                }.onReceive(timer) { _ in
                    guard let player = audioManager.player, !isEditing else {return}
                    value = player.currentTime
                }
                .onChange(of: questionNumber){ newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        correctChosen = false
                    }
                    correctChosen = true
                }
        }
        
    }
    
    @ViewBuilder
    func NavBar() -> some View{
        HStack(spacing: 18){
            Button(action: {
                showUserCheck.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                
            })
            
            GeometryReader{proxy in
                      ZStack(alignment: .leading) {
                         Capsule()
                             .fill(.gray.opacity(0.25))
                          
                          Capsule()
                              .fill(Color.green)
                              .frame(width: proxy.size.width * progress)
                      }
                  }
            .frame(height: 10)
            .onChange(of: questionNumber){ newValue in
                progress = CGFloat(newValue) / CGFloat(5)
            }
            
            Image("italyFlag")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

struct radioButtonsLAComprehension: View {
    
    var correctAnswer: String
    var choicesIn: [String]

    @Binding var questionNumber: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    @Binding var showDialogueQuestions: Bool
    
    var body: some View{
        VStack(spacing: 0) {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctLAComprehensionButton(choice: choicesIn[i], questionNumber: $questionNumber, correctChosen: $correctChosen, showDiag: $showDialogueQuestions).padding(.bottom, 2)
                } else {
                    incorrectLAComprehensionButton(choice: choicesIn[i], correctChosen: $correctChosen, wrongChosen: $wrongChosen).padding(.bottom, 2)
                }
            }
        }
        
        
    }
}

struct userCheckNavigationPopUpListeningActivity: View{
    @Binding var showUserCheck: Bool
    
    var body: some View{
        
        
        ZStack{
            VStack{
                
                
                Text("Are you Sure you want to Leave the Page?")
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 17))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                
                Text("You will be returned to the 'Select Audio Page' and progress on this exercise will be lost")
                    .font(Font.custom("Arial Hebrew", size: 15))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                
                HStack{
                    Spacer()
                    NavigationLink(destination: availableShortStories(), label: {
                        Text("Yes")
                            .font(Font.custom("Arial Hebrew", size: 15))
                            .foregroundColor(Color.blue)
                    })
                    Spacer()
                    Button(action: {showUserCheck.toggle()}, label: {
                        Text("No")
                            .font(Font.custom("Arial Hebrew", size: 15))
                            .foregroundColor(Color.blue)
                    })
                    Spacer()
                }
            }
                
    
        }.frame(width: 265, height: 200)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
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
