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
                HStack{
                   
                        
                        Button(action: {
                        }, label: {
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.black)
                                .font(.system(size:35, weight: .medium))
                                .padding(.leading, 10)

                        })
                      
                        Spacer()
                    
                 
                        Text(chosenStoryNameIn)
                            .font(Font.custom("Arial Hebrew", size: 30))
                            .padding(.trailing, 55)
                            .offset(y:5)
 
                        Spacer()
                    

                }.frame(width: UIScreen.main.bounds.width, height: 50).background(Color.teal.opacity(0.3))
                    .offset(y: -330)
                
                testStory(shortStoryObj: self.storyObj, showPopUpScreen: self.$showPopUpScreen, linkClickedString: self.$linkClickedString).frame(width: 350, height:380).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 6))
                    .shadow(radius: 10)
                    .offset(x: -1, y:-95)
                
                if showPopUpScreen{
                    popUpView(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen).transition(.slide).animation(.easeIn)
                }
                
                questionsDropDownBar(showQuestionDropdown: self.$showQuestionDropdown, questionNumber: self.$questionNumber).padding([.leading, .trailing], 5).offset(y:130)
                
                if showQuestionDropdown{
                    questionsView(storyObj: self.storyObj, questionNumber: self.$questionNumber).padding([.leading, .trailing], 5).offset(y:270).transition(.move(edge: .bottom)).animation(.spring())
                }

            }
        }.navigationBarBackButtonHidden(true)
    }
    
    
    
    
    
    
    struct testStory: View{
        
        var shortStoryObj: shortStoryObject
        
        @Binding var showPopUpScreen: Bool
        @Binding var linkClickedString: String
        
        var body: some View{
            
            let storyString: String = shortStoryObj.storyString
            
            
            ScrollView(.vertical, showsIndicators: false) {
                    
                Text(.init(storyString))
                        .modifier(textModifer())
                        .environment(\.openURL, OpenURLAction { url in
                            handleURL(url, name: url.valueOf("word")!)

                        })
                
               
                }
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
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                        .scaledToFit()
                        .scaleEffect(1.75)
                }).position(x:30, y:30)
               
                VStack{
                    Text(wordLink.infinitive)
                        .bold()
                        .font(Font.custom("Arial Hebrew", size: 25))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 55)
                    
                    Spacer()
                    
                    Text(wordLink.wordNameEng)
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .foregroundColor(Color.black)
                        .padding([.leading, .trailing], 24)
                    
                    Spacer()
                    
                    if wordLink.explanation != "" {
                        Text(wordLink.explanation)
                            .font(Font.custom("Arial Hebrew", size: 20))
                            .foregroundColor(Color.black)
                            .padding([.leading, .trailing], 24)
                        
                        Spacer()
                    }
                }
                
            
            }.frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .offset(y:-90)
   
        }
    }
    
    struct questionsDropDownBar: View{
        
        @Binding var showQuestionDropdown: Bool
        @Binding var questionNumber: Int

        var body: some View{
            
            ZStack{
                HStack{
                    
                    Text("Question")
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .padding(.leading, 30)
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    Text(String(questionNumber + 1) + "/4")
                        .font(Font.custom("Arial Hebrew", size: 26))
                        .padding(.top, 5)
                        .padding(.leading, 90)

                    Spacer()
                    
                    Button(action: {
                        showQuestionDropdown.toggle()
                    }, label: {
                        Image(systemName: "chevron.down.square.fill")
                            .scaleEffect(2.8)
                    }).padding(.trailing, 10)
                    
                    
                }.frame(width: 360, height: 40, alignment: .leading)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 3)
                        .stroke(.gray, lineWidth: 3).padding(.trailing, 40))
    
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
                        .font(Font.custom("Arial Hebrew", size: 18))
                        .padding([.leading, .top], 20)

                    
                    radioButtons(storyObj: storyObj, questionNumber: $questionNumber)
                }.frame(width: 360, height: 230)
                    .background(Color.white).cornerRadius(3)
                    .zIndex(1)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(1))
                        .frame(width: 368, height: 235).padding(.top, 10).cornerRadius(10)
                        .zIndex(0)
                        
                
            }
        }
    }
    
    struct radioButtons: View{
        
        var storyObj: shortStoryObject
        
        @Binding var questionNumber: Int
        
        var choices: [String] = ["True", "False"]
        
        var body: some View{
            VStack{
                
                if storyObj.questionList[questionNumber].mC == true {
                    radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled())
                }else{
                    radioButtonsTF(choices: choices.shuffled(), correctAnswer: storyObj.questionList[questionNumber].answer)
                }

                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        if questionNumber != 0 {
                            questionNumber = questionNumber - 1
                        }
                    }, label: {
                        Image(systemName: "chevron.backward.to.line")
                            .scaleEffect(1.75)
                        
                    }).padding(.trailing, 25)
                    
                    
                    Button(action: {
                        if questionNumber != 3 {
                            questionNumber = questionNumber + 1
                        }
                    }, label: {
                        Image(systemName: "chevron.forward.to.line")
                            .scaleEffect(1.75)
                        
                    }).padding(.leading, 25)
                    
                    Spacer()
                    
                }.offset(y:-16)
                    .padding([.top, .bottom], 5)
            }
        }
    }
    
    struct radioButtonsMC: View {
        
        var correctAnswer: String
        var choicesIn: [String]
        
        var body: some View{
            
            multipleChoiceButton(correctAnswer: correctAnswer, choice: choicesIn[0])
            
            Spacer()
            
            multipleChoiceButton(correctAnswer: correctAnswer, choice: choicesIn[1]).offset(y:-8)
            
            Spacer()
            
            multipleChoiceButton(correctAnswer: correctAnswer, choice: choicesIn[2]).offset(y:-16)
            
            Spacer()
        }
    }
    
    struct radioButtonsTF: View {
        
        var choices: [String]
        var correctAnswer: String
        
        var body: some View {
           
            trueFalseButton(correctAnswer: correctAnswer, choice: choices[0]).padding(.top, 10)
            
            Spacer()
            
            trueFalseButton(correctAnswer: correctAnswer, choice: choices[1]).offset(y: -10)
            
            Spacer()
            
        }
    }
    
    struct multipleChoiceButton: View {
        
        var correctAnswer: String
        var choice: String
        
        @State var selectionColor = Color.green
        @State var colorOpacity = 0.0
        @State var chosenOpacity = 0.0
        @State private var pressed: Bool = false
        
        var body: some View{
            
            let isCorrect = choice.elementsEqual(correctAnswer)

            Button(action: {}, label: {
                
                HStack{
                    Text(choice)
                    
                    Spacer()
                    
                    Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                    
                }.padding([.leading, .trailing], 10)
            })
            .frame(width:340, height: 40)
            .background(selectionColor.opacity(colorOpacity))
            .foregroundColor(Color.black)
            .cornerRadius(5)
            .scaleEffect(pressed ? 1.10 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.spring()) {
                    self.pressed = pressing
                }
                if pressing {
                    if colorOpacity == 0.4 {
                        colorOpacity = 0.0
                        chosenOpacity = 0.0
                    } else {
                        if isCorrect {
                            selectionColor = Color.green
                            chosenOpacity = 1.0
                            colorOpacity = 0.4
                        }else {
                            selectionColor = Color.red
                            chosenOpacity = 1.0
                            colorOpacity = 0.4
                        }
                    }
                } else {
                    
                }
            }, perform: { })
            
            
        }
        
    }
    
    struct trueFalseButton: View {
        
        var correctAnswer: String
        var choice: String
        
        @State var selectionColor = Color.green
        @State var colorOpacity = 0.0
        @State var chosenOpacity = 0.0
        @State private var pressed: Bool = false
        
        var body: some View {
            let isCorrect = choice.elementsEqual(correctAnswer)

            Button(action: {}, label: {
                
                HStack{
                    Text(choice)
                    
                    Spacer()
                    
                    Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                    
                }.padding([.leading, .trailing], 10)
            })
            .frame(width:340, height: 40)
            .background(selectionColor.opacity(colorOpacity))
            .foregroundColor(Color.black)
            .cornerRadius(5)
            .scaleEffect(pressed ? 1.10 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.spring()) {
                    self.pressed = pressing
                }
                if pressing {
                    if colorOpacity == 0.4 {
                        colorOpacity = 0.0
                        chosenOpacity = 0.0
                    } else {
                        if isCorrect {
                            selectionColor = Color.green
                            chosenOpacity = 1.0
                            colorOpacity = 0.4
                        }else {
                            selectionColor = Color.red
                            chosenOpacity = 1.0
                            colorOpacity = 0.4
                        }
                    }
                } else {
                    
                }
            }, perform: { })
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
    
    
    struct shortStoryView_Previews: PreviewProvider {
        static var previews: some View {
            shortStoryView(chosenStoryNameIn: "Cristofo Columbo")
        }
    }
}

