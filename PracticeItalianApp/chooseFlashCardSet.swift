//
//  chooseFlashCardSet.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/13/23.
//

import SwiftUI

extension View {
    func border2(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct chooseFlashCardSet: View {
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
                    shortStoryContainer().frame(width: 345, height:675).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 6))
                        .shadow(radius: 10)
                        .padding(.top, 40)
                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct flashCardSets: View {
    var body: some View{
        ZStack{
            VStack{
                
                Text("Short Stories").zIndex(1)
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 350, height: 60)
                    .background(Color.teal).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .yellow)
                
                bookHStack()
                
                
                
            }.zIndex(1)

        }
    }
}

struct flashCardHStack: View {
    var body: some View{
        
        let bookTitles: [String] = ["Food", "test1", "test2", "test3", "test4", "test5"]
        
        ScrollView{
            HStack{
                bookButton(shortStoryName: bookTitles[0])
                Spacer()
                bookButton(shortStoryName:bookTitles[1])
            }.padding([.leading, .trailing], 60)
                .padding(.top, 10)
            HStack{
                bookButton(shortStoryName: bookTitles[2])
                Spacer()
                bookButton(shortStoryName: bookTitles[3])
            }.padding([.leading, .trailing], 60)
            HStack{
                bookButton(shortStoryName:bookTitles[4])
                Spacer()
                bookButton(shortStoryName: bookTitles[5])
            }.padding([.leading, .trailing], 60)
        }
               
    }
    
}

struct flashCardButton: View {
    
    
    var shortStoryName: String
    @State var pressed = false
    
    var body: some View{
        
        VStack{
            
            Text(shortStoryName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 70, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName), label: {
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
        
        }
    }
    
}

struct EdgeBorder2: Shape {
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


struct chooseFlashCardSet_Previews: PreviewProvider {
    static var previews: some View {
        chooseFlashCardSet()
    }
}
