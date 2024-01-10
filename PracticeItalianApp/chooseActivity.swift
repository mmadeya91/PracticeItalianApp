//
//  chooseActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/13/23.
//

import SwiftUI

extension Image {
    
    func imageIconModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(10)
            .frame(width: 115, height: 120)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 6))
    }
}


struct chooseActivity: View {
    @State var animatingBear = false
    @State var showChatBubble = false
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    
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
                    
                    HStack{
                        Image("coin2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 40)
                            .padding(.leading, 15)
                        
                        Text(String(globalModel.userCoins))
                            .font(Font.custom("Arial Hebrew", size: 22))
                        
                        Spacer()
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                            .padding()
                        
                    }
                    
                    Image("bubbleChat2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 40)
                        .offset(x: 100, y: 25)
                        .opacity(showChatBubble ? 1.0 : 0.0)
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.20)
                        .offset(x: 150, y: animatingBear ? 73 : 200)
                    
                    
                    
                    VStack(spacing: 0){
                        Text("Exercises")
                            .font(Font.custom("Marker Felt", size: geo.size.width * 0.08))
                            .foregroundColor(.white)
                            .frame(width: geo.size.width, height: geo.size.width * 0.20)
                            .background(Color("DarkNavy")).opacity(0.75)
                            .cornerRadius(13)
                            .border(width: 8, edges: [.bottom], color: .teal)
                        
                        VStack(spacing: 0){
                            HStack{
                                Spacer()
                                VStack{
                                    NavigationLink(destination: availableShortStories(), label: {Image("reading-book")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                            .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.27)
                                            .background(.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.black, lineWidth: 6))
                                    })
                                    Text("Reading")
                                        .bold()
                                        .font(Font.custom("Marker Felt", size: geo.size.width * 0.05))
                                        .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.1)
                                    
                                }
                                Spacer()
                                VStack{
                                    
                                    
                                    NavigationLink(destination: chooseAudio(), label: {
                                        Image("talking")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                            .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.27)
                                            .background(.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.black, lineWidth: 6))
                                    })
                                    Text("Listening")
                                        .bold()
                                        .font(Font.custom("Marker Felt", size: geo.size.width * 0.05))
                                        .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.1)
                                }
                                Spacer()
                            }
                            
                            
                            
                            HStack(spacing: 0){
                                Spacer()
                                VStack{
                                    NavigationLink(destination: chooseFlashCardSet(), label: {
                                        Image("flash-card")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                            .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.27)
                                            .background(.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.black, lineWidth: 6))
                                            .padding(.top, 55)
                                    })
                                    Text("Flash \nCards")
                                        .bold()
                                        .font(Font.custom("Marker Felt", size: geo.size.width * 0.05))
                                        .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.15)
                                    
                                }
                                
                                Spacer()
                                VStack{
                                    NavigationLink(destination: chooseVerbList(), label:{
                                        Image("spell-check")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                            .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.27)
                                            .background(.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.black, lineWidth: 6))
                                            .padding(.top, 55)
                                    })
                                    Text("Verb Conjugation")
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .font(Font.custom("Marker Felt", size: geo.size.width * 0.05))
                                        .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.15)
                                    
                                }
                                Spacer()
                            }
                        }.padding(.top, geo.size.height * 0.05)
                        
                        
                        Spacer()
                    }.frame(width:  geo.size.width * 0.85, height: geo.size.height * 0.78)
                    //.shadow(radius: 10)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 5))
                        .padding([.leading, .trailing], geo.size.width * 0.075)
                        .padding([.top, .bottom], geo.size.height * 0.15)
                    //.offset(y: (geo.size.height / 2) - (geo.size.height / 2.8))
                    
                    
                    
                    
                }
                .onAppear{
                    withAnimation(.easeIn(duration: 1.5)){
                        animatingBear = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        showChatBubble = true
                    }
                    
                    flashCardSetAccObj.checkSetData()
                    
                }
                }else{
                    chooseActivityIPAD()
                }
            }
            .navigationBarHidden(true)
   
    }
}

struct chooseActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseActivity().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
        
        
    }
}
