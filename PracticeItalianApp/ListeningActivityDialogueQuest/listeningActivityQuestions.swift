//
//  SwiftUIView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/10/23.
//

import SwiftUI

struct listeningActivityQuestions: View {
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    
    @State private var blankSpace: String = ""
    @State private var userInput: String = ""
    
    @State var currentQuestionNumber: Int = 0
    @State var hintGiven: Bool = false
    @State var hintButtonText = "Give me a Hint!"
    @State var onNoQuestionDialogue = false
    @State var wrongSelected = false
    @State var changeColorOnWrongSelect = false
    @State var showPutInOrder = false
    @State var progress: CGFloat = 0.0
    @State var isPreview: Bool
    @State var animatingBear = false
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var showUserCheck: Bool = false
    
    
    @ObservedObject var ListeningActivityQuestionsVM: ListeningActivityQuestionsViewModel
    
    @State var placeHolderArray: [FillInDialogueQuestion] = [FillInDialogueQuestion]()
    
    let arrayOfAudioNames = ["pcCut1", "pcCut2", "pcCut3", "pcCut4", "pcCut5", "pcCut6", "pcCut6", "pcCut7", "pcCut8"]
    
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
                        .padding(.bottom, 250)
                        .zIndex(2)
                }
                
                
                ScrollViewReader {scrollView in
                    ZStack(alignment: .topLeading){
                        NavBar().padding([.leading, .trailing], 15)
                            .padding(.bottom, 20)
                            .padding(.top, 20)
                        
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ForEach(0..<placeHolderArray.count, id: \.self) {i in
                            
                            if placeHolderArray[i].isQuestion {
                                
                                
                                dialogueCaptionBoxWithQuestion(questionPart1: placeHolderArray[i].questionPart1, questionPart2: placeHolderArray[i].questionPart2, correctChosen: placeHolderArray[i].correctChosen, answer: placeHolderArray[i].answer, userInput: $userInput, currentQuestionNumber: $currentQuestionNumber).transition(.slide).animation(.easeIn(duration: 0.75)).padding([.leading, .trailing], 15).padding(.top, 15).padding(.bottom, 10)
                                
                                
                                
                                
                            }else {
                                
                                
                                dialogueCaptionBoxNoQuestion(fullSentence: placeHolderArray[i].fullSentence, questionNumber: i, currentQuestionNumber: $currentQuestionNumber).transition(.slide).animation(.easeIn).padding([.leading, .trailing], 10).padding([.top, .bottom], 15)
                                
                                
                            }
                        }
                    }.frame(width: 340, height: 390)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 6)).padding(.top, 10)
                        .onAppear{
                            
                            if !isPreview{
                                listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[0])
                                audioManager.startPlayer(track: arrayOfAudioNames[0])
                                placeHolderArray.append(ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[0])
                            }
                        }
                        .shadow(radius: 10)
                    
                    //BLANK SPACES FOR HINT LETTERS
                    VStack(spacing: 0){
                        //FORWARD BUTTON FOR NON QUESTION DIALOGUE BOXES
                        HStack{
                            Button(action: {
                                currentQuestionNumber += 1
                                placeHolderArray.append(ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber])
                                if ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                    listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber])
                                    
                                    onNoQuestionDialogue = false
                                }else {
                                    listeningActivityManager.resetCurrentHintLetterArray()
                                    onNoQuestionDialogue = true
                                }
                                hintGiven = false
                                hintButtonText = "Give me a Hint!"
                                userInput = ""
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                                    scrollView.scrollTo(currentQuestionNumber)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    audioManager.startPlayer(track: arrayOfAudioNames[currentQuestionNumber])
                                }
                                
                                
                            }, label: {
                                Image(systemName: "arrow.forward.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color("WashedWhite"))
                                    .frame(width: 30, height: 30)
                                
                            })
                            .opacity(onNoQuestionDialogue ? 1.0 : 0.0)
                            .disabled(onNoQuestionDialogue ? false : true)
                            
                            
                            Spacer()
                            //CREATES BLANK UNDERLINED LETTERS FOR HINT BUTTON
                            HStack{
                                
                                ForEach($listeningActivityManager.currentHintLetterArray, id: \.self) { $answerArray in
                                    Text(answerArray.letter!)
                                        .font(Font.custom("Chalkboard SE", size: 25))
                                        .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                                        .underline(color: .black.opacity(onNoQuestionDialogue ? 0.0 : 1.0))
                                    
                                }
                                
                            }.frame(width:200, height: 40)
                            
                            Spacer()
                            
                            Button(action: {
                                
                                audioManager.startPlayer(track: arrayOfAudioNames[currentQuestionNumber])
                                
                            }, label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color("WashedWhite"))
                                    .frame(width: 30, height: 30)
                                
                            })
                            
                        }
                        .padding([.leading, .trailing], 35)
                        .padding(.top, 50)
                        
                        
                        //HINT BUTTON
                        Button(action: {
                            if !hintGiven {
                                var array = [Int](0...listeningActivityManager.currentHintLetterArray.count-1)
                                array.shuffle()
                                listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                
                                hintButtonText = "Show Me!"
                                hintGiven = true
                            }else{
                                
                                listeningActivityManager.showHint()
                            }
                            
                        }, label: {
                            
                            Text(hintButtonText)
                                .font(Font.custom("Chalkboard SE", size: 18))
                                .foregroundColor(.white)
                            
                        }).frame(width: 150, height: 40)
                            .background(.teal)
                            .cornerRadius(15)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .disabled(onNoQuestionDialogue)
                            .padding(.top, 20)
                            .padding(.bottom, 26)
                        
                        //HSTACK OF TEXT FIELD AND ENTER BUTTON
                        HStack(spacing: 0){
                            TextField("", text: $userInput)
                                .background(Color.white.cornerRadius(10))
                                .font(Font.custom("Marker Felt", size: 50))
                                .shadow(color: changeColorOnWrongSelect ? Color.red : Color.black, radius: 12, x: 0, y:10)
                                .padding([.leading, .trailing], 15)
                                .offset(x: wrongSelected ? -5 : 0)
                                .onSubmit {
                                    if userInput.lowercased() == ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber].answer.lowercased()
                                    {
                                        SoundManager.instance.playSound(sound: .correct)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            correctChosen = false
                                        }
                                        
                                        correctChosen = true
                                        
                                        placeHolderArray[currentQuestionNumber].correctChosen = true
                                        currentQuestionNumber += 1
                                        placeHolderArray.append(ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber])
                                        if ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                            listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber])
                                            
                                            onNoQuestionDialogue = false
                                        }else {
                                            listeningActivityManager.resetCurrentHintLetterArray()
                                            onNoQuestionDialogue = true
                                        }
                                        hintGiven = false
                                        hintButtonText = "Give me a Hint!"
                                        userInput = ""
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                            scrollView.scrollTo(currentQuestionNumber)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            audioManager.startPlayer(track: arrayOfAudioNames[currentQuestionNumber])
                                        }
                                        
                                        
                                    } else {
                                        SoundManager.instance.playSound(sound: .wrong)
                                        withAnimation((Animation.default.repeatCount(5).speed(6))) {
                                            wrongSelected.toggle()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            changeColorOnWrongSelect.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            wrongChosen = false
                                        }
                                        
                                        wrongChosen = true
                                        
                                        changeColorOnWrongSelect.toggle()
                                    }
                                }
                            
                        }.padding(.bottom, 50)
                            .padding([.leading, .trailing], 10)
                        
                    }.offset(y:-50)
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .offset(x: 130, y: animatingBear ? -20 : 750)
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(x: 25, y: -180)
                    }
                          
                    if wrongChosen{
                        
                        let randomInt2 = Int.random(in: 1..<4)
                        
                        Image("bubbleChatWrong"+String(randomInt2))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(x: 25, y: -180)
                    }
                }
            }.fullScreenCover(isPresented: $showPutInOrder) {
                let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: ListeningActivityElement.pastaCarbonara.putInOrderDialogueBoxes[0].fullSentences))
                LAPutDialogueInOrder(ListeningActivityQuestionsVM: ListeningActivityQuestionsVM, LAPutDialogueInOrderVM: LAPutDialogueInOrderVM)
            }
            .onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
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
            .onChange(of: currentQuestionNumber){ newValue in
                progress = CGFloat(newValue) / CGFloat(5)
            }
            
            Image("italyFlag")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}




