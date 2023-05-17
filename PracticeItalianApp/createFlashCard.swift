//
//  createFlashCard.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/16/23.
//

import SwiftUI

struct createFlashCard: View {
    
    @State var showingSheet = false
    
    @State  var flipped = false
    @State  var animate3d = false
    
    @State var frontUserInput1: String = ""
    @State var frontUserInput2: String = ""
    @State var backUserInput1: String = ""
    @State var backUserInput2: String = ""
    
    var body: some View {
        
        VStack{
            
            customTopNavBar5().padding(.top, 20)
            
            VStack{
                
                Text("Front")
                    .font(Font.custom("Marker Felt", size: 30))
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                
                TextField("", text: $frontUserInput1)
                    .background(Color.white.cornerRadius(10))
                    .opacity(0.75)
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                    .font(Font.custom("Marker Felt", size: 35))
                    .padding([.leading, .trailing], 30)

                
                Spacer()
                
                TextField("", text: $frontUserInput2)
                    .background(Color.white.cornerRadius(10))
                    .opacity(0.75)
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                    .font(Font.custom("Marker Felt", size: 35))
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 60)
                
            }.frame(width: 325, height: 240)
                .background(Color.teal)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 50)

            
            VStack{
                
                Text("Back")
                    .font(Font.custom("Marker Felt", size: 30))
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                
                TextField("", text: $backUserInput1)
                    .background(Color.white.cornerRadius(10))
                    .opacity(0.75)
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                    .font(Font.custom("Marker Felt", size: 35))
                    .padding([.leading, .trailing], 30)
                
                Spacer()
                
                TextField("", text: $backUserInput2)
                    .background(Color.white.cornerRadius(10))
                    .opacity(0.75)
                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                    .font(Font.custom("Marker Felt", size: 35))
                    .padding([.leading, .trailing], 30)
                    .padding(.bottom, 60)
                
            }.frame(width: 325, height: 240)
                .background(Color.teal)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 20)
            
            Spacer()
            
            HStack{
                saveButton()
                previewButton(showingSheet: self.$showingSheet)
            }.padding(.top, 20
            )
            clearButton(fui1: self.$frontUserInput1, fui2: self.$frontUserInput2, bui1: self.$backUserInput1, bui2: self.$backUserInput2)
                .padding(.top, 15)
            
            .sheet(isPresented: $showingSheet) {
                SheetView(flipped: self.$flipped, animate3d: self.$animate3d, fPI1: frontUserInput1, fPI2: frontUserInput2, bUI1: backUserInput1, bUI2: backUserInput2)
            }
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
        
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            
            Color.black.opacity(0.4).ignoresSafeArea()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                    .tint(Color.white)
                
            }).padding()
            
            cardViewPreview(flipped: $flipped, animate3d: $animate3d, fPI1: fPI1, fPI2: fPI2, bUI1: bUI1, bUI2: bUI2).padding([.leading, .trailing], 40)
                .padding(.top, 200)
        }
    }
}


struct cardViewPreview: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View{
        ZStack() {
            flashCardItalPreview(frontUserInput1: fPI1, frontUserInput2: fPI2).opacity(flipped ? 0.0 : 1.0)
            flashCardEngPreview(backUserInput1: bUI1, backUserInput2: bUI2).opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.8)) {
                self.animate3d.toggle()
            }
        }
        
    }
}

struct flashCardItalPreview: View {
    
    var frontUserInput1: String
    var frontUserInput2: String
    
    var body: some View{
        VStack{
            Text(frontUserInput1)
                .font(Font.custom("Marker Felt", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(frontUserInput2)
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

struct flashCardEngPreview: View {
    
    var backUserInput1: String
    var backUserInput2: String
    
    var body: some View{
        VStack{
            Text(backUserInput1)
                .font(Font.custom("Marker Felt", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(backUserInput2)
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

struct saveButton: View{
    var body: some View{
        Button(action: {}, label: {
            Text("Save to My List")
                .frame(width: 180, height: 50)
                .background(Color.orange)
                .cornerRadius(20)
        })
    }
}

struct clearButton: View{
    
    @Binding var fui1: String
    @Binding var fui2: String
    @Binding var bui1: String
    @Binding var bui2: String
    
    var body: some View{
        Button(action: {
            fui1 = ""
            fui2 = ""
            bui1 = ""
            bui2 = ""
            
        }, label: {
            Text("Clear")
                .frame(width: 180, height: 50)
                .background(Color.orange)
                .cornerRadius(20)
        })
    }
}

struct previewButton: View{
    
    @Binding var showingSheet: Bool
    
    var body: some View{
        Button(action: {
            withAnimation(Animation.spring()){
                showingSheet.toggle()
            }
        }, label: {
            Text("Preview")
                .frame(width: 180, height: 50)
                .background(Color.orange)
                .cornerRadius(20)
        })
    }
}


struct customTopNavBar5: View {
    var body: some View {
        ZStack{
            HStack{
                NavigationLink(destination: chooseActivity(), label: {Image("cross")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 20)
                })
                
                Spacer()
                
                NavigationLink(destination: chooseActivity(), label: {Image("house")
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

struct FlipEffectPreview: GeometryEffect {
    
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

struct createFlashCard_Previews: PreviewProvider {
    static var previews: some View {
        createFlashCard()
    }
}
