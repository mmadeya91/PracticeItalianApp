//
//  availableShortStories.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/9/23.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct availableShortStories: View {
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                VStack{
                    HStack(spacing: 18){
                        NavigationLink(destination: chooseActivity(), label: {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }).padding(.leading, 25)
                        
                        Spacer()
                        
                        NavigationLink(destination: chooseActivity(), label: {
                            Image("home3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }).padding(.trailing, 25)
                    }
                    shortStoryContainer().frame(width: 345, height:600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 40)
                }.padding(.bottom, 50)
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct shortStoryContainer: View {
    var body: some View{
        ZStack{
            VStack{
                
                Text("Short Stories").zIndex(1)
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 350, height: 70)
                    .background(Color("ForestGreen")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: Color("DarkRed"))
                
                bookHStack()
                
            }.zIndex(1)
            
        }
    }
}

struct bookHStack: View {
    var body: some View{
        
        let bookTitles: [String] = ["Cristofo Columbo", "test1", "test2", "test3", "test4", "test5"]
        
        ScrollView{
            VStack{
                VStack{
                    Text("Beginner")
                        .font(Font.custom("Marker Felt", size: 30))
                        .underline()
                        .frame(width: 160, height: 40)
                        .cornerRadius(10)
                    
                    HStack{
                        bookButton(shortStoryName: bookTitles[0])
                        Spacer()
                        bookButton(shortStoryName:bookTitles[1])
                    }.padding([.leading, .trailing], 60)
                    HStack{
                        bookButton(shortStoryName: bookTitles[2])
                        Spacer()
                        bookButton(shortStoryName: bookTitles[3])
                    }.padding([.leading, .trailing], 60)
                }.padding(.bottom, 30)
                VStack{
                    Text("Intermediate")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 175, height: 30)
                        .border(width: 3, edges: [.bottom], color: Color("DarkRed"))
                    
                    HStack{
                        bookButton(shortStoryName: bookTitles[2])
                        Spacer()
                        bookButton(shortStoryName: bookTitles[3])
                    }.padding([.leading, .trailing], 60)
                }
                VStack{
                    Text("Hard")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 75, height: 30)
                        .padding(.top, 50)
                        .border(width: 3, edges: [.bottom], color: Color("DarkRed"))
                    
                    HStack{
                        bookButton(shortStoryName:bookTitles[4])
                        Spacer()
                        bookButton(shortStoryName: bookTitles[5])
                    }.padding([.leading, .trailing], 60)
                }
            }
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
                .frame(width: 90, height: 80)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName), label: {
                Image("book3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
            })
            
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeIn(duration: 0.75)) {
                    self.pressed = pressing
                }
            }, perform: { })
            
        }
    }
    
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

struct availableShortStories_Previews: PreviewProvider {
    static var previews: some View {
        availableShortStories()
    }
}
