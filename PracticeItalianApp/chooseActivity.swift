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
                        .stroke(.yellow, lineWidth: 6))
    }
}


struct chooseActivity: View {
    
    @EnvironmentObject var audioManager: AudioManager
    
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("watercolor2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack{
                    Text("Exercises").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 35))
                        .padding(.bottom, 5)
                        .frame(width: 357, height: 60)
                        .background(Color.teal).opacity(0.75)
                        .cornerRadius(13)
                        .border(width: 8, edges: [.bottom], color: .yellow)
                        .padding(.bottom, 15)
                    HStack{
                        VStack{
                            NavigationLink(destination: availableShortStories(), label: {Image("reading-book")
                                    .imageIconModifier()
                            })
                            Text("Reading")
                                .bold()
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .frame(width: 120, height: 50)
                            
                        }
                        Spacer()
                        VStack{
                            
                            
                            NavigationLink(destination: chooseAudio(), label: {
                                Image("talking")
                                    .imageIconModifier()
                            })
                            Text("Listening")
                                .bold()
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .frame(width: 120, height: 50)
                        }
                    }.padding([.leading, .trailing], 45)
                        .padding(.bottom, 75)
          
                    HStack{
                        VStack{
                            NavigationLink(destination: chooseFlashCardSet(), label: {
                                Image("flash-card")
                                    .imageIconModifier()
                            })
                            Text("Flash Cards")
                                .bold()
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .frame(width: 120, height: 50)
                        }
                        Spacer()
                        VStack{
                            NavigationLink(destination: chooseTense(), label:{
                                Image("spell-check")
                                    .imageIconModifier()
                            })
                            Text("Verb Conjugation")
                                .bold()
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .frame(width: 120, height: 50)
                                .multilineTextAlignment(.center)
                        }
                    }.padding([.leading, .trailing], 45)
                }
            }
        }.navigationBarHidden(true)
    }
}

struct chooseActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseActivity()
                .environmentObject(AudioManager())
          
    }
}
