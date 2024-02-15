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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedTense = ""
    @State private var showActivity: Bool = false
    @State private var myListIsEmpty: Bool = false
    @State private var animatingBear = false
    @State private var showInfoPopUp = false
    
    var fetchedResults: [verbObject] = [verbObject]()
    
    let chooseVCActivityVM = ChooseVCActivityViewModel()
    let verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    let spellConjVerbVM = SpellConjVerbViewModel()
    let dragDropVerbConjugationVM = DragDropVerbConjugationViewModel()
    
    
    var body: some View {
            GeometryReader{ geo in
                if horizontalSizeClass == .compact {
                    ZStack(alignment: .topLeading){
                        Image("horizontalNature")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                            .opacity(1.0)
                        
                        HStack(alignment: .top){
                            
                            NavigationLink(destination: chooseVerbList(), label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 25)
                                .padding(.top, 20)
                            
                            
                            Spacer()
                            VStack(spacing: 0){
                                Image("italyFlag")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 10)
                                    .padding()
                                
                                
                            }
                        }
                        
                        
                        if showInfoPopUp{
                            ZStack(alignment: .topLeading){
                                Button(action: {
                                    showInfoPopUp.toggle()
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 25))
                                        .foregroundColor(.black)
                                    
                                }).padding(.leading, 15)
                                    .zIndex(1)
                                    .offset(y: -15)
                               
                             
                 
                                    
                                    Text("Choose from the following activities to practice conjugating Italian verbs in different tenses. \n\n Choose one of the available tenses from the picker wheel before picking your activity.")
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .padding(.top, 15)
                             
                            }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.7)
                                .background(Color("WashedWhite"))
                                .cornerRadius(20)
                                .shadow(radius: 20)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 3)
                                )
                                .transition(.slide).animation(.easeIn).zIndex(2)
                                .padding([.leading, .trailing], geo.size.width * 0.1)
                                .padding([.top, .bottom], geo.size.height * 0.3)
                            
                            
                        }
                        
                        VStack{
                            HStack{
                                Text("Verb Conjugation").zIndex(1)
                                    .font(Font.custom("Marker Felt", size: 33))
                                    .foregroundColor(.white)
                                    .padding(.leading, 35)
                                
                                Button(action: {
                                    withAnimation(.linear){
                                        showInfoPopUp.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "info.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                    
                                })
                                .padding(.leading, 5)
                            }.frame(width: 450, height: 80)
                                .background(Color("DarkNavy")).opacity(0.75)
                                .border(width: 8, edges: [.bottom], color: .teal)
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
                                            .frame(width: 65, height: 65)
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(60)
                                            .overlay( RoundedRectangle(cornerRadius: 60)
                                                .stroke(.black, lineWidth: 3))
                                            .shadow(radius: 10)
                                        
                                    })
                                    
                                    Text("Multiple Choice")
                                }.frame(width: 140, height: 200)
                                
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
                                            .frame(width: 65, height: 65)
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(60)
                                            .overlay( RoundedRectangle(cornerRadius: 60)
                                                .stroke(.black, lineWidth: 3))
                                            .shadow(radius: 10)
                                        
                                    })
                                    
                                    Text("Complete Conjugation Table")
                                        .multilineTextAlignment(.center)
                                }.frame(width: 140, height: 200)
                                    .padding(.top, 8)
                                    .offset(y:5)
                                Spacer()
                            }.offset(y:-15)
                            HStack{
                                VStack{
                                    Button(action: {
                                        chooseVCActivityVM.chosenActivity = 2
                                        spellConjVerbVM.currentTense = getTenseInt(tenseString: selectedTense)
                                        spellConjVerbVM.setSpellVerbData()
                                        spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                                        showActivity = true
                                    }, label: {
                                        Image("spellOut")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 65, height: 65)
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(60)
                                            .overlay( RoundedRectangle(cornerRadius: 60)
                                                .stroke(.black, lineWidth: 3))
                                            .shadow(radius: 10)
                                        
                                    })
                                    
                                    Text("Spell it Out")
                                }.frame(width: 100, height: 100).padding(.top, 20)
                                
                            }.offset(y: -15)
                            
                            let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                            
                            Picker("Please choose a color", selection: $selectedTense) {
                                ForEach(tenses, id: \.self) {
                                    Text($0)
                                        .font(.title)
                                    
                                }
                            }.pickerStyle(WheelPickerStyle())
                                .padding(.bottom, 20)
                            
                        }.frame(width:  geo.size.width * 0.9, height: geo.size.height * 0.85)
                            .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 5))
                            .padding([.leading, .trailing], geo.size.width * 0.05)
                            .padding([.top, .bottom], geo.size.height * 0.12)
                    }.onAppear{
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            withAnimation(.spring()){
                                animatingBear = true
                            }
                        }
                    }
                    
                    
                }else{
                    chooseVCActivityIPAD()
                }
                
            }.fullScreenCover(isPresented: $showActivity) {
                NavigationView{
                    switch chooseVCActivityVM.chosenActivity {
                    case 0:
                        verbConjMultipleChoiceView(verbConjMultipleChoiceVM: verbConjMultipleChoiceVM, isPreview: false)
                    case 1:
                        DragDropVerbConjugationView(dragDropVerbConjugationVM: dragDropVerbConjugationVM, isPreview: false)
                    case 2:
                        SpellConjugatedVerbView(spellConjVerbVM: spellConjVerbVM, isPreview: false)
                    default:
                        ChooseVCActivityMyList()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        
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
