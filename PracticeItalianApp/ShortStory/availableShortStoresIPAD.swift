//
//  availableShortStoresIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/1/24.
//

import SwiftUI

struct availableShortStoriesIPAD: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var globalModel: GlobalModel
    @State var animatingBear = false
    @State var showInfoPopup = false
    @State var attemptToBuyPopUp = false
    @State var attemptedBuyName = "temp"
    @State var notEnoughCoins = false
    
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
            ZStack(alignment: .topLeading){
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .opacity(1.0)
                
                HStack(alignment: .top){
                    
                    NavigationLink(destination: chooseActivity(), label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 45))
                            .foregroundColor(.black)
                        
                    }).padding(.leading, 25)
                        .padding(.top, 20)

                    
                    Spacer()
                    VStack(spacing: 0){
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 50)
                            .shadow(radius: 10)
                            .padding()
                        
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 30))
                        }.padding(.trailing, 50)
                    }
                    
                }
                
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.20)
                    .offset(x: 380, y: animatingBear ? 90 : 200)
                
                VStack{
                    
                    shortStoryContainerIPAD(showInfoPopup: $showInfoPopup, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        .frame(width:  geo.size.width * 0.9, height: geo.size.height * 0.75)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 5))
                        .padding([.leading, .trailing], geo.size.width * 0.05)
                        .padding([.top, .bottom], geo.size.height * 0.18)
                }
                
                if showInfoPopup{
                    VStack{
                        Text("Do your best to read and understand the following short stories on various topics. \n \nWhile you read, pay attention to key vocabulary words as you will be quizzed after on your comprehension!")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Marker Felt", size: 30))
                            .padding(35)
                    }.frame(width: 500, height: 385)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                        .offset(x: geo.size.width / 5, y: geo.size.height / 3)
                }
                
                if attemptToBuyPopUp{
                    VStack{
                        VStack{
                            Text("Do you want to spend 25 of your coins to unlock the '" + String(attemptedBuyName) + "' flash card set?")
                                .multilineTextAlignment(.center)
                                .padding()
                                .font(Font.custom("Futura", size: 20))
                            
                            if notEnoughCoins{
                                Text("Sorry! You don't have enough coins!")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                }, label: {Text("Yes")  .font(Font.custom("Futura", size: 30))})
                                Spacer()
                                Button(action: {
                                    attemptToBuyPopUp = false
                                }, label: {Text("No")  .font(Font.custom("Futura", size: 30))})
                                Spacer()
                            }
                            
                        }
                    }.frame(width: 500, height: 385)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                        .offset(x: geo.size.width / 5, y: geo.size.height / 3)
                    
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

struct shortStoryContainerIPAD: View {
    @Binding var showInfoPopup: Bool
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Text("Short Stories").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 50))
                        .foregroundColor(.white)
                    
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
                } .frame(width: 740, height: 100)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
                bookHStackIPAD(attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                
            }.zIndex(1)
            
        }
    }
}

struct bookHStackIPAD: View {
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        
        let bookTitles: [String] = ["Cristofo Columbo", "test1", "test2", "test3", "test4", "test5"]
        
        ScrollView{
            VStack{
                VStack{
                    Text("Beginner")
                        .font(Font.custom("Marker Felt", size: 40))
                        .frame(width: 225)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButtonIPAD(shortStoryName: bookTitles[0], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButtonIPAD(shortStoryName:bookTitles[1], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 125)
                        .padding(.bottom, 10)
                        .padding(.top, 40)
                    HStack{
                        bookButtonIPAD(shortStoryName: bookTitles[2], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButtonIPAD(shortStoryName: bookTitles[3], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 110)
                }
                VStack{
                    Text("Intermediate")
                        .font(Font.custom("Marker Felt", size: 40))
                        .frame(width: 275)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButtonIPAD(shortStoryName: bookTitles[2], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButtonIPAD(shortStoryName: bookTitles[3], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 110)
                }
                VStack{
                    Text("Hard")
                        .font(Font.custom("Marker Felt", size: 40))
                        .frame(width: 175)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButtonIPAD(shortStoryName:bookTitles[4], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButtonIPAD(shortStoryName: bookTitles[5], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 110)
                }
            }
        }
        
    }
    
}

struct bookButtonIPAD: View {
    
    @EnvironmentObject var globalModel: GlobalModel
    
    let lockedStories: [String] = ["test2", "test3", "test4", "test5"]
    
    var shortStoryName: String
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    @State var pressed = false
    
    var body: some View{
        ZStack {
            if lockedStories.contains(shortStoryName){
                if !checkIfUnlockedAudio(dataSetName: shortStoryName){
                    VStack(spacing: 0){
                        
                        Button(action: {
                            attemptToBuyPopUp.toggle()
                            attemptedBuyName = shortStoryName
                        }, label: {
                            Image("book3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .padding()
                                .background(.white)
                                .cornerRadius(80)
                                .overlay( RoundedRectangle(cornerRadius: 60)
                                    .stroke(.black, lineWidth: 3))
                                .shadow(radius: 10)
                                .opacity(0.40)
                        }).overlay(
                            VStack(spacing: 0){
                                Image("coin2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 75)
                                Text("25")
                                    .font(Font.custom("Arial Hebrew", size: 30))
                                    .bold()
                            }.offset(y:5)
                        )
                        
                        Text(shortStoryName)
                            .font(Font.custom("Futura", size: 20))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                           
                        
                    }.padding()
                    
                }else{
                    VStack(spacing: 0){
                        
                        NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName), label: {
                            Image("book3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .padding()
                                .background(.white)
                                .cornerRadius(60)
                                .overlay( RoundedRectangle(cornerRadius: 60)
                                    .stroke(.black, lineWidth: 3))
                                .shadow(radius: 10)
                        }).padding(.top, 5)
                            .simultaneousGesture(TapGesture().onEnded{
                                print("Hello world!")
                            })
                        
                        Text(shortStoryName)
                            .font(Font.custom("Futura", size: 20))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)

                        
                    }
                }
            }else{
                VStack(spacing: 0){
                    NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName), label: {
                        Image("book3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                            .padding()
                            .background(.white)
                            .cornerRadius(60)
                            .overlay( RoundedRectangle(cornerRadius: 60)
                                .stroke(.black, lineWidth: 3))
                            .shadow(radius: 10)
                        
                        
                    }).simultaneousGesture(TapGesture().onEnded{
                        print("Hello world!")
                    })
                    
                    
                    
                    Text(shortStoryName)
                        .font(Font.custom("Futura", size: 20))
                        .frame(width: 130, height: 80)
                        .multilineTextAlignment(.center)
                }
                
            }
        }
    }
    
    func checkIfUnlockedAudio(dataSetName: String)->Bool{
        var tempBool = false
        for i in 0...globalModel.currentUnlockableDataSets.count - 1 {
            if globalModel.currentUnlockableDataSets[i].setName == dataSetName {
                tempBool = globalModel.currentUnlockableDataSets[i].isUnlocked
            }
        }
       return tempBool
    }
}


struct availableShortStoriesIPAD_Previews: PreviewProvider {
    static var previews: some View {
        availableShortStoriesIPAD().environmentObject(GlobalModel())
    }
}

