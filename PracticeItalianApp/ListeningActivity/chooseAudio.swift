//
//  chooseAudio.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/7/23.
//

import SwiftUI

struct chooseAudio: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @State var animatingBear = false
    @State var showInfoPopup = false
    @State var attemptToBuyPopUp = false
    @State var attemptedBuyName = "temp"
    @State private var notEnoughCoins = false
    
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
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                    .padding(.bottom, 50)
                
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
                }.zIndex(2).offset(y:-400)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: -65, y: animatingBear ? -270 : 0)
                
                
                VStack{
                    
                    
                    shortStoryContainer2(showInfoPopUp: $showInfoPopup, attemptToBuyPupUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName).frame(width:345, height: 600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 100)
                    .padding(.bottom, 80)
                    
                }
                
                if showInfoPopup{
                    VStack{
                        Text("Listen to the following dialogues performed by a native Italian speaker. \n \nDo your best to comprehend the audio and answer the questions to the best of your ability!")
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
                            Text("Do you want to spend 25 of your coins to unlock the '" + String(attemptedBuyName) + "' flash card set?")
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
                withAnimation(.easeIn(duration: 1.5)){
                    animatingBear = true
                }
            }.navigationBarBackButtonHidden(true)
        }
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

struct shortStoryContainer2: View {
    @Binding var showInfoPopUp: Bool
    @Binding var attemptToBuyPupUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        ZStack{
            VStack{
                
                HStack{
                    Text("Audio Stories").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
                        .foregroundColor(.white)
                    
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
                } .frame(width: 350, height: 60)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
                
                audioHStack(attemptToBuyPopUp: $attemptToBuyPupUp, attemptedBuyName: $attemptedBuyName)
                
            }
            
        }
    }
}

struct audioHStack: View {
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        
        let bookTitles: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
        
        ScrollView{
            VStack{
                Text("Beginner")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 120, height: 30)
                    .padding(.top, 10)
                    .border(width: 3, edges: [.bottom], color: .teal)
                HStack{
                    audioChoiceButton(shortStoryName: bookTitles[0], audioImage: "pot", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    audioChoiceButton(shortStoryName:bookTitles[1], audioImage: "dinner", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                }.padding([.leading, .trailing], 35)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                Text("Intermediate")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 175, height: 30)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    audioChoiceButton(shortStoryName: bookTitles[2], audioImage: "directions", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[3], audioImage: "clothesStore", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                }.padding([.leading, .trailing], 28)
                    .padding(.top, 20)
                
                Text("Hard")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 75, height: 30)
                    .padding(.top, 20)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    audioChoiceButton(shortStoryName:bookTitles[4], audioImage: "renaissance", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                }.padding([.leading, .trailing], 28)
                    .padding(.bottom, 10)
                    .padding(.top, 20)
            }
        }
        
    }
    
}

struct audioChoiceButton: View {
    @EnvironmentObject var globalModel: GlobalModel
    
    @StateObject var listeningActivityViewModel = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    
    var shortStoryName: String
    var audioImage: String
    
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    let lockedStories: [String] = ["Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
    
    var body: some View{
        ZStack {
            if lockedStories.contains(shortStoryName){
                if !checkIfUnlockedAudio(dataSetName: shortStoryName){
                    VStack(spacing: 0){
                        
                        Button(action: {
                            attemptToBuyPopUp.toggle()
                            attemptedBuyName = shortStoryName
                        }, label: {
                            Image(audioImage)
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
                        
                        Text(shortStoryName)
                            .font(Font.custom("Marker Felt", size: 20))
                            .frame(width: 120, height: 85)
                            .multilineTextAlignment(.center)
                           
                        
                    }.padding()
                    
                }else{
                    VStack(spacing: 0){
                        
                        NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                            Image(audioImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                                .padding()
                                .background(.white)
                                .cornerRadius(60)
                                .overlay( RoundedRectangle(cornerRadius: 60)
                                    .stroke(.black, lineWidth: 3))
                                .shadow(radius: 10)
                        }).padding(.top, 5)
                            .simultaneousGesture(TapGesture().onEnded{
                                listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                            })
                        
                        Text(shortStoryName)
                            .font(Font.custom("Marker Felt", size: 20))
                            .frame(width: 100, height: 85)
                            .multilineTextAlignment(.center)

                        
                    }
                }
            }else{
                VStack(spacing: 0){
                    NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                        Image(audioImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                        
                            .padding()
                            .background(.white)
                            .cornerRadius(60)
                            .overlay( RoundedRectangle(cornerRadius: 60)
                                .stroke(.black, lineWidth: 3))
                            .shadow(radius: 10)
                        
                        
                    }).simultaneousGesture(TapGesture().onEnded{
                        listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                    })
                    
                    
                    
                    Text(shortStoryName)
                        .font(Font.custom("Futura", size: 18))
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


struct chooseAudio_Previews: PreviewProvider {
    static var previews: some View {
        chooseAudio()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
    }
}
