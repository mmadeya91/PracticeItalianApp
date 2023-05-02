//
//  spellConjVerbView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI

struct spellConjVerbView: View {
    
    var tense: Int
    
    var body: some View {
        
        let svD = spellVerbData(tense: tense)
        
        let svO: spellVerbObject = svD.collectSpellVerbData(tense: svD.tense)
        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack{
                    
                    Text(svO.tenseName)
                        .bold()
                        .font(Font.custom("Zapfino", size: 18))
                        .frame(width:400, height: 75)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 10)
                        .position(x:200, y:75)
                    
                }
                
                spellVerbActivityWordToSpellView(verbNameIt: svO.verbNameIt, pronoun: svO.pronoun, verbNameEng: svO.verbNameEng, correctAnswer: svO.correctAnswer, tense: tense)
                    
            }
        }
    }
    
    struct spellVerbActivityWordToSpellView: View{
        
        var verbNameIt: String
        var pronoun: String
        var verbNameEng: String
        var correctAnswer: String
        var tense: Int
        
        var body: some View{
            ZStack{
                Text(verbNameIt + " - " + pronoun + "\n(" + verbNameEng + ")")
                    .bold()
                    .font(Font.custom("Marker Felt", size: 23))
                    .frame(width:260, height: 100)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 250)
                    .shadow(radius: 10)
                    .zIndex(1)
              
                    Rectangle()
                        .fill(Color.gray.opacity(0.40))
                        .cornerRadius(20)
                        .frame(width: 320, height:300)
                        .position(x:200, y:300)
                        
                
                
            }
                
            
            VStack{
                spellVerbActivityViewBuilder(tense: tense, correctAnswer: correctAnswer)
            }.position(x:200, y:550)
        }
    }
    
    
    struct spellVerbActivityViewBuilder: View {
        
        var tense: Int
        var correctAnswer: String
        
        @State var userAnswer: String = ""
        
        var body: some View{
            
            VStack{
                
                TextField("", text: $userAnswer)
                    .background(Color.brown.cornerRadius(10))
                    .opacity(0.35)
                    .padding()
                    .font(Font.custom("Marker Felt", size: 50))
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                
                spellVerbCheckAnswerButton2(tenseIn: tense, correctAnswer: correctAnswer, userInput: userAnswer)
            }
        }
    }
    
    struct spellVerbCheckAnswerButton2: View {
        var tenseIn: Int
        var correctAnswer: String
        var userInput: String
        
        
        @State var defColor = Color.blue
        @State var checkToContinue = "Check"
        @State private var pressed: Bool = false
        @State private var disable: Bool = false
        var body: some View{
            
            let isCorrect: Bool = userInput.elementsEqual(correctAnswer)
            
            NavigationLink(destination: spellConjVerbView(tense: tenseIn), label: {Text (checkToContinue)
                    .bold()
                    .frame(width: 280, height: 50)
                    .background(defColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                        withAnimation(.easeInOut(duration: 0.75)) {
                            self.pressed = pressing
                        }
                        if pressing {
                            if isCorrect {
                                defColor = Color.green
                                checkToContinue = "Continue"
                            }else {
                                defColor = Color.red
                                disable = true
                            }
                        } else {
                            
                        }
                    }, perform: { })
                    .disabled(!disable)
            })
        }
    }
    
    
    struct spellVerbCheckAnswerButton: View{
        
        var tenseIn: Int
        var correctAnswer: String
        var userInput: String
        
        
        @State var defColor = Color.blue
        @State var checkToContinue = "Check"
        @State private var pressed: Bool = false
        
        var body: some View{
            
            
            let isCorrect: Bool = userInput.elementsEqual(correctAnswer)
            
    
            Button(checkToContinue, action: {
                
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
                        checkToContinue = "Continue"
                    }else {
                        defColor = Color.red
                    }
                } else {
                    
                }
            }, perform: { })
        }
    }
    
    struct spellConjVerbView_Previews: PreviewProvider {
        static var previews: some View {
            spellConjVerbView(tense: 0)
        }
    }
}

