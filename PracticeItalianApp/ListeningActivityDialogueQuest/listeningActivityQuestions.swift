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
    
    @ObservedObject var ListeningActivityQuestionsVM: ListeningActivityQuestionsViewModel
    
    @State var placeHolderArray: [FillInDialogueQuestion] = [FillInDialogueQuestion]()
    
    let arrayOfAudioNames = ["pcCut1", "pcCut2", "pcCut3", "pcCut4", "pcCut5", "pcCut6", "pcCut6", "pcCut7", "pcCut8"]
    
    var body: some View {
        
        ScrollViewReader {scrollView in
            ZStack(alignment: .topLeading){
                Button(action: {
                    audioManager.stop()
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size:36))
                        .foregroundColor(.black)
                    
                }).padding(.top, 120).padding(.trailing, 300)
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
                .background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.teal, lineWidth: 6)).padding(.top, 10).onAppear{
                        listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[0])
                        audioManager.startPlayer(track: arrayOfAudioNames[0])
                        placeHolderArray.append(ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[0])
                    }
            
            
            //BLANK SPACES FOR HINT LETTERS
            VStack(spacing: 0){
                //FORWARD BUTTON FOR NON QUESTION DIALOGUE BOXES
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
                        .frame(width: 30, height: 30)
                    
                }).offset(x:-140, y:55)
                    .opacity(onNoQuestionDialogue ? 1.0 : 0.0)
                    .disabled(onNoQuestionDialogue ? false : true)
                
                //REPEAT AUDIO BUTTON
                Button(action: {
                    
                    audioManager.startPlayer(track: arrayOfAudioNames[currentQuestionNumber])
                    
                }, label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                }).offset(x:145, y:25)
                
                //CREATES BLANK UNDERLINED LETTERS FOR HINT BUTTON
                HStack{
                    
                    ForEach($listeningActivityManager.currentHintLetterArray, id: \.self) { $answerArray in
                        Text(answerArray.letter!)
                            .font(Font.custom("Chalkboard SE", size: 25))
                            .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                            .underline(color: .black.opacity(onNoQuestionDialogue ? 0.0 : 1.0))
                        
                    }
                    
                }.frame(width:200, height: 40)
                
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
                    .background(.blue.opacity(0.75))
                    .cornerRadius(15)
                    .disabled(onNoQuestionDialogue)
                    .padding(.top, 20)
                    .padding(.bottom, 26)
                
                Button(action: {showPutInOrder.toggle()}, label: {Text("test")} )
                
                //HSTACK OF TEXT FIELD AND ENTER BUTTON
                HStack(spacing: 0){
                    TextField("", text: $userInput)
                        .background(Color.white.cornerRadius(10))
                        .opacity(0.35)
                        .font(Font.custom("Marker Felt", size: 50))
                        .shadow(color: changeColorOnWrongSelect ? Color.red : Color.black, radius: 12, x: 0, y:10)
                        .padding([.leading, .trailing], 15)
                        .offset(x: wrongSelected ? -5 : 0)
                    
                    //ENTER BUTTON
                    Button(action: {
                        if userInput.lowercased() == ListeningActivityQuestionsVM.dialogueQuestionView.fillInDialogueQuestionElement[currentQuestionNumber].answer.lowercased()
                        {
                            SoundManager.instance.playSound(sound: .correct)
                            
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
                            changeColorOnWrongSelect.toggle()
                        }
                        
                    }, label: {
                        Image("enter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                    })
                }.padding(.bottom, 50)
                    .padding([.leading, .trailing], 10)
                
            }.offset(y:-50)
        }.fullScreenCover(isPresented: $showPutInOrder) {
            let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: ListeningActivityElement.pastaCarbonara.putInOrderDialogueBoxes[0].fullSentences))
            LAPutDialogueInOrder(ListeningActivityQuestionsVM: ListeningActivityQuestionsVM, LAPutDialogueInOrderVM: LAPutDialogueInOrderVM)
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
        }.frame(width: 230)
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
        listeningActivityQuestions(ListeningActivityQuestionsVM: ListeningActivityQuestionsVM)
            .environmentObject(ListeningActivityManager())
            .environmentObject(AudioManager())
    }
}
