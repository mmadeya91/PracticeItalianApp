//
//  availableShortStories.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/9/23.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct availableShortStories: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                                    .frame(width: 40, height: 40)
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
                        
                        shortStoryContainer(showInfoPopup: $showInfoPopup, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
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
                            .offset(x: geo.size.width / 7, y: geo.size.height / 3)
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
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                }
            }else{
                availableShortStoriesIPAD()
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

struct shortStoryContainer: View {
    @Binding var showInfoPopup: Bool
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Text("Short Stories").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
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
                } .frame(width: 450, height: 60)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
                bookHStack(attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                
            }.zIndex(1)
            
        }
    }
}

struct bookHStack: View {
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        
        let bookTitles: [String] = ["La Mia Introduzione", "Il Mio Migliore Amico", "La Mia Famiglia", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana"]
        
        ScrollView{
            VStack{
                VStack{
                    Text("Beginner")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 175, height: 30)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButton(shortStoryName: bookTitles[0], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButton(shortStoryName:bookTitles[1], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 65)
                        .padding(.bottom, 10)
                    HStack{
                        bookButton(shortStoryName: bookTitles[2], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 55)
                }
                VStack{
                    Text("Intermediate")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 175, height: 30)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButton(shortStoryName: bookTitles[3], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButton(shortStoryName: bookTitles[4], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 55)
                }
                VStack{
                    Text("Hard")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 75, height: 30)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButton(shortStoryName:bookTitles[5], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButton(shortStoryName: bookTitles[6], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    }.padding([.leading, .trailing], 55)
                }
            }
        }
        
    }
    
}

struct bookButton: View {
    
    @EnvironmentObject var globalModel: GlobalModel
    
    let lockedStories: [String] = ["La Mia Famiglia", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana"]
    
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
                           
                        
                    }.padding()
                    
                }else{
                    VStack(spacing: 0){
                        
                        NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName), label: {
                            Image("book3")
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
                                print("Hello world!")
                            })
                        
                        Text(shortStoryName)
                            .font(Font.custom("Futura", size: 18))
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
                            .frame(width: 75, height: 75)
                        
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

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

struct availableShortStories_Previews: PreviewProvider {
    static var previews: some View {
        availableShortStories().environmentObject(GlobalModel())
    }
}
