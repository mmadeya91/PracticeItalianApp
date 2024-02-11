//
//  chooseAudio.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/7/23.
//

import SwiftUI

struct chooseAudio: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
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
            if horizontalSizeClass == .compact {
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
                            
                            HStack{
                                Image("coin2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                Text(String(globalModel.userCoins))
                                    .font(Font.custom("Arial Hebrew", size: 22))
                            }.padding(.trailing, 50)
                        }
                        
                    }
                    
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.20)
                        .offset(x: 50, y: animatingBear ? 90 : 200)
                    
                    VStack{
                        
                        
                        shortStoryContainer2(showInfoPopUp: $showInfoPopup, attemptToBuyPupUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName).frame(width:  geo.size.width * 0.9, height: geo.size.height * 0.75)
                            .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 5))
                            .padding([.leading, .trailing], geo.size.width * 0.05)
                            .padding([.top, .bottom], geo.size.height * 0.155)
                    }.padding(.top, 8)
                    
                    if showInfoPopup{
                        ZStack(alignment: .topLeading){
                            Button(action: {
                                showInfoPopup.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 15)
                                .zIndex(1)
                                .offset(y: -15)
                           
                         
             
                                
                                Text("Listen to the following dialogues performed by a native Italian speaker. \n \nDo your best to comprehend the audio and answer the questions to the best of your ability!")
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
                    
                    
                    if attemptToBuyPopUp{
                        VStack{
                            VStack{
                                Text("Do you want to spend 25 of your coins to unlock the '" + String(attemptedBuyName) + "' Audio Activity?")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                if notEnoughCoins{
                                    Text("Sorry! You don't have enough coins!")
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                        
                                        attemptToBuyPopUp = false
                                    }, label: {Text("Yes")
                                            .font(.system(size: 20))
                                    })
                                    Spacer()
                                    Button(action: {
                                        attemptToBuyPopUp = false
                                    }, label: {Text("No")
                                            .font(.system(size: 20))
                                    })
                                    Spacer()
                                }.padding(.top, 20)
                                
                            }
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
                    
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeIn(duration: 1.5)){
                            
                            animatingBear = true
                            
                            
                        }
                    }
                }.navigationBarBackButtonHidden(true)
            }else{
                chooseAudioIPAD()
            }
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
     
        VStack(spacing: 0){
                
                HStack{
                    Text("Audio Stories").zIndex(1)
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
                
                
                
                audioHStack(attemptToBuyPopUp: $attemptToBuyPupUp, attemptedBuyName: $attemptedBuyName)
                
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
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[0], audioImage: "pot", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    audioChoiceButton(shortStoryName:bookTitles[1], audioImage: "dinner", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                }
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                Text("Intermediate")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 175, height: 30)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[2], audioImage: "directions", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[3], audioImage: "clothesStore", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                }
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
                            .font(Font.custom("Futura", size: 18))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                           
                        
                    }
                    
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
                            .font(Font.custom("Futura", size: 18))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)

                        
                    }
                }
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
