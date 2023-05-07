//
//  shortStoryView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/5/23.
//

import SwiftUI

struct shortStoryView: View {
    
    @State var showPopUpScreen: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                testStory(showPopUpScreen: self.$showPopUpScreen).frame(width: 350, height:500).background(Color.white.opacity(0.75)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 6))
                .shadow(radius: 10)
                
                if showPopUpScreen{
                    popUpView(showPopUpScreen: self.$showPopUpScreen)
                }
                

                
            }
        }
    }
    
    
    
    
    
    
    struct testStory: View{
        
        @Binding var showPopUpScreen: Bool
        
        var body: some View{
            
            ScrollView(.vertical, showsIndicators: true) {
                    
                    Text("Cristoforo Colombo [nasce](myappurl://action) nel 1451 vicino a Genova, nel nord Italia. A 14 anni diventa marinaio e viaggia in numerosi Paesi. Per Cristoforo Colombo la Terra è rotonda e verso la fine del ‘400, vuole viaggiare verso l’India e vuole farlo con un viaggio verso ovest. La spedizione è costosa e Colombo prima chiede aiuto al re del Portogallo e poi alla regina Isabella di Castiglia. Nel 1492, dopo mesi di navigazione, scopre però un nuovo continente: l’America, che viene chiamata il Nuovo Mondo. Cristoforo Colombo fa altri viaggi in America ma ormai non è più così amato e così muore nel 1506 povero e dimenticato da tutti.")
                        .modifier(textModifer())
                        .environment(\.openURL, OpenURLAction { url in
                            handleURL(url)
                        })
                }
            }
        
        
        func handleURL(_ url: URL) -> OpenURLAction.Result {
            showPopUpScreen.toggle()
            return .handled
        }
        
    }
    
    struct popUpView: View{
        
        @Binding var showPopUpScreen: Bool
        
        var body: some View{
            ZStack{
                
                Button(action: {
                    showPopUpScreen.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                        .font(.largeTitle)
                        .padding(20)
                }).position(x:40, y:30)
                
                Text("Nascire - To be Born")
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                
            
            }.frame(width: 300, height: 300)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
            
        }
    }
    
    struct textModifer : ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Hebrew", size: 20))
                .padding(.top, 40)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(20)
            
        }
    }
    
    
    struct shortStoryView_Previews: PreviewProvider {
        static var previews: some View {
            shortStoryView()
        }
    }
}

