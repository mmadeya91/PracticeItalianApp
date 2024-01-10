//
//  listeningActivityIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/4/24.
//

import SwiftUI

struct listeningActivityIPAD: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @Environment(\.dismiss) var dismiss
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    var isPreview: Bool = false
    
    
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
            ZStack(alignment: .topLeading){
                
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .zIndex(0)
                
                HStack(spacing: 18){
                    Spacer()
                    NavigationLink(destination: chooseAudio(), label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 45))
                            .foregroundColor(.gray)
                            
                            
                    })
                    
                    GeometryReader{proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(.gray.opacity(0.25))
                            
                            Capsule()
                                .fill(Color.green)
                                .frame(width: proxy.size.width * CGFloat(progress))
                        }
                    }.frame(height: 13)
                        .onChange(of: questionNumber){ newValue in
                            progress = (CGFloat(newValue) / 4)
                        }
                    
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                    Spacer()
                }.padding(.top, 30)
                    .zIndex(1)
                
                
                VStack{
                    
                    
                    VStack{
                        VStack(spacing: 0){
                           
                        
                                Image(listeningActivityVM.audioAct.image)
                                    .resizable()
                                    .scaledToFill()
                                    .padding(60)
                                    .frame(width: geo.size.width * 0.35, height: geo.size.height * 0.25)
                                    .background(Color("WashedWhite"))
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 200)
                                            .stroke(.black, lineWidth: 7)
                                    )
                                    .cornerRadius(200)
                                    //.padding(.top, 310)
                                    .shadow(radius: 10)
                           
                            
                            Text(listeningActivityVM.audioAct.title)
                                .font(Font.custom("Futura", size: 25))
                                .frame(width: 150, height: 80)
                                .multilineTextAlignment(.center)
                            
                        }
                        
                        
                        
                        
                        if let player = audioManager.player {
                            VStack(spacing: 0){
                                
                                Slider(value: $value, in: 0...player.duration) { editing
                                    in
                                    
                                    print("editing", editing)
                                    isEditing = editing
                                    
                                    if !editing {
                                        player.currentTime = value
                                    }
                                }
                                .scaleEffect(1.25)
                                .frame(width: 350, height: 20)
                                .tint(.orange)
                          
                                
                                HStack{
                                    Text(DateComponentsFormatter.positional
                                        .string(from: player.currentTime) ?? "0:00")
                                    .font(.system(size: 25))
                                    
                                    Spacer()
                                    
                                    Text(DateComponentsFormatter.positional
                                        .string(from: player.duration - player.currentTime) ?? "0:00")
                                    .font(.system(size: 25))
                                    
                                }.padding(5)
                            }.padding([.leading, .trailing], 35)
                                .padding(.top, 25)
                            
                            HStack{
                                let color: Color = audioManager.isLooping ? .teal : .black
                                let tortoiseColor: Color = audioManager.isSlowPlayback ? .teal : .black
                                
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
                                
                                PlaybackControlButton(systemName: "tortoise.fill", color: tortoiseColor){
                                    audioManager.slowSpeed()
                                }.padding(.trailing, 20)
                                
                                
                            }
                            .frame(width: 400).background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .padding([.leading, .trailing], 15)
                            .scaleEffect(1.2)
                            
                            
                        }
                    }.frame(width: geo.size.width * 0.9)
                        .padding([.leading, .trailing], geo.size.width * 0.05)
                        .padding(.top, 140)
                       // .scaleEffect(questionsExpanded ? 0.9 : 1)
                       //.offset(y: questionsExpanded ? -40 : 0)
                    
                    GroupBox{
                        
                        DisclosureGroup("Questions") {
                            
                            VStack{
                                
                                
                                Text(listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].question)
                                    .font(Font.custom("Arial Hebrew", size: geo.size.height * 0.018))
                                    .multilineTextAlignment(.center)
                                    .bold()
                                    .padding([.leading, .trailing], 5)
                                    .frame(width: geo.size.width)
                                    .padding([.top, .bottom], 12)
                                    .background(.teal.opacity(0.5))
                                    .border(width: 2.5, edges: [.bottom], color: .black)
                                
                                
                                if questionNumber != 4 {
                                    radioButtonsLAComprehensionIPAD(correctAnswer: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].answer, choicesIn: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].choices, questionNumber: $questionNumber, wrongChosen: $wrongChosen, correctChosen: $correctChosen, showDialogueQuestions: $showDialogueQuestions)
                                   
                                }
                                
                                
                                
                            }
                            .frame(width: geo.size.width - 150)
                            .background(Color("WashedWhite")).cornerRadius(2)
                            .overlay( RoundedRectangle(cornerRadius: 9)
                                .stroke(Color("DarkNavy"), lineWidth: 4))
                            .padding(.top, 10)
                            
                            
                        }
                        .tint(Color.black)
                        .font(Font.custom("Arial Hebrew", size: 16))
                        .frame(width: geo.size.width - 150)
                        
                        
                    } .padding(.bottom, 15)
                        .padding(.top, 35)
                       // .offset(y: questionsExpanded ? -50 : 0)
                        
                }.padding(.bottom, 10)
                    .zIndex(1)
                
                        
                    
                 
                    
                }
                
