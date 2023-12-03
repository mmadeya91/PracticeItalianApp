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
    @ObservedObject var globalModel = GlobalModel()
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
    @State var currentVerbIta = "temp"
    @State var showAlreadyExists: Bool = false
    @State var showFinishedActivityPage = false
    
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
                        .font(Font.custom("Chalkboard SE", size: 30))
                        .underline()
                        .padding(.top, 20)
                    
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
                            
                                        
                                        
                                        choicesView(choicesIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].choiceList, correctAnswerIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].correctAnswer, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen).offset(x:3)
                                    }
                                    .frame(width: geo.size.width)
                                    .frame(minHeight: geo.size.height)
                                
                                }
                                
                            }.offset(y: -180)
                        }
                        .scrollDisabled(true)
                        .frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .onChange(of: counter) { newIndex in
                            if newIndex == verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    showFinishedActivityPage = true
                                }
                                progress = CGFloat(verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count)
                            }else{
                                currentVerbIta = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[newIndex].verbNameIt
                                withAnimation{
                                    scroller.scrollTo(newIndex, anchor: .center)
                                }
                            }
                            
 
                        }
                       
                        
                        
                    }
                    
                    
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showAlreadyExists = false
                        }
                        if addVerbItem(verbToSave: counter){
                            showAlreadyExists = true
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                saved = false
                            }
                            saved = true
                        }
                        
                    }, label: {
                        Text("Add " + currentVerbIta + " to MyList")
                            .font(Font.custom("Arial Hebrew", size: 17))
                            .padding(.top, 3)
                            .padding([.leading, .trailing], 20)
                            .foregroundColor(Color.black)
                            .frame(height: 45)
                            .background(Color.orange)
                            .cornerRadius(20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .shadow(radius: 10)
                        
                    
                    }).offset(y:-350)
                    
                    Text(currentVerbIta + " is already in MyList!")
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .padding(.top, 3)
                        .padding([.top, .bottom], 5)
                        .padding([.leading, .trailing], 15)
                        .background(Color("WashedWhite"))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .opacity(showAlreadyExists ? 1 : 0)
                        .offset(y:-330)
                    
                   
      
                }
                .zIndex(1)
                
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("WashedWhite"))
                    .frame(width: 365, height: 200)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 4)
                    )
                    .offset(y: -75)
                    .zIndex(0)
                
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .offset(x: 95, y: animatingBear ? 320 : 750)
                    
                    if saved {
                        
                        Image("bubbleChatSaved")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 240)
                            
                    }
                
                if correctChosen{
                    
                    let randomInt = Int.random(in: 1..<4)
                    
                    Image("bubbleChatRight"+String(randomInt))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(y: 240)
                }
                      
                if wrongChosen{
                    
                    let randomInt2 = Int.random(in: 1..<4)
                    
                    Image("bubbleChatWrong"+String(randomInt2))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(y: 240)
                }
                      
                
                NavigationLink(destination: ActivityCompletePage(),isActive: $showFinishedActivityPage,label:{}
                                                   ).isDetailLink(false)
                
            }
            .onAppear{
                withAnimation(.easeIn){
                    animatingBear = true
                }
                if isPreview{
                    verbConjMultipleChoiceVM.setMultipleChoiceData()
                    currentVerbIta = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[0].verbNameIt
                }else{
                    currentVerbIta = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[0].verbNameIt
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func addVerbItem(verbToSave: Int)->Bool {
        
        if itemExists(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].verbNameIt) {
            return true
        }else{
            
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
            
            return false
        }
        
        
    }
    
    private func itemExists(_ item: String) -> Bool {
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserVerbList")
          fetchRequest.predicate = NSPredicate(format: "verbNameItalian == %@", item)
          return ((try? viewContext.count(for: fetchRequest)) ?? 0) > 0
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
                .shadow(radius: 10)
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





struct verbConjMultipleChoice_Previews: PreviewProvider {
    static var _verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    static var previews: some View {
        verbConjMultipleChoiceView(verbConjMultipleChoiceVM: _verbConjMultipleChoiceVM, isPreview: true).environmentObject(GlobalModel())
    }
}


