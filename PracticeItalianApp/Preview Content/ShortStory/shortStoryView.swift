//
//  shortStoryView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/5/23.
//

import SwiftUI


extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

struct shortStoryView: View {
    
    @State var chosenStoryNameIn: String
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var storyHeight: CGFloat = 380
    
    var storyData: shortStoryData { shortStoryData(chosenStoryName: chosenStoryNameIn)}
    
    var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
    
    
    var body: some View {
        
        
        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                customTopNavBar3(chosenStoryNameIn: chosenStoryNameIn).offset(y: -350)
                
                if showPopUpScreen{
                    popUpView(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen).transition(.slide).animation(.easeIn).zIndex(1)
                        .padding(.bottom, 60)
                        .padding(.trailing, 15)
                }
                
                VStack{
                    
                    testStory(shortStoryObj: self.storyObj, showPopUpScreen: self.$showPopUpScreen, linkClickedString: self.$linkClickedString, showQuestionDropdown: self.$showQuestionDropdown, storyHeight: self.$storyHeight).padding(.top, 100)
                    
                    
                    questionsDropDownBar(storyObj: storyObj, showQuestionDropdown: self.$showQuestionDropdown, questionNumber: self.$questionNumber)
                        .padding(.top, 10)
                    
                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}
    
    
    
    
    
    
    struct testStory: View{
        
        var shortStoryObj: shortStoryObject
        
        @Binding var showPopUpScreen: Bool
        @Binding var linkClickedString: String
        @Binding var showQuestionDropdown: Bool
        @Binding var storyHeight: CGFloat
        
        var body: some View{
            
            let storyString: String = shortStoryObj.storyString
            
            
            ScrollView(.vertical, showsIndicators: false) {
                    
                Text(.init(storyString))
                        .modifier(textModifer())
                        .environment(\.openURL, OpenURLAction { url in
                            handleURL(url, name: url.valueOf("word")!)

                        })
                
               
                }.frame(width: 350, height: showQuestionDropdown ? storyHeight : 550).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 6)).padding(.trailing, 18)
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
            
            
            
            ZStack(alignment: .leading){
                Button(action: {
                    showPopUpScreen.toggle()
                }, label: {
                    Image("popUpX")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.bottom, 140)
                        .padding(.leading, 5)
                })
                VStack{
                    
                    
                    Text(wordLink.infinitive)
                        .bold()
                        .font(Font.custom("Arial Hebrew", size: 25))
                        .foregroundColor(Color.black)
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                    
                    
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
                    
                    
                    
                }
            }.frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
            
        }
    }
    
    struct questionsDropDownBar: View{
        
        var storyObj: shortStoryObject
        
        @Binding var showQuestionDropdown: Bool
        @Binding var questionNumber: Int

        var body: some View{
                VStack{
                    HStack{
                        HStack{
                            Text("Question")
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .padding(.leading, 30)
                                .padding(.top, 6)
                            
                            Spacer()
                            
                            Text(String(questionNumber + 1) + "/4")
                                .font(Font.custom("Arial Hebrew", size: 26))
                                .padding(.top, 6)
                                .padding(.trailing, 20)
                            
                        }.frame(width: 330, height: 40, alignment: .leading)
                            .background(Color.white)
                            .border(width: 5, edges: [.leading, .top, .bottom], color: .teal).cornerRadius(6)
                        
                        Button(action: {
                            showQuestionDropdown.toggle()
                        }, label: {
                            Image("downArrow3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }).offset(x:-19)
                    }.padding(.leading, 10).zIndex(1)
                    
                    
                    if showQuestionDropdown {
                        questionsView(storyObj: storyObj, questionNumber: $questionNumber).offset(y:-20).zIndex(0)
                    }
                }
                
            }
            
    }
    
    struct questionsView: View {
        
        
        var storyObj: shortStoryObject
        
        @Binding var questionNumber: Int
        
        var body: some View {
            ZStack{
                VStack(alignment: .leading){
                    Text(storyObj.questionList[questionNumber].question)
                        .font(Font.custom("Arial Hebrew", size: 17))
                        .bold()
                        .padding([.leading, .trailing], 10 )
                        .padding(.top, 5)
                        .padding(.bottom, 10)

                    
                    radioButtons(storyObj: storyObj, questionNumber: $questionNumber)
                }.frame(width: 360, height: 210)
                    .background(Color.white.opacity(0.95)).cornerRadius(5)
                    .border(width: 3, edges: [.leading, .trailing, .bottom], color: .black)
                    .padding(.trailing, 26)

            }
        }
    }
    
    struct radioButtons: View{
        
        var storyObj: shortStoryObject
        
        @Binding var questionNumber: Int
        
        var body: some View{
            VStack{

                radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), questionNumber: $questionNumber)
                
            }
        }
    }
    
    struct radioButtonsMC: View {
        
        var correctAnswer: String
        var choicesIn: [String]
        
        @State var correctChosen: Bool = false
        @Binding var questionNumber: Int
        
        var body: some View{
            VStack {
                ForEach(0..<choicesIn.count, id: \.self) { i in
                    if choicesIn[i].elementsEqual(correctAnswer) {
                        correctShortStoryButton(choice: choicesIn[i], questionNumber: $questionNumber, correctChosen: $correctChosen)
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
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(20)
            
        }
    }
    
    struct customTopNavBar3: View {
        
        var chosenStoryNameIn: String
        
        var body: some View {
            ZStack{
                HStack{
                    NavigationLink(destination: availableShortStories(), label: {Image("cross")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, 10)
                    })
                    
                    Spacer()
                    
                    Text(chosenStoryNameIn)
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .bold()
                        .padding(.top, 7)
                        .padding(.trailing, 10)
                    
                    Spacer()
                    
                    NavigationLink(destination: chooseActivity(), label: {Image("house")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.5)
                            .padding([.top, .bottom], 15)
                            .padding(.trailing, 38)
                           
                    })
                }
            }.frame(width: 410, height: 60)
                .background(Color.gray.opacity(0.25))
                .border(width: 3, edges: [.bottom, .top], color: .teal)
                        
        }
    }
    
    
    struct shortStoryView_Previews: PreviewProvider {
        static var previews: some View {
            shortStoryView(chosenStoryNameIn: "Cristofo Columbo")
        }
    }


