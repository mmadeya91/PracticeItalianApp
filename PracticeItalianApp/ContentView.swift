//
//  ContentView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI
import CoreData

class GlobalModel: ObservableObject {
    @Published var userCoins = 0
    
    @Published var currentUnlockableDataSets: [dataSetObject] = [dataSetObject(setName: "Uffizi", isUnlocked: false),
         dataSetObject(setName: "Bellagio", isUnlocked: false),
         dataSetObject(setName: "Rinascimento", isUnlocked: false),
         dataSetObject(setName: "Food", isUnlocked: false)]
    
    struct dataSetObject: Identifiable{
        var id = UUID()
        var setName: String
        var isUnlocked: Bool
        
        
    }
    
}


struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
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
        NavigationView{
            GeometryReader{ geo in
                ZStack{
                    Image("vectorRome")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: 1000, alignment: .center)
                        .opacity(1.0)
                    VStack{
                        
                        homePageText()
                            .padding(.bottom, 100)
                            .padding(.top, 100)
                        
         
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
                            .offset(x: CGFloat(-var_x*700+240), y: 500)
                            .animation(.linear(duration: 11 ))
                            .onAppear { self.var_x *= -1}
                    }
 
   
                }.onAppear{
                    addUserCoinsifNew()
                    addUserUnlockedDataifNew()
                   //togglePageReload.toggle()
                }
            }
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
 
            let userUnlockedData = UserUnlockedDataSets(context: viewContext)
            userUnlockedData.dataSetName = "Bellagio"
            userUnlockedData.isUnlocked = false
            let userUnlockedData2 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData2.dataSetName = "Uffizi"
            userUnlockedData2.isUnlocked = false
            let userUnlockedData3 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData3.dataSetName = "Rinascimento"
            userUnlockedData3.isUnlocked = false
            let userUnlockedData4 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData4.dataSetName = "Food"
            userUnlockedData4.isUnlocked = false
     
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
