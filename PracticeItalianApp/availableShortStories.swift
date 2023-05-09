//
//  availableShortStories.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/9/23.
//

import SwiftUI

struct availableShortStories: View {
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                VStack{
                    shortStoryContainer().frame(width: 350, height:675).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 6))
                        .shadow(radius: 10)
                        .padding(.top, 60)
                }
                
            }
        }
    }
}

struct shortStoryContainer: View {
    var body: some View{
        ZStack{
            VStack{
                
                Text("Available Short Stories").zIndex(1)
                
                bookHStack()
                
                
                
            }.zIndex(1)

        }
    }
}

struct bookHStack: View {
    var body: some View{
        
        ScrollView{
            HStack{
                bookButton(shortStoryName: "Cristofo Columbo")
                Spacer()
                bookButton(shortStoryName:"test")
            }.padding([.leading, .trailing], 60)
                .padding(.top, 10)
            HStack{
                bookButton(shortStoryName:"test")
                Spacer()
                bookButton(shortStoryName:"test")
            }.padding([.leading, .trailing], 60)
            HStack{
                bookButton(shortStoryName:"test")
                Spacer()
                bookButton(shortStoryName:"test")
            }.padding([.leading, .trailing], 60)
        }
               
    }
    
}

struct bookButton: View {
    
    
    var shortStoryName: String
    @State var pressed = false
    
    var body: some View{
        
        VStack{
            
            Text(shortStoryName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 70, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: shortStoryView(chosenStoryName: shortStoryName), label: {
                Image("book_Fotor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 85)
            })
                
                .scaleEffect(pressed ? 1.25 : 1.0)
                .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeIn(duration: 0.75)) {
                        self.pressed = pressing
                    }
                }, perform: { })
        
       
            
            
            
//            Button(action: {
//
//            }, label: {
//                Image("book_Fotor")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 70, height: 85)
//
//            }).buttonStyle(.plain)
//                .scaleEffect(pressed ? 1.25 : 1.0)
//                .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
//                    withAnimation(.easeIn(duration: 0.75)) {
//                        self.pressed = pressing
//                    }
//                }, perform: { })
        }
    }
    
}

struct availableShortStories_Previews: PreviewProvider {
    static var previews: some View {
        availableShortStories()
    }
}
