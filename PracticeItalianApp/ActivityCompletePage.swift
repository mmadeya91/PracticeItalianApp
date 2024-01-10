//
//  ActivityCompletePage.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 9/17/23.
//

import SwiftUI

struct ActivityCompletePage: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    //@State var questionCount: Int
    //@State var correctCount: Int
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var counter1 = 0
    @State private var counter2 = 0
    @State var animatingBear = false
    @State var goNext = false
    
    @FetchRequest(
        sortDescriptors: [
            //SortDescriptor(\.userCoins)
        ]
    ) var userCoins: FetchedResults<UserCoins>
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
                Image("abstractBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                ZStack{
                    HStack{
                        Image("coin2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 15)
                        
                        Text("\(self.counter2)")
                            .font(Font.custom("Arial Hebrew", size: 22))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    
                                    
                                    self.runCounter(counter: self.$counter2, start: globalModel.userCoins, end: (globalModel.userCoins + 15), speed: 0.05)
                                }
                            }
                        
                        Spacer()
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                            .padding()
                        
                    }.padding(.bottom, 600)
                        .zIndex(2)
                    VStack{
                        VStack{
                            Text("Nice Work!")
                                .font(Font.custom("Arial Hebrew", size: 35))
                            
                            
                        }
                        VStack{
                            Image("sittingBear")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 100)
                                .shadow(radius: 10)
                                .offset(y: animatingBear ? ((geo.size.height / 2 ) - 275) : -800)
                            
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .shadow(radius: 10)
                                .offset(y: 40)
                            
                            Text("+"+"\(self.counter1)")
                                .font(Font.custom("Arial Hebrew", size: 40))
                                .padding(.trailing, 5)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        
                                        
                                        self.runCounter(counter: self.$counter1, start: 0, end: 15, speed: 0.05)
                                    }
                                }.padding(.top, 45)
                        }
                        
                        Button {
                            updateUserCoins()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                
                                goNext = true
                            }
                            
                            
                        } label: {
                            Text("Continue")
                                .font(Font.custom("Arial Hebrew", size: 25))
                                .foregroundColor(.black)
                                .padding(.top, 5)
                                .frame(width: 150, height: 50)
                                .background(.teal)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 4)
                                )
                                .cornerRadius(20)
                                .padding(.top, 10)
                                .shadow(radius: 10)
                        }
                        
                        NavigationLink(destination: chooseActivity(),isActive: $goNext,label:{}
                        ).isDetailLink(false)
                        
                    }
                }.onAppear{
                    counter2 = globalModel.userCoins
                    withAnimation(.interpolatingSpring(stiffness: 150, damping: 13).delay(0.5)){
                        animatingBear = true
                    }
                }
            } else{
                ActivityCompletePageIPAD()
            }
        
        }.navigationBarBackButtonHidden(true)
       
    }
    
    
    func updateUserCoins(){
            userCoins[0].coins = Int32((globalModel.userCoins + 15))
            globalModel.userCoins = (globalModel.userCoins + 15)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error saving")
        }
    }
    
    
    func runCounter(counter: Binding<Int>, start: Int, end: Int, speed: Double) {
        let maxSteps = 20
        counter.wrappedValue = start
        
        let steps = min(abs(end), maxSteps)
        var increment = 1
        if steps == maxSteps {increment = end/maxSteps}
        
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            counter.wrappedValue += increment
            if counter.wrappedValue >= end {
                counter.wrappedValue = end
                timer.invalidate()
            }
        }
    }
    
    
}


struct ActivityCompletePage_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCompletePage().environmentObject(GlobalModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
