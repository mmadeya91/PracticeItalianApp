//
//  ContentView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var animate: Bool = false
    @State var showBearAni: Bool = false
    @State private var var_x = 1
    @State var goNext: Bool = false
    @State var navButtonText = "Let's Go!"
    
    var body: some View {
        NavigationView{
            GeometryReader{ geo in
                ZStack{
                    Image("homeWallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
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
                    
                    if showBearAni {
                        GifImage("italAppGif")
                            .offset(x: CGFloat(-var_x*700+240), y: 500)
                            .animation(.linear(duration: 11 ))
                            .onAppear { self.var_x *= -1}
                    }
 
   
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
        }
    }
}
