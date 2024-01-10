//
//  ListeningActivityViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/3/24.
//

import SwiftUI

struct ListeningActivityViewIPAD: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    //@StateObject var listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    @State private var showPlayer2 = false
    
    var shortStoryName: String
    var isPreview: Bool
    
    var body: some View {
        GeometryReader{geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            HStack(spacing: 18){
                NavigationLink(destination: chooseAudio(), label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 45))
                        .foregroundColor(.gray)
                    
                }).padding(.leading, 25)
                
                Spacer()
                
                Image("italyFlag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .padding(.trailing, 30)
                    .shadow(radius: 10)
            }
            
            
            
            ZStack{
                VStack{
                    VStack{
                        VStack{
                            
                            Image(String(listeningActivityVM.audioAct.image))
                                .resizable()
                                .scaledToFill()
                                .padding(60)
                                .frame(width: geo.size.width * 0.45, height: geo.size.height * 0.3)
                                .background(Color("WashedWhite"))
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 200)
                                        .stroke(.black, lineWidth: 7)
                                )
                                .cornerRadius(200)
                                .padding(.top, 310)
                                .shadow(radius: 10)
                            
                            Text(listeningActivityVM.audioAct.title)
                                .font(.title)
                                .underline()
                                .foregroundColor(.black)
                                .padding(.bottom, 40)
                            
                            VStack(alignment: .leading){
                                Text("Conversation")
                                    .font(.system(size: 26))
                                   
                                Text(DateComponentsFormatter.abbreviated.string(from: listeningActivityVM.audioAct.duration) ??
                                     listeningActivityVM.audioAct.duration.formatted() + "S")
                            }.padding(.trailing, 350).padding(.top, 15)
                              
                            
                            
                        }
                        
                        Button(action: {
                            showPlayer2 = true
                            audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                        }
                               , label: {
                            Label("Play", systemImage: "play.fill")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.vertical, 10)
                                .frame(width: 340, height: 60)
                                .background(Color("WashedWhite"))
                                .cornerRadius(20)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 4)
                                )
                        }).padding(.bottom, 20)
                        
                        VStack{
                            Text(String(listeningActivityVM.audioAct.description))
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 500, height: 10)
                        }.padding(.top, 70)
                        
                        Text("Audio and Transcriptions by Virginia Billie")
                            .font(Font.custom("Hebrew Arial", size: 18))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 20)
                            .frame(width: 560, height: 70)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 6)
                            )
                            .offset(y:270)
                        
                    }.zIndex(1)
                        .padding(20)
                    
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("DarkNavy"))
                        .frame(width: 550, height: 580)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.black, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                        .offset(y: -350)
                        .padding([.leading, .trailing], 10)
                        .zIndex(0)
                    
                    
                    
                }.foregroundColor(.white)
                
                NavigationLink(destination: listeningActivity(listeningActivityVM: listeningActivityVM),isActive: $showPlayer2,label:{}
                                                  ).isDetailLink(false)
                
            }  .ignoresSafeArea()
                .frame(width: geo.size.width, height: geo.size.height)
                .navigationBarBackButtonHidden(true)
            
            
        }
        
        
        
    }
}

struct ListeningActivityViewIPAD_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    static var previews: some View {
        ListeningActivityViewIPAD(listeningActivityVM: listeningActivityVM, shortStoryName: "Pasta Carbonara", isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
