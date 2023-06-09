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
                    CustomNavBar().position(x:200, y:40)
                    
                    flashCardSets().frame(width: 345, height:675).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 6))
                        .shadow(radius: 10)
                        .padding(.top, 10)
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
        
        let flashCardSetTitles: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjetives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own"]
        
        let flashCardIcons: [String] = ["food", "bear", "clothes", "family", "dictionary", "dictionary", "dictionary", "dictionary", "talking", "flash-card", "flash-card"]
        
        ScrollView{
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[0], flashCardSetIcon: flashCardIcons[0], arrayIndex: 0)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[1], flashCardSetIcon: flashCardIcons[1], arrayIndex: 1)
            }.padding([.leading, .trailing], 45)
    
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[2], flashCardSetIcon: flashCardIcons[2], arrayIndex: 2)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[3], flashCardSetIcon: flashCardIcons[3], arrayIndex: 3)
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[4], flashCardSetIcon: flashCardIcons[4], arrayIndex: 4)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[5], flashCardSetIcon: flashCardIcons[5], arrayIndex: 5)
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[6], flashCardSetIcon: flashCardIcons[6], arrayIndex: 6)
                Spacer()
                flashCardButton(flashCardSetName: flashCardSetTitles[7], flashCardSetIcon: flashCardIcons[7], arrayIndex: 7)
            }.padding([.leading, .trailing], 45)
            HStack{
                flashCardButton(flashCardSetName: flashCardSetTitles[8], flashCardSetIcon: flashCardIcons[8], arrayIndex: 8)
                Spacer()
                toMyListButton(flashCardSetName: flashCardSetTitles[9], flashCardSetIcon: flashCardIcons[9])
            }.padding([.leading, .trailing], 45)
            HStack{
                toMakeYourOwnButton(flashCardSetName: flashCardSetTitles[10], flashCardSetIcon: flashCardIcons[10])
                Spacer()
  
            }.padding([.leading, .trailing], 45)
        }
               
    }
    
}

struct flashCardButton: View {
    
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    var arrayIndex: Int
    
    @State var pressed = false
    
    var body: some View{
        
        let dataObj = flashCardData(chosenFlashSetIndex: arrayIndex)
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: arrayIndex)), label: {
                Image(flashCardSetIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 85)
                    .padding(.top, -15)
            })
            
            Text("Acc.")
        
        }
    }
    
}

struct toMakeYourOwnButton: View {
    
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    
    var body: some View{
        
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: createFlashCard(), label: {
                Image(flashCardSetIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 85)
                    .padding(.top, -15)
            })
            
            Text("Acc.")
        
        }
    }
    
}

struct toMyListButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    
//    var isEmpty: Bool {
//        do {
//            let request = viewContext.fetch(NSFetchRequest<UserMadeFlashCard>)
//            let count  = try context.count(for: request)
//            return count == 0
//        } catch {
//            return true
//        }
//    }
    
    var body: some View{
        
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 20))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: myListFlashCardActivity(), label: {
                Image(flashCardSetIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 85)
                    .padding(.top, -15)
            })
            
            Text("Acc.")
        
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
