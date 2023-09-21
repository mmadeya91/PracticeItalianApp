//
//  chooseFlashCardSet.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/13/23.
//

import SwiftUI

struct chooseFlashCardSet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var globalModel: GlobalModel
    @State private var animatingBear = false
    @State private var showInfoPopUp = false
    @State private var attemptToBuyPopUp = false
    @State private var attemptedBuyName = "temp"
    @State private var notEnoughCoins = false
    
    let flashCardSetAccManager = FlashCardSetAccDataManager()
    
    
    @FetchRequest var flashCardSetAccData: FetchedResults<FlashCardSetAccuracy>

    init() {
        self._flashCardSetAccData = FetchRequest(entity: FlashCardSetAccuracy.entity(), sortDescriptors: [])
    }
    
    @FetchRequest(
        entity: UserUnlockedDataSets.entity(),
        sortDescriptors: []
    ) var fetchedUserUnlockedData: FetchedResults<UserUnlockedDataSets>
    
    @FetchRequest(
        entity: UserCoins.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedUserCoins: FetchedResults<UserCoins>
    
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                HStack(spacing: 18){
               
                        NavigationLink(destination: chooseActivity(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        }).padding(.leading, 25).padding(.top, 15)
 
                
                    
                    Spacer()
                    VStack{
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
     
                            
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 22))
                        }.padding(.top,10).padding(.trailing, 45)
                    }.padding(.top, 85)
                }.zIndex(2).offset(y:-380)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: -45, y: animatingBear ? -260 : 0)
                
                
                
                VStack{
                    
                    flashCardSets(setAccData: flashCardSetAccData, showInfoPopup: $showInfoPopUp, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName).frame(width: 345, height:600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 5))
                        .shadow(radius: 10)
                        .padding(.top, 90)
                        .padding(.bottom, 35)
                }
                
                if showInfoPopUp{
                    VStack{
                        Text("Use the provided flash card sets to increase your vocabulary! Or, make your own using the 'Make Your Own' feature. \n \nEach flash card set displays your accuracy under the corresponding image to let you know which words you need to work most on during your practice.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }.frame(width: 300, height: 285)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                }
                
                if attemptToBuyPopUp{
                    VStack{
                        VStack{
                            Text("Do you want to spend 25 of your coins to unlock the 'Food' flash card set?")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            if notEnoughCoins{
                                Text("Sorry! You don't have enough coins!")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            
                            HStack{
                                Button(action: {
                                    checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                }, label: {Text("Yes")})
                                Button(action: {
                                    attemptToBuyPopUp = false
                                }, label: {Text("No")})
                            }
                            
                        }
                    }.frame(width: 300, height: 285)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                    
                }
                
                
            }.onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
              
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func unlockData(chosenDataSet: String){
        for dataSet in fetchedUserUnlockedData {
            if dataSet.dataSetName == chosenDataSet {
                dataSet.isUnlocked = true
                updateGlobalModel(chosenDataSet: chosenDataSet)
                do {
                    try viewContext.save()
                } catch {

                    let nsError = error as NSError
                }
            }
        }
    }
    
    func updateGlobalModel(chosenDataSet: String){
        for i in 0...globalModel.currentUnlockableDataSets.count-1 {
            if globalModel.currentUnlockableDataSets[i].setName == chosenDataSet {
                globalModel.currentUnlockableDataSets[i].isUnlocked = true
            }
        }
    }
    
    func checkAndUpdateUserCoins(userCoins: Int, chosenDataSet: String)->Bool{
        if globalModel.userCoins >= 25 {
            fetchedUserCoins[0].coins = Int32(globalModel.userCoins - 25)
            globalModel.userCoins = globalModel.userCoins - 25
            unlockData(chosenDataSet: chosenDataSet)
            do {
                try viewContext.save()
            } catch {

                let nsError = error as NSError
            }
            return true
        }else{
            notEnoughCoins = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                attemptToBuyPopUp = false
                 notEnoughCoins = false
            }
            return false
        }
    }
}

struct flashCardSets: View {
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    @Binding var showInfoPopup: Bool
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var body: some View{
        
        ZStack{
            VStack{
                
                HStack{
                    Text("Flash Cards").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
                        .padding(.leading, 30)
                    
                    Button(action: {
                        withAnimation(.linear){
                            showInfoPopup.toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                    })
                    .padding(.leading, 5)
                }.frame(width: 350, height: 70)
                    .background(.teal).opacity(0.75)
                    .border(width: 6, edges: [.bottom], color: .black)
                
                flashCardHStack(setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                
                
                
            }.zIndex(1)

        }
    }
}

struct flashCardHStack: View {
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        
        let flashCardSetTitles: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own"]
        
        let flashCardIcons: [String] = ["food", "bear", "clothes", "family", "dictionary", "dictionary", "dictionary", "dictionary", "talking", "flash-card", "flash-card"]
        
        ScrollView{
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[0], flashCardSetIcon: flashCardIcons[0], arrayIndex: 0, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[1], flashCardSetIcon: flashCardIcons[1], arrayIndex: 1, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
            }.padding([.leading, .trailing], 45)
    
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[2], flashCardSetIcon: flashCardIcons[2], arrayIndex: 2, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[3], flashCardSetIcon: flashCardIcons[3], arrayIndex: 3, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[4], flashCardSetIcon: flashCardIcons[4], arrayIndex: 4, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[5], flashCardSetIcon: flashCardIcons[5], arrayIndex: 5, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[6], flashCardSetIcon: flashCardIcons[6], arrayIndex: 6, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[7], flashCardSetIcon: flashCardIcons[7], arrayIndex: 7, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[8], flashCardSetIcon: flashCardIcons[8], arrayIndex: 8, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                toMyListButton(flashCardSetName: flashCardSetTitles[9], flashCardSetIcon: flashCardIcons[9], setAccData: setAccData)
            }.padding([.leading, .trailing], 45)
            HStack{
                toMakeYourOwnButton(flashCardSetName: flashCardSetTitles[10], flashCardSetIcon: flashCardIcons[10], setAccData: setAccData)
                Spacer()
  
            }.padding([.leading, .trailing], 45)
        }
               
    }
    
}

