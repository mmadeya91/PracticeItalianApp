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
    @ObservedObject var globalModel = GlobalModel()
    @State var animatingBear = false
    @State var showInfoPopup = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                HStack(spacing: 18){
               
                        NavigationLink(destination: chooseActivity(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        }).padding(.leading, 25).padding(.top, 15)
 
                
                    
                    Spacer()
                    VStack{
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
     
                            
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 22))
                        }.padding(.top,10).padding(.trailing, 45)
                    }.padding(.top, 85)
                }.zIndex(2).offset(y:-380)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: -45, y: animatingBear ? -260 : 0)
                
                VStack{
                    
                    shortStoryContainer(showInfoPopup: $showInfoPopup).frame(width:345, height: 600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 100)
                }.padding(.bottom, 50)
                
                if showInfoPopup{
                    VStack{
                        Text("Do your best to read and understand the following short stories on various topics. \n \nWhile you read, pay attention to key vocabulary words as you will be quizzed after on your comprehension!")
                            .multilineTextAlignment(.center)
                            .padding()
                    }.frame(width: 300, height: 285)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                }
                
            }.onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct shortStoryContainer: View {
    @Binding var showInfoPopup: Bool
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Text("Short Stories").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        withAnimation(.linear){
                            showInfoPopup.toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                    })
                    .padding(.leading, 5)
                } .frame(width: 350, height: 60)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
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
                        .frame(width: 175, height: 30)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButton(shortStoryName: bookTitles[0])
                        Spacer()
                        bookButton(shortStoryName:bookTitles[1])
                    }.padding([.leading, .trailing], 45)
                        .padding(.bottom, 10)
                    HStack{
                        bookButton(shortStoryName: bookTitles[2])
                        Spacer()
                        bookButton(shortStoryName: bookTitles[3])
                    }.padding([.leading, .trailing], 45)
                }
                VStack{
                    Text("Intermediate")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 175, height: 30)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButton(shortStoryName: bookTitles[2])
                        Spacer()
                        bookButton(shortStoryName: bookTitles[3])
                    }.padding([.leading, .trailing], 55)
                }
                VStack{
                    Text("Hard")
                        .font(Font.custom("Marker Felt", size: 30))
                        .frame(width: 75, height: 30)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.bottom, 25)
                    
                    HStack{
                        bookButton(shortStoryName:bookTitles[4])
                        Spacer()
                        bookButton(shortStoryName: bookTitles[5])
                    }.padding([.leading, .trailing], 55)
                }
            }
        }
        
    }
    
}

struct bookButton: View {
    
    
    var shortStoryName: String
    @State var pressed = false
    
    var body: some View{
        
        VStack(spacing: 0){
            
            NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName), label: {
                Image("book3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                
                    .padding()
                    .background(.white)
                    .cornerRadius(60)
                    .overlay( RoundedRectangle(cornerRadius: 60)
                        .stroke(.black, lineWidth: 3))
                    .shadow(radius: 10)
                    
                    
            })
            
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeIn(duration: 0.75)) {
                    self.pressed = pressing
                }
            }, perform: { })
            
            Text(shortStoryName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 130, height: 80)
                .multilineTextAlignment(.center)

            
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
        availableShortStories().environmentObject(GlobalModel())
    }
}
