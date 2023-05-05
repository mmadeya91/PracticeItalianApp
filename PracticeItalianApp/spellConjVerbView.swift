//
//  spellConjVerbView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI

struct spellConjVerbView: View {
    
    @State var tense: Int
    @State var tenseString: String = ""
    @State var userAnswer: String = ""
    @State var rightOrWrongLabel: String = "placeholder"
    @State var checkToContinue = false
    @State var rightWrongOpacity = 0

    
    var body: some View {
        
        let svD = spellVerbData(tense: tense)
        let svO: spellVerbObject = svD.collectSpellVerbData(tense: svD.tense)
        let findCorrectAnswer = svO.correctAnswer
        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                VStack{
                    NavigationLink(destination: ContentView(), label: {Text ("Home")
                            .bold()
                            .frame(width:180, height: 40)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }).navigationBarBackButtonHidden(true)
                    
                    Text("Presente")
                        .bold()
                        .font(Font.custom("Zapfino", size: 18))
                        .frame(width:400, height: 75)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 10)
                        .position(x:200, y:75)
                    
                    
                    spellVerbActivityWordToSpellView(verbNameIt: svO.verbNameIt, pronoun: svO.pronoun, verbNameEng: svO.verbNameEng, tense: self.$tense, rightOrWrongLabel: self.$rightOrWrongLabel, rightWrongOpacity: self.$rightWrongOpacity).position(x:200, y:120)
                    
                    spellVerbActivityViewBuilder(userAnswer: self.$userAnswer).position(x:200, y:275)
                    
                    spellVerbCheckAnswerButton(foundCorrectAnswer: findCorrectAnswer, tenseIn: self.$tense, userInput: self.$userAnswer, checkToContinue: self.$checkToContinue, rightOrWrongLabel: self.$rightOrWrongLabel, rightWrongOpacity:     self.$rightWrongOpacity).position(x:200, y:255)

                    skipButton(tense: self.$tense).position(x:290, y:140)
                }
            }
        }
    }
    
    struct spellVerbActivityWordToSpellView: View{
        
        var verbNameIt: String
        var pronoun: String
        var verbNameEng: String
        
        @Binding var tense: Int
        @Binding var rightOrWrongLabel: String
        @Binding var rightWrongOpacity: Int
        
        var body: some View{
            
            ZStack{
                VStack{
                    Text(verbNameIt + " - " + pronoun + "\n(" + verbNameEng + ")")
                        .bold()
                        .font(Font.custom("Marker Felt", size: 23))
                        .frame(width:260, height: 100)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 10)
                        .offset(y:100)
                        .zIndex(2)
                    
                    Text(rightOrWrongLabel)
                        .font(Font.custom("Marker Felt", size: 35))
                        .foregroundColor(Color.black)
                        .offset(y: 120)
                        .opacity(rightWrongOpacity)
                        .zIndex(1)
                    

                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.40))
                        .cornerRadius(20)
                        .frame(width: 320, height:220)
                        .offset(y:-90)
                        .zIndex(0)
                        
                }

                
            }
                
        }
    }
    
    
    struct spellVerbActivityViewBuilder: View {
        
        @Binding var userAnswer: String
        
        var body: some View{
            
            VStack{
                
                TextField("", text: $userAnswer)
                    .background(Color.white.cornerRadius(10))
                    .opacity(0.35)
                    .font(Font.custom("Marker Felt", size: 50))
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                    .offset(y: -140)
                    .padding()
            }.ignoresSafeArea(.keyboard)
        }
    }

    
    struct spellVerbCheckAnswerButton: View{
        
        var foundCorrectAnswer: String
        
        @Binding var tenseIn: Int
        @Binding var userInput: String
        @Binding var checkToContinue: Bool
        @Binding var rightOrWrongLabel: String
        @Binding var rightWrongOpacity: Int
        
        
        @State var defColor = Color.blue
        @State private var pressed: Bool = false
        
        var body: some View{
            
            let isCorrect: Bool = userInput.elementsEqual(foundCorrectAnswer)
            
            if !checkToContinue{
                Button("Check", action: {
                    if isCorrect {
                        defColor = Color.green
                        rightOrWrongLabel = "Correct!"
                        rightWrongOpacity = 1
                        checkToContinue.toggle()
                    }else {
                        defColor = Color.red
                        rightOrWrongLabel = "Try Again!"
                        rightWrongOpacity = 1
                    }
                })
                .font(Font.custom("Marker Felt", size:  18))
                .frame(width:180, height: 40)
                .background(defColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.trailing, 5)
                .offset(y:-195)
                .scaleEffect(pressed ? 1.25 : 1.0)
                .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.75)) {
                        self.pressed = pressing
                    }
                    if pressing {
                        
                    } else {
           
                    }
                }, perform: { })
            }else {
                NavigationLink(destination: spellConjVerbView(tense: tenseIn), label: {Text ("Continue")
                        .bold()
                        .font(Font.custom("Marker Felt", size: 18))
                        .frame(width:180, height: 40)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                }).navigationBarBackButtonHidden(true).position(x:200, y:-125)
            }
            
        }
    }
                    
    
    struct skipButton: View {
        
        @Binding var tense: Int
        
        var body: some View{
            NavigationLink(destination: spellConjVerbView(tense: tense), label: {Text ("Skip")
                    .bold()
                    .font(Font.custom("Marker Felt", size: 18))
                    .frame(width:125, height: 35)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }).navigationBarBackButtonHidden(true)
            
        }
    }
    
    struct spellConjVerbView_Previews: PreviewProvider {
        static var previews: some View {
            spellConjVerbView(tense: 0)
        }
    }
}

