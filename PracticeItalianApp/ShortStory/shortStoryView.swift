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
    
    @State var chosenStoryNameIn: String
    @State var progress: CGFloat = 0
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var storyHeight: CGFloat = 380
    
    @State var showShortStoryDragDrop = false
    
    @State var showEnglish = false
    
    @StateObject var shortStoryDragDropVM = ShortStoryDragDropViewModel(chosenStory: 0)
    
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
                            progress = (CGFloat(newValue) / 4)
                        }
                    
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
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
                        .frame(width: 20, height: 20)
                }).zIndex(2)
                    .offset(x:315, y: 80)

                if showPopUpScreen{
                    popUpView(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen).transition(.slide).animation(.easeIn).zIndex(2)
                        .offset(x: (geo.size.width / 9), y: (geo.size.height / 2) - 155)

                }
                
                VStack(spacing: 0){
                        ScrollView(.vertical, showsIndicators: false) {
                            Text("Cristofo Columbo")
                                .font(Font.custom("Arial Hebrew", size: 25))
                                .padding(.top, 30)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 210, height: 1)
                                    , alignment: .bottom
                                )
                            
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
                                    .font(Font.custom("Arial Hebrew", size: 16))
                                    .padding()
                                    .frame(width: geo.size.width - 37, height: 55)
                                    .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 9)
                                        .stroke(.black, lineWidth: 4))
                          
                                
                                radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                                    .padding(.top, 10)

                                
                                
                            }
                            .frame(width: geo.size.width - 60)
                            .background(Color("WashedWhite")).cornerRadius(2)
                            .overlay( RoundedRectangle(cornerRadius: 9)
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
                        if showQuestionDropdown && !showShortStoryDragDrop{

                            VStack(alignment: .leading){

                                    Text(storyObj.questionList[questionNumber].question)
                                        .font(Font.custom("Arial Hebrew", size: 16))
                                        .bold()
                                        .padding([.leading, .trailing], 10 )
                                        .padding(.top, 5)
                                        .padding(.bottom, 10)


                                radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)


                            }
                            .frame(width: 335, height: 210)
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


struct popUpView: View{
    
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
                    .frame(width: 40, height: 40)

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
                
                
                
            }.zIndex(0)
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
    
    @State var correctChosen: Bool = false
    @Binding var questionNumber: Int
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    
    var body: some View{
        VStack {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctShortStoryButton(choice: choicesIn[i], questionNumber: $questionNumber, correctChosen: $correctChosen, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress)
                } else {
                    incorrectShortStoryButton(choice: choicesIn[i], correctChosen: $correctChosen)
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
        shortStoryView(chosenStoryNameIn: "Cristofo Columbo")
            .environmentObject(AudioManager())
    }
}


