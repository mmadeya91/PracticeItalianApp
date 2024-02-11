//
//  ListeningActivityView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/8/23.
//

import SwiftUI

struct ListeningActivityView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    //@StateObject var listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    @State private var showPlayer2 = false
    
    var shortStoryName: String
    var isPreview: Bool
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                HStack(spacing: 18){
                    NavigationLink(destination: chooseAudio(), label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                        
                    }).padding(.leading, 25)
                    
                    Spacer()
                    
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 30)
                        .shadow(radius: 10)
                }
                
                
                
                ZStack{
                    VStack{
                        VStack{
                            VStack{
                                
                                ImageOnCircle(icon: listeningActivityVM.audioAct.image, radius: geo.size.width * 0.15)
                                    .padding(.top, 260)
                                   
                                
                                Text(listeningActivityVM.audioAct.title)
                                    .font(.title)
                                    .underline()
                                    .foregroundColor(.black)
                                    .padding(.bottom, 40)
                                
                                VStack(alignment: .leading){
                                    Text("Conversation")
                                    
                                    Text(DateComponentsFormatter.abbreviated.string(from: listeningActivityVM.audioAct.duration) ??
                                         listeningActivityVM.audioAct.duration.formatted() + "S")
                                }.padding(.trailing, 200)
                                    .padding(.bottom, 25)
                                
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
                                    .frame(width: 280, height: 50)
                                    .background(Color("WashedWhite"))
                                    .cornerRadius(20)
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.black, lineWidth: 4)
                                    )
                            }).padding(.bottom, 20)
                            
                            VStack{
                                Text(String(listeningActivityVM.audioAct.description))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(width: 300, height: 10)
                            }.padding(.top, 40)
                            
                            Text("Audio and Transcriptions by Virginia Billie")
                                .font(Font.custom("Hebrew Arial", size: 18))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding([.leading, .trailing], 20)
                                .frame(width: 360, height: 70)
                                .background(Color("WashedWhite"))
                                .cornerRadius(20)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 6)
                                )
                                .offset(y:100)
                            
                        }.zIndex(1)
                            .padding(20)
                        
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("DarkNavy"))
                            .frame(width: 350, height: 350)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .shadow(radius: 10)
                            .offset(y: -330)
                            .padding([.leading, .trailing], 10)
                            .zIndex(0)
                        
                        
                        
                    }.foregroundColor(.white)
                    
                    NavigationLink(destination: listeningActivity(listeningActivityVM: listeningActivityVM),isActive: $showPlayer2,label:{}
                    ).isDetailLink(false)
                    
                }  .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .navigationBarBackButtonHidden(true)
                
            }else{
                ListeningActivityViewIPAD(listeningActivityVM: listeningActivityVM, shortStoryName: shortStoryName, isPreview: false)
            }
        }
    
        
        
    }
}

struct ImageOnCircle: View {
    
    let icon: String
    let radius: CGFloat
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("WashedWhite"))
                .frame(width: radius * 2, height: radius * 2)
                .overlay(Circle().stroke(.black, lineWidth: 3))
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}

struct ListeningActivityView_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    static var previews: some View {
        ListeningActivityView(listeningActivityVM: listeningActivityVM, shortStoryName: "Pasta Carbonara", isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
