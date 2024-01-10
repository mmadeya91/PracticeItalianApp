//
//  ShortStoryPlugInViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/2/24.
//

import SwiftUI
import WrappingHStack

struct ShortStoryPlugInViewIPAD: View{
    
    @ObservedObject var shortStoryPlugInVM: ShortStoryViewModel
    @ObservedObject var globalModel = GlobalModel()
    @Environment(\.dismiss) var dismiss
    @State var questionNumber = 0
    @State var showPlayer = false
    @State var progress: CGFloat = 0
    @State var correctChosen: Bool = false
    @State var animateBear: Bool = false
    @State var selected: Bool = false
    @State var showUserCheck: Bool = false
    @State var showFinishedActivityPage = false
    
    @State var showHint = false
    
    var body: some View{
        GeometryReader {geo in
            ZStack(alignment: .topLeading){
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
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
                }.zIndex(1)
                
                if showUserCheck {
                    userCheckNavigationPopUpPlugInIPAD(showUserCheck: $showUserCheck)
                        .transition(.slide)
                        .animation(.easeIn)
                        .offset(x: 220, y: 250)
                        .zIndex(2)
                }
                ScrollViewReader{scroller in
                    
                    ZStack{
                        VStack{
                            //NavBar().zIndex(3)
                            
                            
                            ScrollView(.horizontal){
                                
                                HStack{
                                    ForEach(0..<shortStoryPlugInVM.currentPlugInQuestions.count, id: \.self) { i in
                                        VStack{
                                            
                                            
                                            
                                            ShortStoryPlugInViewBuilderIPAD(plugInQuestion: shortStoryPlugInVM.currentPlugInQuestions[i], plugInChoices: shortStoryPlugInVM.currentPlugInQuestionsChoices[i],questionNumber: $questionNumber, selected: $selected, correctChosen: $correctChosen, showHint: $showHint).frame(width: geo.size.width)
                                                .frame(minHeight: geo.size.height)
                                            
                                        }
                                        
                                    }
                                }
                                
                            }.offset(y: -25)
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                    
                                    if questionNumber == shortStoryPlugInVM.currentPlugInQuestions.count {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            
                                            showFinishedActivityPage = true
                                        }
                                    }
                                }
                            
                            
                        }.zIndex(2)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("DarkNavy"))
                            .frame(width: geo.size.width * 0.93, height: geo.size.height * 0.3)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("WashedWhite"), lineWidth: 4)
                            )
                            .zIndex(1)
                        
                        
                        
                        Text(showHint ? shortStoryPlugInVM.currentHints[questionNumber] : "Give me a Hint!")
                            .font(Font.custom("Arial Hebrew", size: 30))
                            .padding(15)
                            .padding(.top, 5)
                            .frame(height: 50)
                            .background(Color("WashedWhite")).cornerRadius(5)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .onTapGesture{
                                withAnimation(.easeIn(duration: 1)){
                                    showHint = true
                                }
                            }
                            .offset(y: geo.size.height / 2.75)
                            .zIndex(2)
                        
                        
                        
                        Image("sittingBear")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 400, height: 150)
                            .offset(x: 155, y: animateBear ? -175 : -100)
                            .zIndex(0)
                        
                        
                        if correctChosen{
                            
                            let randomInt = Int.random(in: 1..<4)
                            
                            Image("bubbleChatRight"+String(randomInt))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 60)
                                .offset(x: -20, y: -350)
                        }
                        
                        NavigationLink(destination:  ActivityCompletePage(),isActive: $showFinishedActivityPage,label:{}
                        ).isDetailLink(false)
                        
                    }
                    .onAppear{
                        shortStoryPlugInVM.setShortStoryData(storyName: "Cristofo Columbo")
                        withAnimation(.spring()){
                            animateBear = true
                        }
                    }.offset(x: selected ? -5 : 0)
                }
            }
        }
    }
    
    @ViewBuilder
    func NavBar() -> some View{
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
                    .font(Font.custom("ArialHebrew", size: 25))
                    .padding(9)
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 4)
                    .foregroundColor(.black)
                    .background(Color("WashedWhite")).cornerRadius(15).shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("WashedWhite"), lineWidth: 3)
                    )
                    .shadow(radius: 10)
                
                
            })
            .opacity(fillingBlank ? 0.0 : 1)
            .background {
                
                // This is the text that floats to the blank space
                Text(correctAnswer)
                    .font(Font.custom("ArialHebrew", size: 25))
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
                    .font(Font.custom("ArialHebrew", size: 25))
                    .padding(9)
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 4)
                    .foregroundColor(.black)
                    .background(Color("WashedWhite")).cornerRadius(15).shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("WashedWhite"), lineWidth: 3)
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
                                        .font(Font.custom("ArialHebrew", size: 25))
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
                                        .font(Font.custom("ArialHebrew", size: 25))
                                        .padding(1)
                                        .padding(.top, 6)
                                }
                            }.frame(width: geo.size.width * 0.8)
                                .padding(.leading, 12)
                                .padding([.top, .bottom], 25)
                            
                        }.frame(width: geo.size.width * 0.9)
                            .background(Color("WashedWhite")).cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 3)
                            )
                        
                        VStack {
                            VStack{
                                HStack(spacing: 20) {
                                    
                                    ForEach(0..<3) {i in
                                        if plugInChoices[i].isCorrect {
                                            
                                            buttonForAnswer(correctAnswer: plugInChoices[i].value)
                                        }else{
                                            buttonForIncorrect(wrongAnswer: plugInChoices[i].value)
                                        }
                                    }
                                }
                                HStack(spacing: 20) {
                                    
                                    ForEach(3..<6) {i in
                                        if plugInChoices[i].isCorrect {
                                            
                                            buttonForAnswer(correctAnswer: plugInChoices[i].value)
                                        }else{
                                            buttonForIncorrect(wrongAnswer: plugInChoices[i].value)
                                        }
                                    }
                                }.padding(.top, 15)
                            }.padding([.leading, .trailing], 15)
                            
                        }.padding(.top, 20)
    
                        
                        
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
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                    
                    Text("You will be returned to the 'select story page' and progress on this exercise will be lost")
                        .font(Font.custom("Arial Hebrew", size: 17))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                    
                    HStack{
                            Spacer()
                            NavigationLink(destination: availableShortStories(), label: {
                                Text("Yes")
                                    .font(Font.custom("Arial Hebrew", size: 17))
                                    .foregroundColor(Color.blue)
                            })
                            Spacer()
                            Button(action: {showUserCheck.toggle()}, label: {
                                Text("No")
                                    .font(Font.custom("Arial Hebrew", size: 17))
                                    .foregroundColor(Color.blue)
                            })
                            Spacer()
                        }
                        
                }
                    
        
            }.frame(width: 365, height: 250)
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
        static var shortStoryPlugInVM = ShortStoryViewModel(currentStoryIn: 0)
        static var previews: some View {
            ShortStoryPlugInViewIPAD(shortStoryPlugInVM: shortStoryPlugInVM).environmentObject(GlobalModel())
        }
    }
}
