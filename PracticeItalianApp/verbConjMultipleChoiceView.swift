//
//  verbConjMultipleChoiceView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI

struct verbConjMultipleChoiceView: View{
    
    var tenseIn: Int
    
    @State private var pressed = false
    
    var body: some View {
        
        let mcD = multipleChoiceData(tense: tenseIn)
        
        let mcO: multipleChoiceObject = mcD.collectMultipleChoiceData(tense: mcD.tense)
        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                VStack{
                    
                    customTopNavBar4(tenseIn: tenseIn, tenseName: mcO.tenseName).position(x:200, y:40)
  
                    multipleChoiceViewButtons(verbNameIt: mcO.verbNameIt, verbNameEng: mcO.verbNameEng, choices: mcO.choiceList.shuffled(), pickPronoun: mcO.pronoun, correctAnswer: mcO.correctAnswer, tense: tenseIn).offset(y:-250)
                    
                }
            }
        }
    }
    
    struct multipleChoiceViewButtons: View{
        
        var verbNameIt: String
        var verbNameEng: String
        var choices: [String]
        var pickPronoun: String
        var correctAnswer: String
        var tense: Int
        
        @State var pressed = false
        
        var body: some View{
            
            VStack{
                Text(verbNameIt + " - " + pickPronoun + "\n(" + verbNameEng + ")")
                    .bold()
                    .frame(width:240, height: 75)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .shadow(radius: 10)
                
                choicesView(choicesIn: choices, correctAnswerIn: correctAnswer)
                
                mChoiceNextButton(tense: tense).padding(.top, 20)
            }
            
        }
    }
    
    
    struct choicesView: View{
        
        var choicesIn: [String]
        var correctAnswerIn: String
        
        var body: some View{
            HStack{
                multipleChoiceButton(choiceString: choicesIn[0], correctAnswer: correctAnswerIn)
                multipleChoiceButton(choiceString: choicesIn[1], correctAnswer: correctAnswerIn)
            }
            HStack{
                multipleChoiceButton(choiceString: choicesIn[2], correctAnswer: correctAnswerIn)
                multipleChoiceButton(choiceString: choicesIn[3], correctAnswer: correctAnswerIn)
            }
            HStack{
                multipleChoiceButton(choiceString: choicesIn[4], correctAnswer: correctAnswerIn)
                multipleChoiceButton(choiceString: choicesIn[5], correctAnswer: correctAnswerIn)
            }
            
        }
    }
    
    
    struct multipleChoiceButton: View{
        
        var choiceString: String
        var correctAnswer: String
        
        
        @State var defColor = Color.blue
        @State private var pressed: Bool = false
        
        var body: some View{
            
            let isCorrect: Bool = choiceString.elementsEqual(correctAnswer)
            
            Button(choiceString, action: {
                
            })
            .frame(width:180, height: 40)
            .background(defColor)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.trailing, 5)
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.pressed = pressing
                }
                if pressing {
                    if isCorrect {
                        defColor = Color.green
                    }else {
                        defColor = Color.red
                    }
                } else {
                    
                }
            }, perform: { })
        }
    }
    
    struct mChoiceNextButton: View{
        
        
        var tense: Int
        
        @State var pressed = false
        
        var body: some View{
            
            
            NavigationLink(destination: verbConjMultipleChoiceView(tenseIn: tense), label: {Text ("Next")
                    .bold()
                    .frame(width: 150, height: 40)
                    .background(Color.teal)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            })
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    struct customTopNavBar4: View {
        
        var tenseIn: Int
        var tenseName: String
        
        var body: some View {
            ZStack{
                HStack{
                    NavigationLink(destination: chooseVCActivity(tense: tenseIn), label: {Image("cross")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, 20)
                    })
                    
                    Spacer()
                    
                    Text(tenseName)
                        .bold()
                        .font(Font.custom("Zapfino", size: 18))
                    
                    Spacer()
                    
                    NavigationLink(destination: chooseActivity(), label: {Image("house")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.5)
                            .padding([.top, .bottom], 15)
                            .padding(.trailing, 38)
                           
                    })
                }.zIndex(1)
            }.frame(width: 400, height: 60)
                .background(Color.gray.opacity(0.25))
                .border(width: 3, edges: [.bottom, .top], color: .teal)
                .zIndex(0)
                        
        }
    }
    
    
    struct verbConjMultipleChoice_Previews: PreviewProvider {
        static var previews: some View {
            verbConjMultipleChoiceView(tenseIn: 0)
        }
    }
    
}
