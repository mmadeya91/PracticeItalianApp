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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var blankSpace: String = ""
    @State private var userInput: String = ""
    
    @State var currentQuestionNumber: Int = 0
    @State var hintGiven: Bool = false
    @State var hintButtonText = "Hint!"
    @State var isQuestionDialogue = false
    @State var wrongSelected = false
    @State var changeColorOnWrongSelect = false
    @State var showPutInOrder = false
    @State var progress: CGFloat = 0.0
    @State var isPreview: Bool
    @State var animatingBear = false
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var showUserCheck: Bool = false
    @State var showInfoPopUp = false
    
    
    @ObservedObject var listeningActivityVM: ListeningActivityViewModel
    
    @State var placeHolderArray: [FillInDialogueQuestion] = [FillInDialogueQuestion]()
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
                    
                    Image("verticalNature")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .zIndex(0)
                    
                    HStack(spacing: 18){
                        Spacer()
                        NavigationLink(destination: availableShortStories(), label: {
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
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 13)
                            .onChange(of: currentQuestionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(listeningActivityVM.audioAct.numberofDialogueQuestions))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Spacer()
                    }
                    
                    if showUserCheck {
                        userCheckNavigationPopUpListeningActivity(showUserCheck: $showUserCheck)
                            .transition(.slide)
                            .animation(.easeIn)
                            .padding(.leading, 5)
                            .padding(.bottom, 250)
                            .zIndex(2)
                    }
                    
                    if showInfoPopUp{
                        ZStack(alignment: .topLeading){
                            Button(action: {
                                showInfoPopUp.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 15)
                                .zIndex(1)
                                .offset(y: -15)
                           
                         
             
                                
                            (Text("Lines of audio from the dialogue will play one by one. Some of them will be missing important keywords that you must figure out and input in the text box. \n\nNot all of the dialogues pose a question, in that case use the  ") +
                             Text(Image(systemName: "arrow.forward.circle")) +
                             Text("  button to continue forward. If you need to hear a portion of the dialogue again, just use the  ") +
                             Text(Image(systemName: "arrow.triangle.2.circlepath")) +
                             Text("  button. If you are having trouble, there are hints available to you as well. \n\nRemember, spelling is important! including accents! It may be usefull to switch the keyboard on your phone to 'Italian' to make things easier."))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .offset(y: 20)
                                    
                         
                        }.frame(width: geo.size.width * 0.85, height: 500)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .transition(.slide).animation(.easeIn).zIndex(2)
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                            .padding([.top, .bottom], geo.size.height * 0.12)
                            .zIndex(3)
                        
                        
                    }
                    
                    
                    ScrollViewReader {scrollView in
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            ForEach(0..<placeHolderArray.count, id: \.self) {i in
                                
                                HStack{
                                    if placeHolderArray[i].speakerNumber == 2 {
                                        Spacer()
                                    }
                                    if placeHolderArray[i].isQuestion {
                                        
                                        
                                        dialogueCaptionBoxWithQuestion(questionPart1: placeHolderArray[i].questionPart1, questionPart2: placeHolderArray[i].questionPart2, correctChosen: placeHolderArray[i].correctChosen, answer: placeHolderArray[i].answer, speakerNumber: placeHolderArray[i].speakerNumber, isConversation: listeningActivityVM.audioAct.isConversation, speaker1Image: listeningActivityVM.audioAct.speaker1Image, speaker2Image: listeningActivityVM.audioAct.speaker2Image, userInput: $userInput, currentQuestionNumber: $currentQuestionNumber)
                                            .padding([.leading, .trailing], 15)
                                        
                                        
                                        
                                    }else {
                                        
                                        
                                        dialogueCaptionBoxNoQuestion(fullSentence: placeHolderArray[i].fullSentence, questionNumber: i, speakerNumber: placeHolderArray[i].speakerNumber, isConversation: listeningActivityVM.audioAct.isConversation, speaker1Image: listeningActivityVM.audioAct.speaker1Image, speaker2Image: listeningActivityVM.audioAct.speaker2Image, currentQuestionNumber: $currentQuestionNumber)
                                            .padding([.leading, .trailing], 15)
                                        
                                        
                                    }
                                    if placeHolderArray[i].speakerNumber == 1{
                                        Spacer()
                                    }
                                    
                                    
                                }.transition(placeHolderArray[i].speakerNumber == 1 ? .slide : .backslide).animation(.easeIn(duration: 0.75)).padding(.top, 15).padding(.bottom, 5)
                            
                                
                            }
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.45)
                            .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 6)).padding(.top, 10)
                            .shadow(radius: 10)
                            .padding(.top, 55)
                        
                        //BLANK SPACES FOR HINT LETTERS
                        VStack(spacing: 0){
                            //FORWARD BUTTON FOR NON QUESTION DIALOGUE BOXES
                            HStack{
                                Button(action: {
                                    currentQuestionNumber += 1
                                    if currentQuestionNumber <= listeningActivityVM.audioAct.fillInDialogueQuestionElement.count - 1{
                                        placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                        
                                        if listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                            listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                            
                                            isQuestionDialogue = true
                                        }else {
                                            listeningActivityManager.resetCurrentHintLetterArray()
                                            isQuestionDialogue = false
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                                            scrollView.scrollTo(currentQuestionNumber)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                        }
                                    }
                                    
                                    hintGiven = false
                                    hintButtonText = "Hint!"
                                    userInput = ""
                                    
                                    
                                }, label: {
                                    Image(systemName: "arrow.forward.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                    
                                })
                                .opacity(isQuestionDialogue ? 0.0 : 1.0)
                                .disabled(isQuestionDialogue ? true : false)
                                
                                
                                Spacer()
                                //CREATES BLANK UNDERLINED LETTERS FOR HINT BUTTON
                                HStack{
                                    
                                    ForEach($listeningActivityManager.currentHintLetterArray, id: \.self) { $answerArray in
                                        Text(answerArray.letter)
                                            .font(Font.custom("Chalkboard SE", size: 25))
                                            .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                                            .underline(color: .black.opacity(isQuestionDialogue ? 1.0 : 0.0))
                                        
                                    }
                                    
                                }.frame(width:200, height: 40)
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                    
                                }, label: {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.black)
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
                                    if listeningActivityManager.currentHintLetterArray.count == 2 {
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }
                                    if listeningActivityManager.currentHintLetterArray.count == 3 {
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }
                                    if listeningActivityManager.currentHintLetterArray.count > 3 {
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }
                                    
                                }else{
                                    
                                    listeningActivityManager.showHint()
                                }
                                
                            }, label: {
                                
                                Text(hintButtonText)
                                    .font(Font.custom("Chalkboard SE", size: 18))
                                    .foregroundColor(.white)
                                    .padding(25)
                                
                            }).frame(height: 35)
                                .background(Color("DarkNavy"))
                                .cornerRadius(15)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(.black, lineWidth: 2)
                                )
                                .disabled(isQuestionDialogue ? false : true)
                                .padding(.top, 20)
                                .padding(.bottom, 26)
                            
                            //HSTACK OF TEXT FIELD AND ENTER BUTTON
                            HStack(spacing: 0){
                                
                                Button(action: {
                                    withAnimation(.linear){
                                        showInfoPopUp.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "info.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                    
                                })
                                
                                TextField("", text: $userInput)
                                    .background(Color.white.cornerRadius(10))
                                    .font(Font.custom("Marker Felt", size: 40))
                                    .shadow(color: changeColorOnWrongSelect ? Color.red : Color.black, radius: 12, x: 0, y:10)
                                    .padding([.leading, .trailing], 15)
                                    .offset(x: wrongSelected ? -5 : 0)
                                    .onSubmit {
                                        if userInput.lowercased() == listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].answer.lowercased()
                                        {
                                            SoundManager.instance.playSound(sound: .correct)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                correctChosen = false
                                            }
                                            
                                            correctChosen = true
                                            
                                            placeHolderArray[currentQuestionNumber].correctChosen = true
                                            currentQuestionNumber += 1
                                            placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                            if listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                                listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                                
                                                isQuestionDialogue = true
                                            }else {
                                                listeningActivityManager.resetCurrentHintLetterArray()
                                                isQuestionDialogue = false
                                            }
                                            hintGiven = false
                                            hintButtonText = "Hint!"
                                            userInput = ""
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                scrollView.scrollTo(currentQuestionNumber)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
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
                            .frame(width: geo.size.height * 0.3, height: geo.size.height * 0.3)
                            .offset(x: 130, y: animatingBear ? -80 : 750)
                        
                        if correctChosen{
                            
                            let randomInt = Int.random(in: 1..<4)
                            
                            Image("bubbleChatRight"+String(randomInt))
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                                .offset(x: 20, y: -300)
                        }
                        
                        if wrongChosen{
                            
                            let randomInt2 = Int.random(in: 1..<4)
                            
                            Image("bubbleChatWrong"+String(randomInt2))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 40)
                                .offset(x: 15, y: -280)
                        }
                    }
                    
                    let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: listeningActivityVM.audioAct.putInOrderSentenceArray[0].fullSentences))
                    
                    NavigationLink(destination: LAPutDialogueInOrder(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM),isActive: $showPutInOrder,label:{}
                    ).isDetailLink(false)
                    
                }
                .onChange(of: currentQuestionNumber) { questionNumber in
                    
                    if questionNumber > listeningActivityVM.audioAct.audioCutFileNames.count - 1{
                        showPutInOrder = true
                    }
                }.navigationBarBackButtonHidden(true)
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    
                    
                    listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[0])
                    placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[0])
                    isQuestionDialogue = listeningActivityVM.audioAct.fillInDialogueQuestionElement[0].isQuestion
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[0], isPreview: isPreview)
                    }
                    
                }
            }else{
                listeningActivityQuestionsIPAD(isPreview: false, listeningActivityVM: listeningActivityVM)
            }
        }
    }
    
}




