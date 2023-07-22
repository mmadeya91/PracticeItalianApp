//
//  SpellConjugatedVerbView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/27/23.
//

import SwiftUI

struct SpellConjugatedVerbView: View {
    
    @ObservedObject var spellConjVerbVM: SpellConjVerbViewModel
    
    @State var progress: CGFloat = 0

    @State var userAnswer: String = ""
    @State var currentQuestionNumber = 0
    @State var pressed = false
    @State var selected = false
    @State var hintGiven: Bool = false
    @State var hintButtonText = "Give me a Hint!"
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        ScrollViewReader {scrollView in
            GeometryReader{ geo in
                
                ZStack{
                    Image("homeWallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .opacity(1.0)
                    VStack{
                        NavBar().padding([.leading, .trailing], 20)
                        VStack{
                            
                            Text(getTenseString(tenseIn: spellConjVerbVM.currentTense))
                            
                            Spacer()
                            
                            ScrollView(.horizontal) {
                                HStack{
                                    ForEach(0..<spellConjVerbVM.currentTenseSpellConjVerbData.count, id: \.self) {i in
                                        questionView(vbItalian: spellConjVerbVM.currentTenseSpellConjVerbData[i].verbNameItalian, vbEnglish: spellConjVerbVM.currentTenseSpellConjVerbData[i].verbNameEnglish, pronoun: spellConjVerbVM.currentTenseSpellConjVerbData[i].pronoun).padding(.leading, 10)
                                    }
                                    
                                }
                            }
                            
                            Spacer()
                            
                            HStack{
                                
                                ForEach($spellConjVerbVM.currentHintLetterArray, id: \.self) { $answerArray in
                                    Text(answerArray.letter)
                                        .font(Font.custom("Chalkboard SE", size: 25))
                                        .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                                        .underline(color: .black)
                                    
                                }
                                
                            }.frame(width:200, height: 40)
                                .padding(.bottom, 30)
                        }.frame(width: 330, height: 280)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.top, 60)
                        
                        
                        VStack{
                            
                            TextField("", text: $userAnswer)
                                .background(Color.white.cornerRadius(10))
                                .font(Font.custom("Marker Felt", size: 50))
                                .shadow(color: Color.black, radius: 12, x: 0, y:10)
                                .padding()
                            HStack{
                                Button(action: {
                                    if  userAnswer.lowercased().elementsEqual(spellConjVerbVM.currentTenseSpellConjVerbData[currentQuestionNumber].correctAnswer.lowercased()) {
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            currentQuestionNumber += 1
                                            
                                            progress = (CGFloat(currentQuestionNumber) / CGFloat(spellConjVerbVM.currentTenseSpellConjVerbData.count))
                                            
                                            spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[currentQuestionNumber].hintLetterArray)
                                            withAnimation(.easeInOut(duration: 5)) {
                                                scrollView.scrollTo(currentQuestionNumber)
                                            }
                                            
                                            hintGiven = false
                                            hintButtonText = "Give me a Hint!"
                                            userAnswer = ""
                                        }
        
                                        SoundManager.instance.playSound(sound: .correct)
                                        
                                    }else {
                                        selected.toggle()
                                        SoundManager.instance.playSound(sound: .wrong)
                                    }
                                }, label: {
                                    Text("Check")
                                    
                                }).font(Font.custom("Marker Felt", size:  18))
                                    .frame(width:180, height: 40)
                                    .background(Color.teal)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .offset(x: selected ? -5 : 0)
                                    .shadow(radius: 10)
                                    .padding(.trailing, 5)
                                    .scaleEffect(pressed ? 1.25 : 1.0)
                                    .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                                        withAnimation(.easeInOut(duration: 0.75)) {
                                            self.pressed = pressing
                                        }
                                    }, perform: { })
                                
                                Button(action: {
                                    
                                    let currentHLACount = spellConjVerbVM.currentHintLetterArray.count
                                    
                                    if !hintGiven {
                                        var array = [Int](0...currentHLACount-1)
                                        array.shuffle()
                                        if currentHLACount == 1 {
                                            spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        }
                                        if currentHLACount == 2 {
                                            spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                            spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        }
                                        
                                        if currentHLACount > 2 {
                                            spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                            spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                            spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        }
                                        
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }else{
                                        
                                        spellConjVerbVM.showHint()
                                    }
                                    
                                }, label: {
                                    
                                    Text(hintButtonText)
                                        .font(Font.custom("Chalkboard SE", size: 18))
                                        .foregroundColor(.white)
                                    
                                }).frame(width: 150, height: 40)
                                    .background(.blue)
                                    .cornerRadius(15)
                                    .padding(.top, 20)
                                    .padding(.bottom, 26)
                            }
                        }.padding(.top, 80)
                            .padding([.leading, .trailing], 15)
                    }
                    
                    
                    
                }
            }
        }
    }
    @ViewBuilder
    func NavBar() -> some View{
        HStack(spacing: 18){
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
                
            })
            
            GeometryReader{proxy in
                      ZStack(alignment: .leading) {
                         Capsule()
                             .fill(.gray.opacity(0.25))
                          
                          Capsule()
                              .fill(Color.green)
                              .frame(width: proxy.size.width * progress)
                      }
                  }.frame(height: 20)
            
            Button(action: {}, label: {
                Image(systemName: "suit.heart.fill")
                    .font(.title3)
                    .foregroundColor(.gray)
                
            })
        }
    }
    
    func getTenseString(tenseIn: Int)->String{
        switch tenseIn {
        case 0:
            return "Presente"
        case 1:
            return "Passato Prossimo"
        case 2:
            return "Futuro"
        case 3:
            return "Imperfetto"
        case 4:
            return "Presente Condizionale"
        case 5:
            return "Imperativo"
        default:
            return "No Tense"
        }
    }
    
}



struct questionView: View {
    var vbItalian: String
    var vbEnglish: String
    var pronoun: String
    var body: some View {
        
        Text(vbItalian + " - " + pronoun + "\n(" + vbEnglish + ")")
            .bold()
            .font(Font.custom("Marker Felt", size: 23))
            .frame(width:275, height: 110)
            .background(Color.teal)
            .cornerRadius(10)
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing], 15)
    }
}


struct SpellConjugatedVerbView_Previews: PreviewProvider {
    static var _spellConjVerbVM = SpellConjVerbViewModel()
    static var previews: some View {
        SpellConjugatedVerbView(spellConjVerbVM: _spellConjVerbVM)
    }
}
