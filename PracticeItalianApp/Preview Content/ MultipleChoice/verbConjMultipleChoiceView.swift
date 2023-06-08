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
    @State private var counter: Int = 0
    
    var body: some View {
        
        let tenseName = ["Presente", "Passato Prossimo", "Imperfetto", "Futuro", "Conditionale", "Imperativo"]
        
        let mcD = multipleChoiceData(tense: tenseIn)
        
        let mcOArray: [multipleChoiceObject] = mcD.createArrayOfMCD(numberOfVerbs: 15, tense: mcD.tense)
        
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
  
                VStack{
                    
                    customTopNavBar8(tenseIn: tenseIn, tenseName: tenseName[tenseIn]).offset(y:-35)
                    
                    VStack{
                        progressBarMultipleChoice(counter: self.$counter, totalQuestions: mcOArray.count)
                        
                        scrollViewBuilderMultipleChoice(mcOArray: mcOArray, counter: self.$counter, tense: tenseIn).padding(.top, 30)
                            .padding([.leading, .trailing], 10)
                        
                        addToMyListConjVerbButton().padding(.top, 20)
                    }.padding(.top, 50)
                    
                }
            }
        }
    }
}
    
    struct scrollViewBuilderMultipleChoice: View{
        
        var mcOArray: [multipleChoiceObject]
        
        @Binding var counter: Int
        var tense: Int
        
        var body: some View{
            ScrollViewReader {scrollView in
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<mcOArray.count, id: \.self) { i in
                            multipleChoiceView(mcOIn: mcOArray[i])
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
                            if counter < mcOArray.count - 1 {
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
        }
    }
    
    struct multipleChoiceView: View {
        var mcOIn: multipleChoiceObject
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

    struct progressBarMultipleChoice: View {
        
        @Binding var counter: Int
        let totalQuestions: Int
        
        var body: some View {
            
            VStack {
                
                Text(String(counter + 1) + "/" + String(totalQuestions))
                    .font(Font.custom("Arial Hebrew", size: 25))
                    .bold()
                    .offset(y:35)
                
                ProgressView("", value: Double(counter), total: Double(totalQuestions - 1))
                    .tint(Color.orange)
                    .scaleEffect(x: 1, y: 4)
                    .padding([.leading, .trailing], 10)
                    .padding(.bottom, 70)
                    
                
                
            }.frame(width: 350, height: 70)
                .background(.white.opacity(0.8))
                .border(.orange, width: 3)
                .cornerRadius(10)
               
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
    
    struct customTopNavBar8: View {
        
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

        }
    }
    
    
    struct verbConjMultipleChoice_Previews: PreviewProvider {
        static var previews: some View {
            verbConjMultipleChoiceView(tenseIn: 0)
        }
    }
    

