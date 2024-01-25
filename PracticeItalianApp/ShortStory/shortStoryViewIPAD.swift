//
//  shortStoryViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/2/24.
//

import SwiftUI


struct shortStoryViewIPAD: View {
    @EnvironmentObject var audioManager: AudioManager
    
    @State var chosenStoryNameIn: String
    @State var progress: CGFloat = 0
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var storyHeight: CGFloat = 380
    
    @State var showShortStoryDragDrop = false
    
    @State var showEnglish = false
    
    @StateObject var shortStoryDragDropVM = ShortStoryDragDropViewModel(chosenStoryName: "La Mia Introduzione")
    
    var storyData: shortStoryData { shortStoryData(chosenStoryName: chosenStoryNameIn)}
    
    var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
    
    
    var body: some View {
        GeometryReader{ geo in
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
                }
                    
                Button(action: {
                    withAnimation(.easeIn){
                        showEnglish.toggle()
                    }
                }, label: {
                    Image(systemName: showEnglish ? "eye.slash" : "eye")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                }).zIndex(2)
                    .offset(x:650, y: 150)

                if showPopUpScreen{
                    popUpViewIPAD(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen).transition(.slide).animation(.easeIn).zIndex(2)
                        .offset(x: (geo.size.width / 4), y: (geo.size.height / 2) - 155)

                }
                
                VStack(spacing: 0){
                        ScrollView(.vertical, showsIndicators: false) {
                            Text("Cristofo Columbo")
                                .font(Font.custom("Arial Hebrew", size: 35))
                                .padding(.top, 40)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 210, height: 1)
                                    , alignment: .bottom
                                )
                            
                            if !showEnglish {
                                Text(.init(storyObj.storyString))
                                    .font(Font.custom("Arial Hebrew", size: 25))
                                    .padding(.top, 40)
                                    .padding(.leading, 50)
                                    .padding(.trailing, 50)
                                    .lineSpacing(20)
                                    .environment(\.openURL, OpenURLAction { url in
                                        handleURL(url, name: url.valueOf("word")!)
                                        
                                    })
                            }else{
                                Text(.init(storyObj.storyStringEnglish))
                                    .font(Font.custom("Arial Hebrew", size: 25))
                                    .padding(.top, 40)
                                    .padding(.leading, 50)
                                    .padding(.trailing, 50)
                                    .lineSpacing(20)
                            }
                            
                            
                            
                        }.frame(width: geo.size.width - 150).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("DarkNavy"), lineWidth: 6)).padding(.bottom, 25)
                        .padding(.top, 50)
                    
                    GroupBox{
                  
                        DisclosureGroup("Questions") {
      
                            VStack(spacing: 0){
                              
                                Text(storyObj.questionList[questionNumber].question)
                                    .font(Font.custom("Arial Hebrew", size: 23))
                                    .padding()
                                    .frame(width: geo.size.width - 37, height: 55)
                                    .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 9)
                                        .stroke(.black, lineWidth: 4))
                          
                                
                                radioButtonsMCIPAD(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                                    .padding([.top, .bottom], 15)

                                
                                
                            }
                            .frame(width: geo.size.width * 0.82)
                            .background(Color("WashedWhite")).cornerRadius(2)
                            .overlay( RoundedRectangle(cornerRadius: 9)
                                .stroke(Color("DarkNavy"), lineWidth: 4))
                            .padding(.top, 10)
                            
                            
                        }
                        .tint(Color.black)
                        .font(Font.custom("Arial Hebrew", size: 25))
                        .frame(width: geo.size.width * 0.82)
                   
                    
                    } .padding(.bottom, 15)
                        .padding([.leading, .trailing], geo.size.width * 0.05)
                    
                    
                     
                    
                }.padding(.top, 60)
                    .padding(.leading, 20)
                    .zIndex(1)
                        //QUESTIONS VIEW
                        if showQuestionDropdown && !showShortStoryDragDrop{

                            VStack(alignment: .leading){

                                    Text(storyObj.questionList[questionNumber].question)
                                        .font(Font.custom("Arial Hebrew", size: 25))
                                        .bold()
                                        .padding([.leading, .trailing], 10 )
                                        .padding(.top, 5)
                                        .padding(.bottom, 10)


                                radioButtonsMCIPAD(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)


                            }
                            .frame(width: 435, height: 210)
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                            .padding(.top, 415)
                            .padding(.leading, 21)
                            .zIndex(0)
                           
                            



                        }
                    
                    NavigationLink(destination:  ShortStoryDragDropView(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: false),isActive: $showShortStoryDragDrop,label:{}
                                                      ).isDetailLink(false)
                    
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func handleURL(_ url: URL, name: String) -> OpenURLAction.Result {
        linkClickedString = name
        showPopUpScreen.toggle()
        return .handled
    }
    
}


