//
//  chooseVCActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/12/23.
//

import SwiftUI

class ChooseVCActivityViewModel: ObservableObject {
    @Published var chosenActivity: Int = 0
}

struct chooseVCActivity: View {
    
    @State private var selectedTense = ""
    @State private var showActivity: Bool = false
    @State private var myListIsEmpty: Bool = false
    
    var fetchedResults: [verbObject] = [verbObject]()
    
    let chooseVCActivityVM = ChooseVCActivityViewModel()
    let verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    let spellConjVerbVM = SpellConjVerbViewModel()
    let dragDropVerbConjugationVM = DragDropVerbConjugationViewModel()
    
    
    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                Image("watercolor2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack{
                    Text("Verb Conjugation Activities").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 350, height: 60)
                        .background(Color.teal).opacity(0.75)
                        .border(width: 8, edges: [.bottom], color: .yellow)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 0
                                verbConjMultipleChoiceVM.currentTense = getTenseInt(tenseString:    selectedTense)
                                loadData()
                                showActivity = true
                            }, label: {
                                Image("multipleChoice")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.yellow, lineWidth: 6)
                                    )
                                
                            })
                            
                            Text("Multiple Choice")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 1
                                dragDropVerbConjugationVM.currentTense = getTenseInt(tenseString: selectedTense)
                                dragDropVerbConjugationVM.setNonMyListDragDropData()
                                showActivity = true
                            }, label: {
                                Image("dragDrop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.yellow, lineWidth: 6)
                                    )
                                
                            })
                            
                            Text("Complete Conjugation Table")
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                    HStack{
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 2
                                showActivity = true
                            }, label: {
                                Image("spellOut")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.yellow, lineWidth: 6)
                                    )
                                
                            })
                            
                            Text("Spell it Out")
                        }
      
                    }.padding(.bottom, 50)

                    let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                    
                    Picker("Please choose a color", selection: $selectedTense) {
                                 ForEach(tenses, id: \.self) {
                                     Text($0)
                                         .font(.title)
            
                                 }
                    }.pickerStyle(WheelPickerStyle())
                        .padding(.bottom, 50)
        
                }.frame(width: 345, height:700).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 6))
                    .shadow(radius: 10)
                    .padding(.top, 10)
            }
        }.fullScreenCover(isPresented: $showActivity) {
            switch chooseVCActivityVM.chosenActivity {
            case 0:
                verbConjMultipleChoiceView(verbConjMultipleChoiceVM: verbConjMultipleChoiceVM)
            case 1:
                DragDropVerbConjugationView(dragDropVerbConjugationVM: dragDropVerbConjugationVM, isPreview: false)
            case 2:
                SpellConjugatedVerbView(spellConjVerbVM: spellConjVerbVM)
            default:
                ChooseVCActivityMyList()
            }
        }
    }
    
    func getTenseInt(tenseString: String)->Int{
        switch tenseString {
        case "Presente":
            return 0
        case "Passato Prossimo":
            return 1
        case "Futuro":
            return 2
        case "Imperfetto":
            return 3
        case "Presente Condizionale":
            return 4
        case "Imperativo":
            return 5
        default:
            return 0
        }
    }
    
    func loadData() {
        verbConjMultipleChoiceVM.setMultipleChoiceData()
        verbConjMultipleChoiceVM.isMyList = false
    }
}

struct chooseVCActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseVCActivity()
    }
}
