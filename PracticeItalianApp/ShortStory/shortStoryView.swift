//
//  shortStoryView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/5/23.
//

import SwiftUI
import SwiftUIKit


extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct shortStoryView: View {
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var chosenStoryNameIn: String
    @State var progress: CGFloat = 0
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var storyHeight: CGFloat = 380
    
    @State var showShortStoryDragDrop = false
    
    @State var showEnglish = false
    
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    
    var storyData: shortStoryData { shortStoryData(chosenStoryName: chosenStoryNameIn)}
    
    var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
    
    
    
    var body: some View {
        
        
        
        GeometryReader{ geo in
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
                            .onChange(of: questionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(storyObj.questionList.count + 1))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Spacer()
                    }
                    
                    //                    Button(action: {
                    //                        withAnimation(.easeIn){
                    //                            showEnglish.toggle()
                    //                        }
                    //                    }, label: {
                    //                        Image(systemName: showEnglish ? "eye.slash" : "eye")
                    //                            .resizable()
                    //                            .scaledToFill()
                    //                            .foregroundColor(.black)
                    //                            .frame(width: 20, height: 20)
                    //                    }).zIndex(2)
                    //                        .offset(x:330, y: 80)
                    
                    //if showPopUpScreen{
                    popUpView(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen).zIndex(2)
                        .offset(x: showPopUpScreen ? (geo.size.width / 9) : -550, y: (geo.size.height / 2) - 155)
                    
                    
                    
                    //}
                    
                    VStack(spacing: 0){
                        ScrollView(.vertical, showsIndicators: false) {
                            HStack(spacing: 0){
                                
                                Text(chosenStoryNameIn)
                                    .font(Font.custom("Arial Hebrew", size: 25))
                                    .padding(.top, 30)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 210, height: 1)
                                        , alignment: .bottom
                                    ).zIndex(0)
                                    .padding(.leading, 10)
                                
                                Button(action: {
                                    withAnimation(.easeIn){
                                        showEnglish.toggle()
                                    }
                                }, label: {
                                    Image(systemName: showEnglish ? "eye.slash" : "eye")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.black)
                                        .frame(width: 20, height: 20)
                                }).zIndex(3)
                                    .offset(x: 20)
                                
                                
                            }
                            
                            if !showEnglish {
                                Text(.init(storyObj.storyString))
                                    .modifier(textModifer())
                                    .environment(\.openURL, OpenURLAction { url in
                                        handleURL(url, name: url.valueOf("word")!)
                                        
                                    })
                            }else{
                                Text(.init(storyObj.storyStringEnglish))
                                    .modifier(textModifer())
                            }
                            
                            
                            
                        }.frame(width: geo.size.width - 40).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("DarkNavy"), lineWidth: 6)).padding(.bottom, 25)
                        
                        GroupBox{
                            
                            DisclosureGroup("Questions") {
                                
                                VStack(spacing: 0){
                                    
                                    Text(storyObj.questionList[questionNumber].question)
                                        .font(Font.custom("Arial Hebrew", size: 17))
                                        .multilineTextAlignment(.center)
                                        .padding(15)
                                        .frame(width: geo.size.width - 37)
                                        .background(Color("WashedWhite")).cornerRadius(20)
                                        .border(width: 4, edges: [.bottom], color:Color("DarkNavy"))
                                    
                                    
                                    radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), totalQuestionCount: storyObj.questionList.count, questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                                        .padding(.top, 10)
                                        .padding(.bottom, 16)
                                    
                                    
                                    
                                }
                                .frame(width: geo.size.width - 60)
                                .background(Color("WashedWhite")).cornerRadius(1)
                                .overlay( RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color("DarkNavy"), lineWidth: 4))
                                .padding(.top, 10)
                                
                                
                                
                            }
                            .tint(Color.black)
                            .font(Font.custom("Arial Hebrew", size: 16))
                            .frame(width: geo.size.width - 70)
                            
                        } .padding(.bottom, 15)
                        
                        
                        
                        
                    }.padding(.top, 60)
                        .padding(.leading, 20)
                        .zIndex(1)
                    //QUESTIONS VIEW
                    //                    if showQuestionDropdown && !showShortStoryDragDrop{
                    //
                    //                        VStack(alignment: .leading){
                    //
                    //                            Text(storyObj.questionList[questionNumber].question)
                    //                                .font(Font.custom("Arial Hebrew", size: 16))
                    //                                .bold()
                    //                                .padding([.leading, .trailing], 10 )
                    //                                .padding(.top, 5)
                    //                                .padding(.bottom, 10)
                    //
                    //
                    //                            radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                    //
                    //
                    //
                    //                        }
                    //                        .frame(width: 335, height: 210)
                    //                        .background(Color.white.opacity(0.95))
                    //                        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    //                        .cornerRadius(20, corners: [.topLeft, .topRight])
                    //                        .padding(.top, 415)
                    //                        .padding(.leading, 21)
                    //                        .zIndex(0)
                    //
                    //
                    //
                    //
                    //
                    //                    }
                    
                    NavigationLink(destination:  ShortStoryDragDropView(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: false, shortStoryName: chosenStoryNameIn),isActive: $showShortStoryDragDrop,label:{}
                    ).isDetailLink(false)
                }
                    
                
            }else{
                shortStoryViewIPAD(chosenStoryNameIn: chosenStoryNameIn)
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func handleURL(_ url: URL, name: String) -> OpenURLAction.Result {
        linkClickedString = name
        withAnimation(.easeIn(duration: 0.75)){
            showPopUpScreen.toggle()
        }
        return .handled
    }
    
}


struct popUpView: View{
    
    var storyObj: shortStoryObject
    
    @Binding var linkClickedString: String
    @Binding var showPopUpScreen: Bool
    
    var body: some View{
        
        let wordLink: WordLink = storyObj.collectWordExpl(ssO: storyObj, chosenWord: linkClickedString)
        
        
        
        ZStack{
            Button(action: {
                withAnimation(.easeIn(duration: 0.75)){
                    showPopUpScreen.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(width: 20, height: 20)

            }).offset(x: -115, y:-65).zIndex(1)
            VStack{
                
                
                Text(wordLink.infinitive)
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 25))
                    .foregroundColor(Color.black)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                    .underline()
                
                
                Text(wordLink.wordNameEng)
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .foregroundColor(Color.black)
                    .padding([.leading, .trailing], 5)
                
                
                if wordLink.explanation != "" {
                    Text(wordLink.explanation)
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                    
                    
                    
                }
                
                
                
            }.zIndex(1)
        }.frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
    }
}


struct radioButtonsMC: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    var totalQuestionCount: Int
    
    @State var correctChosen: Bool = false
    @Binding var questionNumber: Int
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    
    var body: some View{
        VStack {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctShortStoryButton(choice: choicesIn[i], totalQuestions: totalQuestionCount, questionNumber: $questionNumber, correctChosen: $correctChosen, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                        //.padding(.bottom, 5)
                } else {
                    incorrectShortStoryButton(choice: choicesIn[i], correctChosen: $correctChosen)
                        //.padding(.bottom, 5)
                }
            }
        }
        
        
    }
}

struct textModifer : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Hebrew", size: 18))
            .padding(.top, 40)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .lineSpacing(20)
        
    }
}


struct shortStoryView_Previews: PreviewProvider {
    static var previews: some View {
        shortStoryView(chosenStoryNameIn: "La Mia Introduzione", shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: "La Mia Introduzione"))
            .environmentObject(AudioManager())
    }
}


