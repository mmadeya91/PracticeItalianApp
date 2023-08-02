//
//  verbConjMultipleChoiceView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI
import CoreData

struct verbConjMultipleChoiceView: View{
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var verbConjMultipleChoiceVM: VerbConjMultipleChoiceViewModel
    
    @State private var pressed = false
    @State private var progress: CGFloat = 0.0
    @State private var counter: Int = 0
    @State private var myListIsEmpty: Bool = false
    @State var isPreview: Bool
    @State var animatingBear = false
    @State var saved = false
    @State var correctChosen = false
    @State var wrongChosen = false
    
    var body: some View {
        
        
        GeometryReader{geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
            
                
            ZStack{
                VStack{
                    NavBar()
                    
                    Text(getTenseString(tenseIn: verbConjMultipleChoiceVM.currentTense))
                        .font(Font.custom("Chalkboard SE", size: 25))
                    
                    ScrollViewReader {scroller in
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(0..<verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count, id: \.self) { i in
                                    
                                    VStack{
                                        Text(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].verbNameIt + " - " + verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].pronoun + "\n(" + verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].verbNameEng)
                                            .bold()
                                            .font(Font.custom("Arial Hebrew", size: 20))
                                            .frame(width:260, height: 100)
                                            .background(Color.teal)
                                            .cornerRadius(10)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                            .overlay( /// apply a rounded border
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.black, lineWidth: 4)
                                            )
                                        
                                            .padding(.bottom, 50)
                                            .shadow(radius: 10)
                            
                                        
                                        
                                        choicesView(choicesIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].choiceList, correctAnswerIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].correctAnswer, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
                                    }
                                    .frame(width: geo.size.width)
                                    .frame(minHeight: geo.size.height)
                                
                                }
                                
                            }.offset(y: -100)
                        }
                        .scrollDisabled(true)
                        .frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .onChange(of: counter) { newIndex in
                            withAnimation{
                                scroller.scrollTo(newIndex, anchor: .center)
                            }
                        }
                       
                        
                        
                    }
                    
                    Button(action: {
                        
                        addVerbItem(verbToSave: counter)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            saved = false
                        }
                        saved = true
                        
                    }, label: {
                        Text("Add Verb to MyList")
                            .font(Font.custom("Arial Hebrew", size: 17))
                            .padding(.top, 3)
                            .foregroundColor(Color.black)
                            .frame(width: 200, height: 45)
                            .background(Color.orange)
                            .cornerRadius(15)
                    
                    }).offset(y:-260)
                    
                   
      
                }
                .zIndex(1)
                
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("WashedWhite"))
                    .frame(width: 365, height: 200)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 4)
                    )
                    .offset(y: 5)
                    .zIndex(0)
                
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .offset(x: 95, y: animatingBear ? 350 : 750)
                    
                    if saved {
                        
                        Image("bubbleChatSaved")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 250)
                            
                    }
                
                if correctChosen{
                    
                    let randomInt = Int.random(in: 1..<4)
                    
                    Image("bubbleChatRight"+String(randomInt))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(y: 250)
                }
                      
                if wrongChosen{
                    
                    let randomInt2 = Int.random(in: 1..<4)
                    
                    Image("bubbleChatWrong"+String(randomInt2))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(y: 250)
                }
                      
                
                
                
            }.onAppear{
                withAnimation(.easeIn){
                    animatingBear = true
                }
                if isPreview{
                    verbConjMultipleChoiceVM.setMultipleChoiceData()
                }
            }
        }
    }
    
    func addVerbItem(verbToSave: Int) {
        
        let newUserMadeVerb = UserVerbList(context: viewContext)
        newUserMadeVerb.verbNameItalian = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].verbNameIt
        newUserMadeVerb.verbNameEnglish = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].verbNameEng
        newUserMadeVerb.presente = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].pres
        newUserMadeVerb.passatoProssimo = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].pass
        newUserMadeVerb.futuro = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].fut
        newUserMadeVerb.imperfetto = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].imp
        newUserMadeVerb.imperativo = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].impera
        newUserMadeVerb.condizionale = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].cond
        
        do {
            try viewContext.save()
        } catch {
            print("error saving")
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
    
    @ViewBuilder
    func NavBar() -> some View{
        HStack(spacing: 18){
            Spacer()
            Button(action: {
                
            }, label: {
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
                        .frame(width: proxy.size.width * CGFloat(progress))
                }
            }.frame(height: 13)
                .onChange(of: counter){ newValue in
                    progress = CGFloat(newValue) / CGFloat(verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count)
                }
            
            Image("italyFlag")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Spacer()
        }
    }
    
}


struct choicesView: View{
    
    var choicesIn: [String]
    var correctAnswerIn: String
    @Binding var counter: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    
    var body: some View{
        HStack{
            multipleChoiceButton(choiceString: choicesIn[0], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
            multipleChoiceButton(choiceString: choicesIn[1], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
        }
        HStack{
            multipleChoiceButton(choiceString: choicesIn[2], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
            multipleChoiceButton(choiceString: choicesIn[3], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
        }
        HStack{
            multipleChoiceButton(choiceString: choicesIn[4], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
            multipleChoiceButton(choiceString: choicesIn[5], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
        }
        
    }
}


struct multipleChoiceButton: View{
    
    var choiceString: String
    var correctAnswer: String
    @Binding var counter: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    
    var body: some View{
        
        let isCorrect: Bool = choiceString.elementsEqual(correctAnswer)
        
        if isCorrect {
            correctMCButton(choiceString: choiceString, counter: $counter, correctChosen: $correctChosen)
        } else {
            incorrectMCButton(choiceString: choiceString, wrongChosen: $wrongChosen)
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
        verbConjMultipleChoiceView(verbConjMultipleChoiceVM: _verbConjMultipleChoiceVM, isPreview: true)
    }
}


