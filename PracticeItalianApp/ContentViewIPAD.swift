//
//  ContentViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 12/23/23.
//

import SwiftUI

struct ContentViewIPAD: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var globalModel: GlobalModel
    
    @State var animate: Bool = false
    @State var showBearAni: Bool = false
    @State private var var_x = 1
    @State var goNext: Bool = false
    @State var navButtonText = "Let's Go!"
    @State var togglePageReload = false
    
    
    @FetchRequest(
        entity: UserCoins.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedUserCoins: FetchedResults<UserCoins>
    
    @FetchRequest(
        entity: UserUnlockedDataSets.entity(),
        sortDescriptors: [NSSortDescriptor(key: "dataSetName", ascending: true)]
    ) var fetchedUserUnlockedData: FetchedResults<UserUnlockedDataSets>
    
    var body: some View{
        GeometryReader{ geo in
        NavigationView{
                ZStack(alignment: .topLeading){
                    Image("vectorRome")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .opacity(1.0)
                    VStack{
                        
                        VStack{
                            Text("Italian")
                                .bold()
                                .font(Font.custom("Marker Felt", size: 50))
                                .foregroundColor(Color.green)
                                .zIndex(1)
                            
                            Text("Mastery!")
                                .bold()
                                .font(Font.custom("Marker Felt", size: 50))
                                .foregroundColor(Color.red)
                        }.frame(width: geo.size.width * 0.7, height: geo.size.height * 0.4)
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(10)
                            .offset(y: geo.size.height / 9)
                            .padding([.leading, .trailing], geo.size.width * 0.15)
                        
                        
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                                
                                goNext = true
                            }
                            showBearAni.toggle()
                            SoundManager.instance.playSound(sound: .introMusic)
                            navButtonText = "Andiamo!"
                            
                        } label: {
                            Text(navButtonText)
                                .font(Font.custom("Marker Felt", size: 24))
                                .foregroundColor(Color.black)
                                .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.06)
                                .background(Color.teal.opacity(0.5))
                                .cornerRadius(20)
                        }.offset(y: geo.size.height / 7)
                        
                        NavigationLink(destination: chooseActivity(),isActive: $goNext,label:{}
                        ).isDetailLink(false)
                        
                    }
                    VStack{
                        Text(String(globalModel.userCoins))
                    }
                    
                    
                    if showBearAni {
                        GifImage("italAppGif")
                            .offset(x: CGFloat(-var_x*700+240), y: (geo.size.height / 2 + 70))
                            .animation(.linear(duration: 11 ))
                            .onAppear { self.var_x *= -1}
                        
                    }
                    
                    
                }.onAppear{
                    addUserCoinsifNew()
                    addUserUnlockedDataifNew()
                    //togglePageReload.toggle()
                }
            }.navigationViewStyle(.stack)
        }.preferredColorScheme(.light)
    }
    
    func addUserCoinsifNew(){
        if !userCoinsExists() {
 
            let newUserCoins = UserCoins(context: viewContext)
            newUserCoins.coins = 0
            newUserCoins.id = UUID()
     
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            
        }else{
            globalModel.userCoins = Int(fetchedUserCoins[0].coins)
        }
        
        
    }
    
    func addUserUnlockedDataifNew(){
        if !userUnlockedDataExists() {
            //AudioFiles
            let userUnlockedData = UserUnlockedDataSets(context: viewContext)
            userUnlockedData.dataSetName = "Stili di Bellagio"
            userUnlockedData.isUnlocked = false
            let userUnlockedData2 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData2.dataSetName = "Indicazioni per gli Uffizi"
            userUnlockedData2.isUnlocked = false
            let userUnlockedData3 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData3.dataSetName = "Il Rinascimento"
            userUnlockedData3.isUnlocked = false
            //FlashCardSets
            let userUnlockedData4 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData4.dataSetName = "Food"
            userUnlockedData4.isUnlocked = false
            //ShortStories
            let userUnlockedData5 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData5.dataSetName = "test2"
            userUnlockedData5.isUnlocked = false
            let userUnlockedData6 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData6.dataSetName = "test3"
            userUnlockedData6.isUnlocked = false
            let userUnlockedData7 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData7.dataSetName = "test4"
            userUnlockedData7.isUnlocked = false
            let userUnlockedData8 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData8.dataSetName = "test5"
            userUnlockedData8.isUnlocked = false
          
     
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            
        }else{
            setGlobalUserUnlockedData()
        }
        
        
    }
    
    func userCoinsExists() -> Bool {
        
        let fR =  UserCoins.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return false
            }else {
                return true
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
    func userUnlockedDataExists() -> Bool {
        
        let fR =  UserUnlockedDataSets.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return false
            }else {
                return true
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
    func setGlobalUserUnlockedData(){
        for dataSet in fetchedUserUnlockedData {
            for i in 0...globalModel.currentUnlockableDataSets.count-1{
                if globalModel.currentUnlockableDataSets[i].setName == dataSet.dataSetName {
                    globalModel.currentUnlockableDataSets[i].isUnlocked = dataSet.isUnlocked
                }
            }
        }
    }
    
}



struct ContentViewIPAD_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewIPAD().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
            .environmentObject(GlobalModel())
    }
}
