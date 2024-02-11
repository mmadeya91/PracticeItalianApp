//
//  ContentView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI
import SwiftUIKit
import CoreData

public protocol FullScreenCoverProvider {
    
    var cover: AnyView { get }
}


class GlobalModel: ObservableObject {
    @Published var userCoins = 0
    
    @Published var currentUnlockableDataSets:
    [
        //Audio Fles
        dataSetObject] = [dataSetObject(setName: "Indicazioni per gli Uffizi", isUnlocked: false),
         dataSetObject(setName: "Stili di Bellagio", isUnlocked: false),
         dataSetObject(setName: "Il Rinascimento", isUnlocked: false),
        //FlashCardSets
         dataSetObject(setName: "Food", isUnlocked: false),
        //ShortStories
         dataSetObject(setName: "La Mia Famiglia", isUnlocked: false),
         dataSetObject(setName: "Le Mie Vacanze in Sicilia", isUnlocked: false),
         dataSetObject(setName: "La Mia Routine", isUnlocked: false),
         dataSetObject(setName: "Ragù Di Maiale Brasato", isUnlocked: false),
         dataSetObject(setName: "Il Mio Fine Settimana", isUnlocked: false)
    ]
    
    
    struct dataSetObject: Identifiable{
        var id = UUID()
        var setName: String
        var isUnlocked: Bool
        
        
    }
    
}


struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
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
    
 
    var body: some View {
        if horizontalSizeClass == .compact{
            NavigationView{
                GeometryReader{ geo in
                    ZStack(alignment: .topLeading){
                        Image("vectorRome")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                            .opacity(1.0)
                        VStack{
                            
                            homePageText()
                                .padding(.bottom, 100)
                                .padding(.top, 175)
                                .padding(.leading, 14)
                            
                            
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                    
                                    goNext = true
                                }
                                showBearAni.toggle()
                                SoundManager.instance.playSound(sound: .introMusic)
                                navButtonText = "Andiamo!"
                                
                            } label: {
                                Text(navButtonText)
                                    .font(Font.custom("Marker Felt", size: 24))
                                    .foregroundColor(Color.black)
                                    .frame(width: 300, height: 50)
                                    .background(Color.teal.opacity(0.5))
                                    .cornerRadius(20)
                            }
                            
                            NavigationLink(destination: chooseActivity(),isActive: $goNext,label:{}
                            ).isDetailLink(false)
                            
                        }.offset(y:-170)
                        VStack{
                            Text(String(globalModel.userCoins))
                        }
                        
                        
                        if showBearAni {
                            GifImage("italAppGif")
                                .offset(x: CGFloat(-var_x*700+240), y: 400)
                                .animation(.linear(duration: 11 ))
                                .onAppear { self.var_x *= -1}
                            
                        }
                        
                        
                    }.onAppear{
                        addUserCoinsifNew()
                        addUserUnlockedDataifNew()
                        //togglePageReload.toggle()
                    }
                }
            }.navigationViewStyle(.stack)
                .preferredColorScheme(.light)
        }
        else{
            ContentViewIPAD()
        }
            
        
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
            userUnlockedData5.dataSetName = "La Mia Famiglia"
            userUnlockedData5.isUnlocked = false
            let userUnlockedData6 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData6.dataSetName = "Le Mie Vacanze in Sicilia"
            userUnlockedData6.isUnlocked = false
            let userUnlockedData7 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData7.dataSetName = "La Mia Routine"
            userUnlockedData7.isUnlocked = false
            let userUnlockedData8 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData8.dataSetName = "Ragù Di Maiale Brasato"
            userUnlockedData8.isUnlocked = false
            let userUnlockedData9 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData8.dataSetName = "Il Mio Fine Settimana"
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
    
    struct homePageText: View {
        var body: some View {
            
            ZStack{
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
                        .zIndex(1)
                }.frame(width: 350, height: 300)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    
            }
        }
    }
    
    

    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(AudioManager())
                .environmentObject(ListeningActivityManager())
                .environmentObject(GlobalModel())
        }
    }
}


