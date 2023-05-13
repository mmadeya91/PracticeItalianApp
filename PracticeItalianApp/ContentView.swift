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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var animate: Bool = false
    @State var showBearAni: Bool = false
    @State private var var_x = 1
    @State var goNext: Bool = false
    
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
                        Text("Italian\nPractice")
                            .bold()
                            .foregroundColor(Color.black)
                            .font(Font.custom("Zapfino", size: 36))
                            .multilineTextAlignment(.center)
                            .frame(width: 325, height: 250)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.bottom, 100)
                            .padding(.top, 100)
                        
         
                        Button {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                               
                                goNext = true
                           }
                        
                            showBearAni.toggle()
                            
                        } label: {
                            Text("Let's Go!")
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
                            .offset(x: CGFloat(-var_x*600+240), y: 480)
                            .animation(.linear(duration: 6))
                            .onAppear { self.var_x *= -1}
                    }
 
   
                }
            }
        }
    }

    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
