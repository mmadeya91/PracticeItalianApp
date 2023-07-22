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
            .frame(width: 100, height: 100)
            .padding()
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("DarkRed"), lineWidth: 6))
    }
}


struct chooseActivity: View {
    @State var animatingBear = false
    @EnvironmentObject var audioManager: AudioManager
    
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: 85, y: animatingBear ? -260 : 0)
                
                
                
                VStack{
                    Text("Exercises")
                        .font(Font.custom("Marker Felt", size: 35))
                        .padding(.bottom, 5)
                        .frame(width: 357, height: 75)
                        .background(Color("ForestGreen")).opacity(0.75)
                        .cornerRadius(13)
                        .border(width: 8, edges: [.bottom], color: Color("DarkRed"))
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
                    .stroke(.black, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 60)
            }
            .onAppear{
                withAnimation(.easeIn(duration: 1.5)){
                    animatingBear = true
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct chooseActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseActivity()
                .environmentObject(AudioManager())
          
    }
}
