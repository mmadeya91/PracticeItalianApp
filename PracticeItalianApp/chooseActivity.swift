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
    
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                HStack{
                    Image("coin2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
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
                    
                }.zIndex(2).offset(y:-360)
                
                Image("bubbleChat2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 40)
                    .offset(x: -30, y: -315)
                    .opacity(showChatBubble ? 1.0 : 0.0)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: 70, y: animatingBear ? -250 : 0)
                
                
                
                VStack{
                    Text("Exercises")
                        .font(Font.custom("Marker Felt", size: 35))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                        .frame(width: 357, height: 75)
                        .background(Color("DarkNavy")).opacity(0.75)
                        .cornerRadius(13)
                        .border(width: 8, edges: [.bottom], color: .teal)
                        .padding(.bottom, 15)
                    
                    HStack{
                        VStack{
                            NavigationLink(destination: availableShortStories(), label: {Image("reading-book")
                                    .imageIconModifier()
                            })
                            Text("Reading")
                                .bold()
                                .font(Font.custom("Marker Felt", size: 20))
                                .frame(width: 120, height: 60)
                            
                        }.padding(.trailing, 20)
                        VStack{
                            
                            
                            NavigationLink(destination: chooseAudio(), label: {
                                Image("talking")
                                    .imageIconModifier()
                            })
                            Text("Listening")
                                .bold()
                                .font(Font.custom("Marker Felt", size: 20))
                                .frame(width: 120, height: 60)
                        }
                    }
                    .padding([.leading, .trailing], 45)
                    .padding(.top, 30)
                    .padding(.bottom, 5)
                    
          
                    HStack{
                        VStack{
                            NavigationLink(destination: chooseFlashCardSet(), label: {
                                Image("flash-card")
                                    .imageIconModifier()
                            })
                            Text("Flash Cards")
                                .bold()
                                .font(Font.custom("Marker Felt", size: 20))
                                .frame(width: 120, height: 60)
                        }.padding(.trailing, 20)
                        VStack{
                            NavigationLink(destination: chooseVerbList(), label:{
                                Image("spell-check")
                                    .imageIconModifier()
                            })
                            Text("Verb" + "\nConjugation")
                                .bold()
                                .font(Font.custom("Marker Felt", size: 20))
                                .frame(width: 120, height: 60)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding([.leading, .trailing], 45)
                    .padding(.bottom, 50)
                }.frame(width:345).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 5))
                    .shadow(radius: 10)
                    .padding(.top, 60)
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
