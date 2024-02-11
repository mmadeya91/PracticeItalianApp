//
//  ShortStoryPlugInView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 9/7/23.
//


import SwiftUI
import WrappingHStack

struct ShortStoryPlugInViewIPAD: View{
    
    @StateObject var shortStoryPlugInVM: ShortStoryViewModel
    @ObservedObject var globalModel = GlobalModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var questionNumber = 0
    @State var shortStoryName: String
    @State var showPlayer = false
    @State var isPreview: Bool
    @State var progress: CGFloat = 0
    @State var correctChosen: Bool = false
    @State var animateBear: Bool = false
    @State var selected: Bool = false
    @State var showUserCheck: Bool = false
    @State var showFinishedActivityPage = false
    @State var reloadPage = false
    
    @State var showHint = false
    
    var body: some View{
        GeometryReader {geo in
                ZStack(alignment: .topLeading){
                    Image("verticalNature")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .zIndex(0)
                    
                    HStack(spacing: 18){
                        Spacer()
                        Button(action: {
                            withAnimation(.linear){
                                showUserCheck.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 45))
                                .foregroundColor(.gray)
                            
                        }).zIndex(1)
                        
                        GeometryReader{proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                                
                                Capsule()
                                    .fill(Color.green)
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 18)
                            .onChange(of: questionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(shortStoryPlugInVM.currentPlugInQuestions.count - 1))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 50)
                            .shadow(radius: 10)
                            .padding()
                        Spacer()
                    }.zIndex(2)
                    HStack{
                        Spacer()
                        Text(showHint ? shortStoryPlugInVM.currentHints[questionNumber] : "Give me a Hint!")
                            .font(Font.custom("Arial Hebrew", size: 25))
                            .padding(25)
                            .padding(.top, 5)
                            .frame(height: 50)
                            .background(Color("WashedWhite")).cornerRadius(25)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .onTapGesture{
                                withAnimation(.easeIn(duration: 1)){
                                    showHint = true
                                }
                            }
                            .offset(y: 840)
                            .zIndex(2)
                        Spacer()
                    }.frame(width: geo.size.width).zIndex(2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("DarkNavy"))
                        .frame(width: geo.size.width * 0.93, height: geo.size.height * 0.45)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4)
                        )
                        .zIndex(0)
                        .offset(x: (geo.size.width / 25), y: (geo.size.height / 4))
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.4)
                        .offset(x: 450, y: animateBear ? geo.size.height * 0.85 : -100)
                        .zIndex(0)
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 40)
                            .offset(x: 350, y: geo.size.height * 0.87)
                    }
                    
                    
                    if showUserCheck {
                        userCheckNavigationPopUpPlugInIPAD(showUserCheck: $showUserCheck)
                            .transition(.slide)
                            .animation(.easeIn)
                            .zIndex(2)
                            .offset(x: (geo.size.width / 7), y: (geo.size.height / 6))
                    }
                    
                    ScrollViewReader{scroller in
                        VStack{
                            
                            ScrollView(.horizontal){
                                
                                HStack{
                                    ForEach(0..<shortStoryPlugInVM.currentPlugInQuestions.count, id: \.self) { i in
                                        VStack{
                                            
                                            
                                            
                                            ShortStoryPlugInViewBuilderIPAD(plugInQuestion: shortStoryPlugInVM.currentPlugInQuestions[i], plugInChoices: shortStoryPlugInVM.currentPlugInQuestionsChoices[i],questionNumber: $questionNumber, selected: $selected, correctChosen: $correctChosen, showHint: $showHint).frame(width: geo.size.width)
                                                .frame(minHeight: geo.size.height)
                                            
                                            
                                            
                                        }
                                        
                                    }
                                }
                                
                            }.offset(y: -145)
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    if questionNumber == shortStoryPlugInVM.currentPlugInQuestions.count {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            
                                            showFinishedActivityPage = true
                                        }
                                    }else{
                                        
                                        withAnimation{
                                            scroller.scrollTo(newIndex, anchor: .center)
                                        }
                                    }
                                    
                      
                                }
                            
                            
                        }.zIndex(2)
    
                        
                        NavigationLink(destination:  ActivityCompletePageIPAD(),isActive: $showFinishedActivityPage,label:{}
                        ).isDetailLink(false)
                        
                    }
                    .onAppear{
                        if isPreview {
                            shortStoryPlugInVM.setShortStoryData()
                            
                        }
                        shortStoryPlugInVM.setShortStoryData()
                        withAnimation(.spring()){
                            animateBear = true
                        }
                     
                    }.offset(x: selected ? -5 : 0)
                }.navigationBarBackButtonHidden(true)

        }
    }
    
    
    
    
    struct ShortStoryPlugInViewBuilderIPAD: View {
        var plugInQuestion: FillInBlankQuestion
        var plugInChoices: [pluginShortStoryCharacter]
        
        @Binding var questionNumber: Int
        
        @State private var frames: [CGRect] = [CGRect]()
        
        @State private var correctAnswers: [String] = ["nasce"]
        @State private var animateCorrect = false
        
        @Namespace private var namespace
        
        @State private var fillingBlank = false
        @State private var answer = "placeHolder"
        @Binding var selected: Bool
        @Binding var correctChosen: Bool
        @Binding var showHint: Bool
        
        func buttonForAnswer(correctAnswer: String) -> some View {
            Button(action: {
                answer = correctAnswer
                withAnimation(.linear(duration: 1)) {
                    fillingBlank = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    
                    questionNumber += 1
                    correctChosen = false
                    showHint = false
                }
                SoundManager.instance.playSound(sound: .correct)
                correctChosen = true
            },label: {
                Text(correctAnswer)
                    .font(Font.custom("ArialHebrew", size: 35))
                    .padding(15)
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 4)
                    .foregroundColor(.black)
                    .background(Color("WashedWhite")).cornerRadius(20).shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 5)
                    )
                    .shadow(radius: 10)
                
                
            })
            .opacity(fillingBlank ? 0.0 : 1)
            .background {
                
                // This is the text that floats to the blank space
                Text(correctAnswer)
                    .font(Font.custom("ArialHebrew", size: 35))
                    .foregroundColor(fillingBlank ? Color("pastelGreen") : Color.black)
                    .matchedGeometryEffect(
                        id: answer == correctAnswer && fillingBlank ? correctAnswer : correctAnswer,
                        in: namespace,
                        properties: .position,
                        isSource: false
                    )
            }
        }
        
        func buttonForIncorrect(wrongAnswer: String) -> some View {
            Button(action: {
                withAnimation((Animation.default.repeatCount(5).speed(6))) {
                    selected.toggle()
                }
                
                selected.toggle()
                SoundManager.instance.playSound(sound: .wrong)
            },label: {
                Text(wrongAnswer)
                    .font(Font.custom("ArialHebrew", size: 35))
                    .padding(15)
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 4)
                    .foregroundColor(.black)
                    .background(Color("WashedWhite")).cornerRadius(20).shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 5)
                    )
                    .shadow(radius: 10)
                
                
            })
        }
        
        var body: some View {
            
            
            GeometryReader { geo in
                ZStack{
                    
                    VStack{
                        VStack{
                            let sentenceArray: [String] = plugInQuestion.question.components(separatedBy: " ")
                            
                            WrappingHStack(0..<sentenceArray.count, id:\.self) {i in
                                
                                
                                if sentenceArray[i].elementsEqual(plugInQuestion.missingWord) {
                                    
                                    Text(sentenceArray[i])
                                        .font(Font.custom("ArialHebrew", size: 35))
                                        .foregroundColor(.secondary.opacity(0.0))
                                        .opacity(fillingBlank ? 0 : 1)
                                        .background(alignment: .bottom) {
                                            VStack {
                                                Divider().background(.primary)
                                            }
                                        }
                                        .matchedGeometryEffect(
                                            id: sentenceArray[i],
                                            in: namespace,
                                            isSource: fillingBlank
                                        )
                                        .padding(.top, 5)
                                    
                                }else {
                                    Text(String(sentenceArray[i]))
                                        .font(Font.custom("ArialHebrew", size: 35))
                                        .padding(1)
                                        .padding(.top, 6)
                                }
                            }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.125)
                                .padding(.leading, 12)
                                .padding([.top, .bottom], 25)
                            
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.2)
                            .background(Color("WashedWhite")).cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .padding(.leading, 5)
                        
                        VStack{
                            VStack{
                                HStack(spacing: 40) {
                                    
                                    ForEach(0..<3) {i in
                                        if plugInChoices[i].isCorrect {
                                            
                                            buttonForAnswer(correctAnswer: plugInChoices[i].value)
                                        }else{
                                            buttonForIncorrect(wrongAnswer: plugInChoices[i].value)
                                        }
                                    }
                                }
                                HStack(spacing: 40) {
                                    
                                    ForEach(3..<6) {i in
                                        if plugInChoices[i].isCorrect {
                                            
                                            buttonForAnswer(correctAnswer: plugInChoices[i].value)
                                        }else{
                                            buttonForIncorrect(wrongAnswer: plugInChoices[i].value)
                                        }
                                    }
                                }.padding(.top, 15)
                            }.padding([.leading, .trailing], 15)
                            
                        }.padding(.top, 40)
                        
                        
                        
                    }.frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                    
                    
                    
                    
                }
                
                
            }.offset(x: selected ? -5 : 0)
        }
        
        
    }
    
    struct userCheckNavigationPopUpPlugInIPAD: View{
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
                    
                    Text("You will be returned to the 'select story page' and progress on this exercise will be lost")
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
    
    struct ShortStoryPlugInViewIPAD_Previews: PreviewProvider {
        static var shortStoryPlugInVM = ShortStoryViewModel(currentStoryIn: "La Mia Introduzione")
        static var previews: some View {
            ShortStoryPlugInViewIPAD(shortStoryPlugInVM: shortStoryPlugInVM, shortStoryName: "La Mia Introduzione", isPreview: true).environmentObject(GlobalModel())
        }
    }
}