//                Image("sittingBear")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 200, height: 100)
//                    .offset(x: 110, y: animatingBear ? 500 : 750)
//
//                if correctChosen{
//
//                    let randomInt = Int.random(in: 1..<4)
//
//                    Image("bubbleChatRight"+String(randomInt))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 40)
//                        .offset(y: 425)
//                }
//
//                if wrongChosen{
//
//                    let randomInt2 = Int.random(in: 1..<4)
//
//                    Image("bubbleChatWrong"+String(randomInt2))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 40)
//                        .offset(y: 425)
//                }
                
                NavigationLink(destination:    listeningActivityQuestions(isPreview: false, listeningActivityVM: listeningActivityVM),isActive: $showDialogueQuestions,label:{}
                                                  ).isDetailLink(false)
                
            }  .ignoresSafeArea()
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    
                    audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                    
                }
                .onReceive(timer) { _ in
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

struct radioButtonsLAComprehensionIPAD: View {
    
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
                    correctLAComprehensionButtonIPAD(choice: choicesIn[i], questionNumber: $questionNumber, correctChosen: $correctChosen, showDiag: $showDialogueQuestions).padding(.bottom, 2)
                } else {
                    incorrectLAComprehensionButtonIPAD(choice: choicesIn[i], correctChosen: $correctChosen, wrongChosen: $wrongChosen).padding(.bottom, 2)
                }
            }
        }
        
        
    }
}

struct userCheckNavigationPopUpListeningActivityIPAD: View{
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
                    NavigationLink(destination: chooseAudio(), label: {
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

struct correctLAComprehensionButtonIPAD: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showDiag: Bool
    
    var body: some View{
        

        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                correctChosen = false
                withAnimation(.linear) {
                    
                        questionNumber = questionNumber + 1
                    if questionNumber == 4 {
                        showDiag = true
                    }
                    
                }
                
                colorOpacity = 0.0
                chosenOpacity = 0.0
            }
            
            correctChosen = true
            

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 19))
                    .padding([.leading, .trailing], 10)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:650, height: 40)
        .background(Color.green.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .scaleEffect(pressed ? 1.10 : 1.0)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 10)
        .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring()) {
                self.pressed = pressing
            }
            if pressing {
                
            } else {
                colorOpacity = 0.40
                chosenOpacity = 1.0
                SoundManager.instance.playSound(sound: .correct)
            }
        }, perform: { })
        
        
    }
    
}

struct incorrectLAComprehensionButtonIPAD: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    
    var body: some View{
        

        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
               wrongChosen = false
            }
            
                wrongChosen = true
                chosenOpacity = 1.0
                colorOpacity = 0.4
                SoundManager.instance.playSound(sound: .wrong)

            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            
            selected.toggle()
            
            
        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 19))
                    .padding([.leading, .trailing], 5)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:650, height: 40)
        .background(Color.red.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .offset(x: selected ? -5 : 0)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 10)
        .onChange(of: correctChosen) { newValue in
            if newValue == true {
                resetColors()
            }
        }

    }
    
    func resetColors() {
        colorOpacity = 0.0
        chosenOpacity = 0.0
    }
    
}



struct listeningActivityIPAD_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
  
    static var previews: some View {
        listeningActivityIPAD(listeningActivityVM: listeningActivityVM, isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}