struct popUpViewIPAD: View{
    
    var storyObj: shortStoryObject
    
    @Binding var linkClickedString: String
    @Binding var showPopUpScreen: Bool
    
    var body: some View{
        
        let wordLink: WordLink = storyObj.collectWordExpl(ssO: storyObj, chosenWord: linkClickedString)
        
        
        
        ZStack{
            Button(action: {
                showPopUpScreen.toggle()
            }, label: {
                Image("popUpX")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)

            }).offset(x: -135, y:-65).zIndex(1)
            VStack{
                
                
                Text(wordLink.infinitive)
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 30))
                    .foregroundColor(Color.black)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                    .underline()
                
                
                Text(wordLink.wordNameEng)
                    .font(Font.custom("Arial Hebrew", size: 25))
                    .foregroundColor(Color.black)
                    .padding([.leading, .trailing], 5)
                
                
                if wordLink.explanation != "" {
                    Text(wordLink.explanation)
                        .font(Font.custom("Arial Hebrew", size: 25))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                    
                    
                    
                }
                
                
                
            }.zIndex(0)
        }.frame(width: 360, height: 230)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
    }
}


struct radioButtonsMCIPAD: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    
    @State var correctChosen: Bool = false
    @Binding var questionNumber: Int
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    
    var body: some View{
        VStack(spacing: 10) {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctShortStoryButtonIPAD(choice: choicesIn[i], questionNumber: $questionNumber, correctChosen: $correctChosen, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                      
                } else {
                    incorrectShortStoryButtonIPAD(choice: choicesIn[i], correctChosen: $correctChosen)
                }
            }
        }
        
        
    }
}

struct correctShortStoryButtonIPAD: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    
    var body: some View{
        

        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                
                if questionNumber != 3 {
                    questionNumber = questionNumber + 1
                    correctChosen.toggle()
                }else{
                    progress = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showShortStoryDragDrop = true
                    }
                }
                
                if progress != 1 {
                    colorOpacity = 0.0
                    chosenOpacity = 0.0
                }
            }
            
            
                correctChosen = false
         

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .padding([.leading, .trailing], 15)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:530, height: 40)
        .background(Color.green.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .scaleEffect(pressed ? 1.10 : 1.0)
        .padding([.leading, .trailing], 10)
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

struct incorrectShortStoryButtonIPAD: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @Binding var correctChosen: Bool
    
    var body: some View{
        

        Button(action: {
            
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
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .padding([.leading, .trailing], 15)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:530, height: 40)
        .background(Color.red.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .offset(x: selected ? -5 : 0)
        .padding([.leading, .trailing], 10)
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

struct textModiferIPAD : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Hebrew", size: 18))
            .padding(.top, 40)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .lineSpacing(20)
        
    }
}


struct shortStoryViewIPAD_Previews: PreviewProvider {
    static var previews: some View {
        shortStoryViewIPAD(chosenStoryNameIn: "La Mia Introduzione")
            .environmentObject(AudioManager())
    }
}
