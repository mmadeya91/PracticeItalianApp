//
//  flashCardActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/14/23.
//

import SwiftUI

extension View {
    func border3(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct flashCardActivity: View {
    
    @State var flashCardObj: flashCardObject
    
    @State  var flipped = false
    @State  var animate3d = false
    @State  var showButtonSet = false
    @State var nextBackClicked = false
    
    @State  var counter: Int = 0
    
    var body: some View {
        
        VStack {
            customTopNavBar().position(x:200, y:120)
            
            progressBar(counter: self.$counter, totalCards: flashCardObj.words.count)
                .padding(.bottom, 60)
            

            scrollViewBuilder(flipped: self.$flipped, animate3d: self.$animate3d, flashCardObj: self.$flashCardObj, counter: self.$counter)

            
            rightWrongButtonSet().offset(y:-65)
            saveToMyListButton().offset(y:-50)
            
        }.offset(y:-80)
        
    }
}

struct scrollViewBuilder: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    @Binding var flashCardObj: flashCardObject
    @Binding var counter: Int
    
    var body: some View{
        
        ScrollViewReader {scrollView in
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<flashCardObj.words.count, id: \.self) {i in
                        cardView(flipped: $flipped, animate3d: $animate3d, counterTest: i , flashCardObj: $flashCardObj)
                            .padding([.leading, .trailing], 25)
                    }
                }
            }.scrollDisabled(true)
            HStack{
                Button(action: {
                    withAnimation{
                        if counter > 0 {
                            counter = counter - 1
                        }
                        scrollView.scrollTo(counter)
                    }
                }, label:
                        {Image(systemName: "arrow.backward").resizable()
                        .bold()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .foregroundColor(Color.black)
                    
                    
                    
                }).padding(.leading, 90)
                
                Spacer()
                
                Button(action: {
                    withAnimation{
                        if counter < flashCardObj.words.count - 1 {
                            counter = counter + 1
                        }
                        scrollView.scrollTo(counter)
                    }
                }, label:
                        {Image(systemName: "arrow.forward").resizable()
                        .bold()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .foregroundColor(Color.black)
                    
                    
                    
                }).padding(.trailing, 90)
            }.offset(y:175)
        }
      
    }
}


struct cardView: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var counterTest: Int
    //@Binding var counter: Int
    @Binding var flashCardObj: flashCardObject
    
    
    var body: some View{
        ZStack() {
            flashCardItal(counterTest: counterTest, fcO: $flashCardObj).opacity(flipped ? 0.0 : 1.0)
            flashCardEng(counterTest: counterTest, fcO: $flashCardObj).opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.8)) {
                self.animate3d.toggle()
            }
        }
        
    }
}

struct FlipEffect: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }
        
        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct flashCardItal: View {
    
    var counterTest: Int
    
    //@Binding var counter: Int
    @Binding var fcO: flashCardObject
    
    
    var body: some View{
        Text(fcO.words[counterTest].wordItal)
            .font(Font.custom("Marker Felt", size: 40))
            .foregroundColor(Color.black)
            .frame(width: 325, height: 250)
                .background(Color.teal)
                .cornerRadius(20)
                .shadow(radius: 10)
            .padding(.bottom, 30)
            .padding([.leading, .trailing], 10)
        
        
    }
}

struct flashCardEng: View {
    
    var counterTest: Int

    @Binding var fcO: flashCardObject
    
    
    var body: some View{
        VStack{
            Text(fcO.words[counterTest].wordEng)
                .font(Font.custom("Marker Felt", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(fcO.words[counterTest].gender.rawValue)
                .font(Font.custom("Marker Felt", size: 30))
                .foregroundColor(Color.black)
                .padding(.top, 2)
                .padding([.leading, .trailing], 10)
            
        }.frame(width: 325, height: 250)
            .background(Color.teal)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

struct rightWrongButtonSet: View{
    var body: some View{
        
        HStack{
            
            Button(action: {
                
            }, label:
                    {Image("cancel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                
                
                
            }).padding(.leading, 80)
            
            
            Spacer()
            
            Button(action: {
                
            }, label:
                    {Image("checked")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                
                
            }).padding(.trailing, 80)
            
        }
        
    }
}

struct saveToMyListButton: View{
    var body: some View{
        Button(action: {}, label: {Text("Save to My List")})
    }
}

struct nextPreviousButtonSet: View{
    
    @Binding var fcO: flashCardObject
    @Binding var counter: Int
    @Binding var nextBackClicked: Bool
    
    var body: some View{
        HStack{
            Button(action: {
                withAnimation{
                    if counter > 0 {
                        counter = counter - 1
                        nextBackClicked.toggle()
                    }
                }
            }, label:
                    {Image(systemName: "arrow.backward").resizable()
                    .bold()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                    .foregroundColor(Color.black)
                
                
                
            }).padding(.leading, 90)
            
            Spacer()
            
            Button(action: {
                withAnimation{
                    if counter < fcO.words.count - 1 {
                        counter = counter + 1
                        nextBackClicked.toggle()
                    }
                }
            }, label:
                    {Image(systemName: "arrow.forward").resizable()
                    .bold()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                    .foregroundColor(Color.black)
                
                
                
            }).padding(.trailing, 90)
        }
    }
}

struct progressBar: View {
    
    @Binding var counter: Int
    let totalCards: Int
    
    var body: some View {
        VStack {
            
            Text(String(counter + 1) + "/" + String(totalCards)).offset(y:20)
                .font(Font.custom("Arial Hebrew", size: 28))
                .bold()
            
            ProgressView("", value: Double(counter), total: Double(totalCards - 1))
                .tint(Color.orange)
                .frame(width: 300)
                .scaleEffect(x: 1, y: 4)
                
            
            
        }
    }
}

struct customTopNavBar: View {
    var body: some View {
        ZStack{
            HStack{
                NavigationLink(destination: chooseFlashCardSet(), label: {Image("cross")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 20)
                })
                
                Spacer()
                
                NavigationLink(destination: chooseFlashCardSet(), label: {Image("house")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.5)
                        .padding([.top, .bottom], 15)
                        .padding(.trailing, 38)
                       
                })
            }.zIndex(1)
        }.frame(width: 400, height: 60)
            .background(Color.gray.opacity(0.25))
            .border(width: 3, edges: [.bottom, .top], color: .teal)
            .zIndex(0)
                    
    }
}

struct EdgeBorder3: Shape {
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

struct flashCardActivity_Previews: PreviewProvider {
    static var previews: some View {
        flashCardActivity(flashCardObj: flashCardObject.Food)
    }
}
