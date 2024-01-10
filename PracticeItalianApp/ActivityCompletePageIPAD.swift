//
//  ActivityCompletePageIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/3/24.
//

import SwiftUI

struct ActivityCompletePageIPAD: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    //@State var questionCount: Int
    //@State var correctCount: Int
    @EnvironmentObject var globalModel: GlobalModel
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
            Image("abstractBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            ZStack(alignment: .topLeading){
                HStack{
                    Image("coin2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .padding(.leading, 15)
                    
                    Text("\(self.counter2)")
                        .font(Font.custom("Arial Hebrew", size: 27))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                
                                
                                self.runCounter(counter: self.$counter2, start: globalModel.userCoins, end: (globalModel.userCoins + 15), speed: 0.05)
                            }
                        }
                    
                    Spacer()
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .shadow(radius: 10)
                        .padding()
                    
                }
                VStack{
                    
                    VStack{
                        Text("Nice Work!")
                            .font(Font.custom("Arial Hebrew", size: 50))
                            .offset(y: geo.size.height / 8)

                        
                        Image("sittingBear")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 450, height: 200)
                            .shadow(radius: 10)
                            .offset(y: animatingBear ? ((geo.size.height / 2 ) - 275) : -800)
                        
                        Image("coin2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 180)
                            .shadow(radius: 10)
                            .offset(y: geo.size.height / 7)
                        
                        Text("+"+"\(self.counter1)")
                            .font(Font.custom("Arial Hebrew", size: 40))
                            .padding(.trailing, 5)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    
                                    
                                    self.runCounter(counter: self.$counter1, start: 0, end: 15, speed: 0.05)
                                }
                            }
                            .offset(y: geo.size.height / 5)
                    }.offset(x: geo.size.width / 5)
                    
                    Button {
                        updateUserCoins()
                       DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                           
                            goNext = true
                       }

                        
                    } label: {
                        Text("Continue")
                            .font(Font.custom("Arial Hebrew", size: 30))
                            .foregroundColor(.black)
                            .padding(.top, 5)
                            .frame(width: 220, height: 80)
                            .background(.teal)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .cornerRadius(20)
                            .shadow(radius: 10)
                    }.offset(x: (geo.size.width / 5), y: (geo.size.height / 5))
                    
                    NavigationLink(destination: chooseActivity(),isActive: $goNext,label:{}
                                ).isDetailLink(false)
                    
                }
            }.onAppear{
                counter2 = globalModel.userCoins
                withAnimation(.interpolatingSpring(stiffness: 150, damping: 13).delay(0.5)){
                    animatingBear = true
                }
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


struct ActivityCompletePageIPAD_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCompletePageIPAD().environmentObject(GlobalModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
