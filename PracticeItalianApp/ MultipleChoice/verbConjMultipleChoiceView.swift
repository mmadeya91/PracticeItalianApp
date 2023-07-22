//
//  verbConjMultipleChoiceView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI
import CoreData

struct verbConjMultipleChoiceView: View{
    
    @StateObject var verbConjMultipleChoiceVM: VerbConjMultipleChoiceViewModel
    
    @State private var pressed = false
    @State private var counter: Int = 0
    @State private var myListIsEmpty: Bool = false
    
    var body: some View {
        
        let tenseName = ["Presente", "Passato Prossimo", "Imperfetto", "Futuro", "Conditionale", "Imperativo"]

        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
  
                VStack{
                    
                    VStack{
                        
                        ScrollViewReader {scrollView in
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count, id: \.self) { i in
                                        multipleChoiceView(mcOIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i])
                                            .padding([.leading, .trailing], 10)
                                    }
                                    
                                }
                            }.scrollDisabled(true)
                            HStack{
                                Button(action: {
                                    withAnimation{
                                        if counter > 0 {
                                            counter = counter - 1
                                        }
                                        scrollView.scrollTo(counter)
                                    }
                                }, label:
                                        {Image(systemName: "arrow.backward").resizable()
                                        .bold()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(Color.black)
                                    
                                    
                                    
                                }).padding(.leading, 90)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation{
                                        if counter < 15 {
                                            counter = counter + 1
                                        }
                                        scrollView.scrollTo(counter)
                                    }
                                }, label:
                                        {Image(systemName: "arrow.forward").resizable()
                                        .bold()
                                        .scaledToFit()
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(Color.black)
                                    
                                    
                                    
                                }).padding(.trailing, 90)
                            }.padding(.top, 50)
                        }
                        
                        addToMyListConjVerbButton().padding(.top, 20)
                    }.padding(.top, 50)
                    
                }
            }
        }
    }

}
    
    
    struct multipleChoiceView: View {
        var mcOIn: multipleChoiceVerbObject
        var body: some View{
            VStack{
                multipleChoiceViewVerbtoConj(verbNameIt: mcOIn.verbNameIt, pronoun: mcOIn.pronoun, verbNameEng: mcOIn.verbNameEng)
                choicesView(choicesIn: mcOIn.choiceList.shuffled(), correctAnswerIn: mcOIn.correctAnswer)
            }
        }
    }
        
    struct multipleChoiceViewVerbtoConj: View{
        
        var verbNameIt: String
        var pronoun: String
        var verbNameEng: String
        
        var body: some View{
            
                Text(verbNameIt + " - " + pronoun + "\n(" + verbNameEng)
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .frame(width:260, height: 100)
                    .background(Color.teal)
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .shadow(radius: 10)
            
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
        
        var body: some View{
            
            let isCorrect: Bool = choiceString.elementsEqual(correctAnswer)
            
            if isCorrect {
                correctMCButton(choiceString: choiceString)
            } else {
                incorrectMCButton(choiceString: choiceString)
            }
           
        }
    }


struct addToMyListConjVerbButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View{
        Button(action: {}, label: {
            Text("Save to my List")
                .font(Font.custom("Arial Hebrew", size: 20))
                .foregroundColor(Color.black)
                .frame(width: 200, height: 40)
                .background(Color.orange)
                .cornerRadius(20)
            
        })
    }
    
    func deleteItems(cardToDelete: UserMadeFlashCard) {
        withAnimation {

                    viewContext.delete(cardToDelete)
            
            do {
                try viewContext.save()
            } catch {
                
            }
        }
    }
}
    
    
    struct verbConjMultipleChoice_Previews: PreviewProvider {
        static var _verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
        static var previews: some View {
            verbConjMultipleChoiceView(verbConjMultipleChoiceVM: _verbConjMultipleChoiceVM)
        }
    }
    

