//
//  SpellConjugatedVerbView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/27/23.
//

import SwiftUI
import CoreData

struct SpellConjugatedVerbView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var spellConjVerbVM: SpellConjVerbViewModel
    
    @State var progress: CGFloat = 0

    @State var userAnswer: String = ""
    @State var currentQuestionNumber = 0
    @State var pressed = false
    @State var selected = false
    @State var hintGiven: Bool = false
    @State var hintButtonText = "Give me a Hint!"
    @State var animatingBear = false
    @State var isPreview:Bool
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var saved = false
    @State var showAlreadyExists = false
    @State var currentVerbIta = "temp"
    @State var showFinishedActivityPage = false
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
     
            GeometryReader{ geo in
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                ZStack{
                    VStack{
                        NavBar().padding([.leading, .trailing], 20).zIndex(2)
                        
                        Text(getTenseString(tenseIn: spellConjVerbVM.currentTense))
                            .font(Font.custom("Chalkboard SE", size: 25))
                            .underline()
                        
                        ScrollViewReader{scroller in
                            ScrollView(.horizontal) {
                                HStack{
                                    ForEach(0..<spellConjVerbVM.currentTenseSpellConjVerbData.count, id: \.self) {i in
                                        
                                        VStack(spacing: 0){
                                            questionView(vbItalian: spellConjVerbVM.currentTenseSpellConjVerbData[i].verbNameItalian, vbEnglish: spellConjVerbVM.currentTenseSpellConjVerbData[i].verbNameEnglish, pronoun: spellConjVerbVM.currentTenseSpellConjVerbData[i].pronoun).padding(.bottom, 25)
                                                .padding(.top, 70)
                                            
                                            HStack{
                                                
                                                ForEach($spellConjVerbVM.currentHintLetterArray, id: \.self) { $answerArray in
                                                    Text(answerArray.letter)
                                                        .font(Font.custom("Chalkboard SE", size: 25))
                                                        .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                                                        .underline(color: .black)
                                                    
                                                }.padding(.bottom, 90)
                                                
                                            }
                                            
                                        }.frame(width: geo.size.width)
                                            .frame(minHeight: geo.size.height)
                                    }
                                    
                                }
                                
                                NavigationLink(destination:  ActivityCompletePage(),isActive: $showFinishedActivityPage,label:{}
                                                                  ).isDetailLink(false)
                            }
                            .offset(y: -200)
                            .scrollDisabled(true)
                            .onChange(of: currentQuestionNumber) { newIndex in
                                
                                if newIndex > spellConjVerbVM.currentTenseSpellConjVerbData.count - 1 {
                                    showFinishedActivityPage = true
                                }else{
                                    currentVerbIta = spellConjVerbVM.currentTenseSpellConjVerbData[newIndex].verbNameItalian
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                }
                            }
                        }
                        
                    }.zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WashedWhite"))
                        .frame(width: 340, height: 130)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4)
                        )
                        .offset(y: -125)
                        .zIndex(0)
                    
                    TextField("", text: $userAnswer)
                        .background(Color.white.cornerRadius(10))
                        .font(Font.custom("Marker Felt", size: 50))
                        .shadow(color: Color.black, radius: 12, x: 0, y:10)
                        .frame(width: 350)
                        .padding(.bottom, 25)
                        .zIndex(1)
                    
                    VStack{
                        HStack{
                            Button(action: {
                                if userAnswer != "" {
                                    
                                    if correctChosen || wrongChosen {
                                        correctChosen = false
                                        wrongChosen = false
                                    }
                                    
                                    if  userAnswer.lowercased().elementsEqual(spellConjVerbVM.currentTenseSpellConjVerbData[currentQuestionNumber].correctAnswer.lowercased()) {
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            currentQuestionNumber += 1
                                            correctChosen = false
                                            
                                            progress = (CGFloat(currentQuestionNumber) / CGFloat(spellConjVerbVM.currentTenseSpellConjVerbData.count))
                                            
                                            spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[currentQuestionNumber].hintLetterArray)
                                            
                                            hintGiven = false
                                            hintButtonText = "Give me a Hint!"
                                            userAnswer = ""
                                        }
                                        spellConjVerbVM.showHint()
                                        correctChosen = true
                                        SoundManager.instance.playSound(sound: .correct)
                                        
                                    }else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            wrongChosen = false
                                        }
                                        SoundManager.instance.playSound(sound: .wrong)
                                        wrongChosen = true
                                    }
                                }
                            }, label: {
                                Text("Check")
                                
                            }).font(Font.custom("Marker Felt", size:  18))
                                .frame(width:160, height: 40)
                                .background(Color.teal)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 4)
                                )
                                .shadow(radius: 10)
                                .padding(.trailing, 5)
                                .padding(.top, 15)
                            
                            
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
                                    .frame(width:160, height: 40)
                                    .background(Color.teal)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.black, lineWidth: 4)
                                    )
                                    .padding(.top, 15)
                                
                                
                            })
                        }.offset(y: 100).zIndex(1)
                        
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showAlreadyExists = false
                            }
                            if addVerbItem(verbToSave: currentQuestionNumber){
                                showAlreadyExists = true
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    saved = false
                                }
                                saved = true
                            }
                            
                        }, label: {
                            Text("Add " + currentVerbIta + " to MyList")
                                .font(Font.custom("Marker Felt", size:  18))
                                .padding(.top, 3)
                                .padding([.leading, .trailing], 20)
                                .frame(height: 45)
                                .background(Color.teal)
                                .foregroundColor(Color.white)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 4)
                                )
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .padding(.trailing, 5)
                            
                            
                        }).offset(y:120)
                        
                        Text(currentVerbIta + " is already in MyList!")
                            .font(Font.custom("Arial Hebrew", size: 20))
                            .padding(.top, 3)
                            .padding([.top, .bottom], 5)
                            .padding([.leading, .trailing], 15)
                            .background(Color("WashedWhite"))
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .opacity(showAlreadyExists ? 1 : 0)
                            .offset(y:140)
                    }.zIndex(1)
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .offset(x: 110, y: animatingBear ? 350 : 750)
                    
                    if saved {
                        
                        Image("bubbleChatSaved")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 235)
                        
                    }
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 235)
                    }
                    
                    if wrongChosen{
                        
                        let randomInt2 = Int.random(in: 1..<4)
                        
                        Image("bubbleChatWrong"+String(randomInt2))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 235)
                    }
                    
                    
                }.onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    if isPreview {
                        spellConjVerbVM.currentTense = 0
                        spellConjVerbVM.setSpellVerbData()
                        spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                        currentVerbIta = spellConjVerbVM.currentTenseSpellConjVerbData[0].verbNameItalian
                    }else{
                        currentVerbIta = spellConjVerbVM.currentTenseSpellConjVerbData[0].verbNameItalian
                    }
                }
            }.navigationBarBackButtonHidden(true)
       
        
    }
    
    func addVerbItem(verbToSave: Int)-> Bool {
        
        if itemExistsSpellVerb(spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].verbNameItalian) {
            return true
        }else{
            
            let newUserMadeVerb = UserVerbList(context: viewContext)
            newUserMadeVerb.verbNameItalian = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].verbNameItalian
            newUserMadeVerb.verbNameEnglish = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].verbNameEnglish
            newUserMadeVerb.presente = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].pres
            newUserMadeVerb.passatoProssimo = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].pass
            newUserMadeVerb.futuro = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].fut
            newUserMadeVerb.imperfetto = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].imp
            newUserMadeVerb.imperativo = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].impera
            newUserMadeVerb.condizionale = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].cond
            
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            return false
            
        }
        
    }
    
    private func itemExistsSpellVerb(_ item: String) -> Bool {
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserVerbList")
          fetchRequest.predicate = NSPredicate(format: "verbNameItalian == %@", item)
          return ((try? viewContext.count(for: fetchRequest)) ?? 0) > 0
      }
    
    
    
    @ViewBuilder
    func NavBar() -> some View{
        HStack(spacing: 18){
            NavigationLink(destination: chooseVerbList(), label: {
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
                              .frame(width: proxy.size.width * progress)
                      }
                  }.frame(height: 20)
            
            Image("italyFlag")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .shadow(radius: 10)
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
            .padding([.leading, .trailing], 1)
            .frame(width:275, height: 110)
            .background(Color.teal)
            .cornerRadius(10)
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black, lineWidth: 4)
            )
    }
}


struct SpellConjugatedVerbView_Previews: PreviewProvider {
    static var _spellConjVerbVM = SpellConjVerbViewModel()
    static var previews: some View {
        SpellConjugatedVerbView(spellConjVerbVM: _spellConjVerbVM, isPreview: true)
    }
}
