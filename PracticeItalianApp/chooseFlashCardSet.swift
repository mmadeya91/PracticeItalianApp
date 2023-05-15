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
                    flashCardSets().frame(width: 345, height:675).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
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
                
                Text("Flash Cards").zIndex(1)
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 350, height: 60)
                    .background(Color.teal).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .yellow)
                
                flashCardHStack()
                
                
                
            }.zIndex(1)

        }
    }
}

struct flashCardHStack: View {
    var body: some View{
        
        let flashCardSetTitles: [String] = ["Food", "Animals", "Clothing", "Family", "20 Most Used Words", "Common Phrases", "My List"]
        
        let flashCardIcons: [String] = ["food", "bear", "clothes", "family", "dictionary", "talking", "flash-card"]
        
        ScrollView{
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[0], flashCardSetIcon: flashCardIcons[0])
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[1], flashCardSetIcon: flashCardIcons[1])
            }.padding([.leading, .trailing], 45)
    
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[2], flashCardSetIcon: flashCardIcons[2])
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[3], flashCardSetIcon: flashCardIcons[3])
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[4], flashCardSetIcon: flashCardIcons[4])
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[5], flashCardSetIcon: flashCardIcons[5])
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[6], flashCardSetIcon: flashCardIcons[6])
                Spacer()
            }.padding([.leading, .trailing], 45)
        }
               
    }
    
}

struct flashCardButton: View {
    
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    @State var pressed = false
    
    var body: some View{
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: flashCardActivity(), label: {
                Image(flashCardSetIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 85)
                    .padding(.top, -15)
            })
            .buttonStyle(navButton())
            
            Text("Acc.")
        
        }
    }
    
}


struct navButton: ButtonStyle {
    @State var pressed = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeIn(duration: 0.75)) {
                    self.pressed = pressing
                }
            }, perform: { })
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
