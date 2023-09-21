//
//  ChooseVCActivityMyList.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/6/23.
//

import SwiftUI

class ChooseVCActivityMyListViewModel: ObservableObject {
    @Published var chosenActivity: Int = 0
}

struct ChooseVCActivityMyList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedTense = ""
    @State private var showActivity: Bool = false
    @State private var myListIsEmpty: Bool = false
    @State private var animatingBear = false
    
    var fetchedResults: [verbObject] = [verbObject]()
    
    let chooseVCActivityVM = ChooseVCActivityMyListViewModel()
    let verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    let spellConjVerbVM = SpellConjVerbViewModel()
    let dragDropVerbConjugationVM = DragDropVerbConjugationViewModel()
    
    @FetchRequest(
        entity: UserVerbList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "verbNameItalian", ascending: true)]
    ) var items: FetchedResults<UserVerbList>
    
    
    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: 55, y: animatingBear ? -260 : 0)
                
                HStack(spacing: 18){
                    NavigationLink(destination: chooseVerbList(), label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                        
                    }).padding(.leading, 25)
                    
                    
                    Spacer()
                    
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 30)
                        .shadow(radius: 10)
                }.offset(y:-350)
                VStack(spacing: 0){
                    Text("Verb Conjugation").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
                        .foregroundColor(.white)
                        .frame(width: 350, height: 60)
                        .background(Color("DarkNavy")).opacity(0.75)
                        .border(width: 8, edges: [.bottom], color: .teal)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 0
                                verbConjMultipleChoiceVM.currentTense = getTenseInt(tenseString: selectedTense)
                                verbConjMultipleChoiceVM.createMultipleChoiceVerbObjects(myListIn: items)
                                verbConjMultipleChoiceVM.setMyListMultipleChoiceData()
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
                                
                            }).disabled(isEmptyMyListVerbData())
                            
                            Text("Multiple Choice")
                        }.frame(width: 140, height: 200)
                        
                        Spacer()
                        
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 1
                                dragDropVerbConjugationVM.currentTense = getTenseInt(tenseString: selectedTense)
                                dragDropVerbConjugationVM.setAllUserMadeList(myListIn: items)
                                dragDropVerbConjugationVM.setMyListDragDropData()
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
                                
                            }).disabled(isEmptyMyListVerbData())
                            
                            Text("Complete Conjugation Table")
                                .multilineTextAlignment(.center)
                        }.frame(width: 140, height: 200)
                            .offset(y:8)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 2
                                spellConjVerbVM.currentTense = getTenseInt(tenseString: selectedTense)
                                spellConjVerbVM.createVerbObjects(myListIn: items)
                                spellConjVerbVM.setMyListSpellVerbData()
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
                            }).disabled(isEmptyMyListVerbData())
                            
                            Text("Spell it Out")
                        }.frame(width: 140, height: 200)
                        Spacer()
                        VStack{
                            Button(action: {
                                chooseVCActivityVM.chosenActivity = 3
                                showActivity = true
                               
                            }, label: {
                                Image("myVerbList")
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
                            
                            Text("Edit My List")
                        }.frame(width: 140, height: 100)
                        Spacer()
                    }.padding(.bottom, 20)
                    
                    if myListIsEmpty{
                        Text("Your List is Empty")
                    }

                    let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                    
                    Picker("Please choose a color", selection: $selectedTense) {
                                 ForEach(tenses, id: \.self) {
                                     Text($0)
                                         .font(.title)
            
                                 }
                    }.pickerStyle(WheelPickerStyle())
                        .offset(y:-30)
                        .frame(height: 120)
        
                }.frame(width:345, height: 600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 5))
                    .shadow(radius: 10)
                    .padding(.top, 40)
            }.onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
            }
            
        }.fullScreenCover(isPresented: $showActivity) {
            switch chooseVCActivityVM.chosenActivity {
            case 0:
                verbConjMultipleChoiceView(verbConjMultipleChoiceVM: verbConjMultipleChoiceVM, isPreview: false)
            case 1:
                DragDropVerbConjugationView(dragDropVerbConjugationVM: dragDropVerbConjugationVM, isPreview: false)
            case 2:
                SpellConjugatedVerbView(spellConjVerbVM: spellConjVerbVM, isPreview: false)
            case 3:
                ListViewOfAvailableVerbs()
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
    
    func isEmptyMyListVerbData() -> Bool {
        
        let fR =  UserVerbList.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
}

struct ChooseVCActivityMyList_Previews: PreviewProvider {
    static var previews: some View {
        ChooseVCActivityMyList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
