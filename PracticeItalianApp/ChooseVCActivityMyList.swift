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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
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
                    
                    
                    VStack{
                        Text("Verb Conjugation").zIndex(1)
                            .font(Font.custom("Marker Felt", size: 30))
                            .foregroundColor(.white)
                            .frame(width: 450, height: 60)
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
                                    
                                })
                                
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
                                    
                                })
                                
                                Text("Complete Conjugation Table")
                                    .multilineTextAlignment(.center)
                            }.frame(width: 140, height: 200)
                                .padding(.top, 8)
                                .offset(y:5)
                            Spacer()
                        }.offset(y:-15)
                        HStack{
                            Spacer()
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
                                .offset(y:-15)
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
                            
                        }//.offset(y: -15)
                        
                        let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                        
                        Picker("Please choose a color", selection: $selectedTense) {
                            ForEach(tenses, id: \.self) {
                                Text($0)
                                    .font(.title)
                                
                            }
                        }.pickerStyle(WheelPickerStyle())
                            .padding(.bottom, 20)
                        //                    HStack{
                        //                        Spacer()
                        //                        VStack{
                        //                            Button(action: {
                        //                                chooseVCActivityVM.chosenActivity = 2
                        //                                spellConjVerbVM.currentTense = getTenseInt(tenseString: selectedTense)
                        //                                spellConjVerbVM.createVerbObjects(myListIn: items)
                        //                                spellConjVerbVM.setMyListSpellVerbData()
                        //                                spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                        //                                showActivity = true
                        //                            }, label: {
                        //                                Image("spellOut")
                        //                                    .resizable()
                        //                                    .scaledToFit()
                        //                                    .frame(width: 65, height: 65)
                        //                                    .padding()
                        //                                    .background(.white)
                        //                                    .cornerRadius(60)
                        //                                    .overlay( RoundedRectangle(cornerRadius: 60)
                        //                                        .stroke(.black, lineWidth: 3))
                        //                                    .shadow(radius: 10)
                        //                            }).disabled(isEmptyMyListVerbData())
                        //
                        //                            Text("Spell it Out")
                        //                        }.frame(width: 140, height: 200)
                        //                        Spacer()
                        //                        VStack{
                        //                            Button(action: {
                        //                                chooseVCActivityVM.chosenActivity = 3
                        //                                showActivity = true
                        //
                        //                            }, label: {
                        //                                Image("myVerbList")
                        //                                    .resizable()
                        //                                    .scaledToFit()
                        //                                    .frame(width: 65, height: 65)
                        //                                    .padding()
                        //                                    .background(.white)
                        //                                    .cornerRadius(60)
                        //                                    .overlay( RoundedRectangle(cornerRadius: 60)
                        //                                        .stroke(.black, lineWidth: 3))
                        //                                    .shadow(radius: 10)
                        //
                        //                            })
                        //
                        //                            Text("Edit My List")
                        //                        }.frame(width: 140, height: 100)
                        //                        Spacer()
                        //                    }
                        //                        .offset(y:-35)
                        //
                        //                    if myListIsEmpty{
                        //                        Text("Your List is Empty")
                        //                    }
                        //
                        //                    let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                        //
                        //                    Picker("Please choose a color", selection: $selectedTense) {
                        //                        ForEach(tenses, id: \.self) {
                        //                            Text($0)
                        //                                .font(.title)
                        //
                        //                        }
                        //                    }.pickerStyle(WheelPickerStyle())
                        //                        .frame(height: 85)
                        //                        .offset(y:-55)
                        
                    }.frame(width:  geo.size.width * 0.9, height: geo.size.height * 0.85)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 5))
                        .padding([.leading, .trailing], geo.size.width * 0.05)
                        .padding([.top, .bottom], geo.size.height * 0.12)
                }.onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                }
            }else{
                ChooseVCActivityMyListIPAD()
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
