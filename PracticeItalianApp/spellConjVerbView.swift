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
    @State var checkToContinue = false
    @State var correctAnswer: String = "" //need to assign correct answer
    
    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack{
                    
                    Text("Presente")
                        .bold()
                        .font(Font.custom("Zapfino", size: 18))
                        .frame(width:400, height: 75)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 10)
                        .position(x:200, y:75)
                    
                    spellVerbActivityWordToSpellView(tense: self.$tense)
                    spellVerbActivityViewBuilder(userAnswer: self.$userAnswer)
                    
                    if !checkToContinue{
                        spellVerbCheckAnswerButton(tenseIn: self.$tense, correctAnswer: self.$correctAnswer, userInput: self.$userAnswer, checkToContinue: self.$checkToContinue)
                    } else{
                        NavigationLink(destination: spellConjVerbView(tense: tense), label: {Text ("Continue")
                                .bold()
                                .frame(width: 280, height: 50)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        })
                    }
                    
                }
                
            }
        }
    }
    
    struct spellVerbActivityWordToSpellView: View{
        
        @Binding var tense: Int
        
        var body: some View{
            
            let svD = spellVerbData(tense: tense)
            let svO: spellVerbObject = svD.collectSpellVerbData(tense: svD.tense)
            
            ZStack{
                VStack{
                    Text(svO.verbNameIt + " - " + svO.pronoun + "\n(" + svO.verbNameEng + ")")
                        .bold()
                        .font(Font.custom("Marker Felt", size: 23))
                        .frame(width:260, height: 100)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 10)
                        .zIndex(1)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.40))
                        .cornerRadius(20)
                        .frame(width: 320, height:300)
                        .position(x: 200, y: -100)
                }

                
            }
                
        }
    }
    
    
    struct spellVerbActivityViewBuilder: View {
        
        @Binding var userAnswer: String
        
        var body: some View{
            
            VStack{
                
                TextField("", text: $userAnswer)
                    .background(Color.brown.cornerRadius(10))
                    .opacity(0.35)
                    .padding()
                    .font(Font.custom("Marker Felt", size: 50))
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
 
            }
        }
    }
    
    struct spellVerbCheckAnswerButton2: View {
        
        @Binding var tenseIn: Int

        var body: some View{
            
            NavigationLink(destination: spellConjVerbView(tense: tenseIn), label: {Text ("Continue")
                    .bold()
                    .frame(width: 280, height: 50)
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
     
            })
        }
    }
    
    
    struct spellVerbCheckAnswerButton: View{
        
        @Binding var tenseIn: Int
        @Binding var correctAnswer: String
        @Binding var userInput: String
        @Binding var checkToContinue: Bool
        
        
        @State var defColor = Color.blue
        @State private var pressed: Bool = false
        
        var body: some View{
            
            
            let isCorrect: Bool = userInput.elementsEqual(correctAnswer)
            
            Button("Check", action: {
                
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
                        checkToContinue.toggle()
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