struct flashCardButton: View {
    
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    var arrayIndex: Int
    
    @State var pressed = false
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var body: some View{
        
        let dataObj = flashCardData(chosenFlashSetIndex: arrayIndex)
        let flashCardSetAccObj = FlashCardSetAccDataManager()
        
        if flashCardSetName.elementsEqual("Food"){
            VStack{
                
                Text(flashCardSetName)
                    .font(Font.custom("Marker Felt", size: 20))
                    .frame(width: 100, height: 85)
                    .multilineTextAlignment(.center)
                    .offset(y:15)
    
                            Button(action: {
                                attemptToBuyPopUp.toggle()
                                attemptedBuyName = flashCardSetName
                            }, label: {
                                Image(flashCardSetIcon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65, height: 65)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(60)
                                    .overlay( RoundedRectangle(cornerRadius: 60)
                                        .stroke(.black, lineWidth: 3))
                                    .shadow(radius: 10)
                                    .opacity(0.40)
                            }).overlay(
                                VStack(spacing: 0){
                                    Image("coin2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                    Text("25")
                                        .font(Font.custom("Arial Hebrew", size: 30))
                                        .bold()
                                }.offset(y:5)
                        )

            }
            }else{
                VStack{
                    
                    Text(flashCardSetName)
                        .font(Font.custom("Marker Felt", size: 20))
                        .frame(width: 100, height: 85)
                        .multilineTextAlignment(.center)
                        .offset(y:15)
                    
                    
                    NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: arrayIndex), flashCardSetName: dataObj.getSetName(index: arrayIndex)), label: {
                        Image(flashCardSetIcon)
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
                                   Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[arrayIndex])) + "%")
                                   
            }
            
                                   
        }
    }
    
}

struct toMakeYourOwnButton: View {
    
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    
    var body: some View{

        let flashCardSetAccObj = FlashCardSetAccDataManager()
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: createFlashCard(), label: {
                Image(flashCardSetIcon)
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
            
            Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[10])) + "%")
        
        }
    }
    
}

struct toMyListButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    var setAccData: FetchedResults<FlashCardSetAccuracy>

    var body: some View{
        
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: myListFlashCardActivity(), label: {
                Image(flashCardSetIcon)
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
            
            Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[9])) + "%")
        
        }
    }
    
    
    
}


struct chooseFlashCardSet_Previews: PreviewProvider {
    static var previews: some View {
        chooseFlashCardSet().environment(\.managedObjectContext,
                                          PersistenceController.preview.container.viewContext)
        .environmentObject(GlobalModel())
    }
}