struct dialogueCaptionBoxWithQuestion: View {
    
    var questionPart1: String
    var questionPart2: String
    var correctChosen: Bool
    var answer: String
    
    @Binding var userInput: String
    @Binding var currentQuestionNumber: Int

    
    var body: some View{
        
        HStack {
            if !correctChosen {
                Text(questionPart1)
                    .font(Font.custom("Chalkboard SE", size: 13)) +
                Text("_________")
                    .underline(color: Color.blue.opacity(1.0))
                    .font(Font.custom("Chalkboard SE", size: 13))
                     +
                Text(questionPart2)
                    .font(Font.custom("Chalkboard SE", size: 13))
            }else {
                Text(questionPart1)
                    .font(Font.custom("Chalkboard SE", size: 13)) +
                
                Text(answer).underline()
                    .font(Font.custom("Chalkboard SE", size: 13))
                    .foregroundColor(.green)
                    +
                Text(questionPart2)
                    .font(Font.custom("Chalkboard SE", size: 13))
            }
        }.frame(width: 245)
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 20)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        
    }
}

struct dialogueCaptionBoxNoQuestion: View {
    var fullSentence: String
    var questionNumber: Int
    
    @Binding var currentQuestionNumber: Int
    
    var body: some View {
        
        Text(fullSentence)
            .font(Font.custom("Chalkboard SE", size: 15))
            .frame(width: 230)
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 20)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static let ListeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))
    static var previews: some View {
        listeningActivityQuestions(isPreview: false, ListeningActivityQuestionsVM: ListeningActivityQuestionsVM)
            .environmentObject(ListeningActivityManager())
            .environmentObject(AudioManager())
    }
}