struct dialogueCaptionBoxWithQuestion: View {
    
    var questionPart1: String
    var questionPart2: String
    var correctChosen: Bool
    var answer: String
    var speakerNumber: Int
    var isConversation: Bool
    var speaker1Image: String
    var speaker2Image: String
    
    @Binding var userInput: String
    @Binding var currentQuestionNumber: Int
    

    
    var body: some View{
        if speakerNumber == 1 {
            HStack{
                ImageOnCircleListening(icon: speaker1Image, radius: 18, isSpeaker1: true)
                    .padding(.trailing, 10)
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
                }.frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
            }
        }else{
            HStack{
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
                }.frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                ImageOnCircleListening(icon: speaker2Image, radius: 18, isSpeaker1: false)
                    .padding(.trailing, 10)
                
            }
            
        }
    }
}

struct dialogueCaptionBoxNoQuestion: View {
    var fullSentence: String
    var questionNumber: Int
    var speakerNumber: Int
    var isConversation: Bool
    var speaker1Image: String
    var speaker2Image: String
    
    
    @Binding var currentQuestionNumber: Int
    
    var body: some View {
        if speakerNumber == 1{
            HStack{
                ImageOnCircleListening(icon: speaker1Image, radius: 18, isSpeaker1: true)
                    .padding(.trailing, 10)
                Text(fullSentence)
                    .font(Font.custom("Chalkboard SE", size: 15))
                    .frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }else{
            HStack{
                Text(fullSentence)
                    .font(Font.custom("Chalkboard SE", size: 15))
                    .frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                ImageOnCircleListening(icon: speaker2Image, radius: 18, isSpeaker1: false)
                    .padding(.trailing, 10)
            }
        }
        
        
    }
}

struct ImageOnCircleListening: View {
    
    let icon: String
    let radius: CGFloat
    let isSpeaker1: Bool
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSpeaker1 ? .teal : .orange)
                .frame(width: radius * 2, height: radius * 2)
              
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static let listeningActivityVM = ListeningActivityViewModel(audioAct: audioActivty.cosaDesidera)

    static var previews: some View {
        listeningActivityQuestions(isPreview: false, listeningActivityVM: listeningActivityVM)
            .environmentObject(ListeningActivityManager())
            .environmentObject(AudioManager())
    }
}
