//
//  flashCardActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/14/23.
//

import SwiftUI

struct flashCardActivity: View {
    
    @State private var flipped = false
    @State private var animate3d = false
    
    var body: some View {
        
        return VStack {
            Spacer()
            
            ZStack() {
                flashCardItal().opacity(flipped ? 0.0 : 1.0)
                flashCardEng().opacity(flipped ? 1.0 : 0.0)
            }
            .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
            .onTapGesture {
                withAnimation(Animation.linear(duration: 0.8)) {
                    self.animate3d.toggle()
                }
            }
            Spacer()
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
    
   @State var italWord: String = "Ciao"
    
    var body: some View{
        ZStack{
            Text("Test")
                .font(Font.custom("Marker Felt", size: 25))
                .foregroundColor(Color.black)
                .padding(.bottom, 60)
                .zIndex(1)
            
            Button(action: {}, label: {Text("Check")})
                .frame(width: 200, height: 40)
                .background(Color.white)
                .foregroundColor(Color.black)
                .zIndex(1)
                .offset(y:60)
            
            Rectangle()
                .fill(Color.teal)
                .frame(width: 325, height: 300)
                .cornerRadius(20)
                .shadow(radius: 20)
        }
    }
}

struct flashCardEng: View {
    
   @State var engWord: String = "Hello"
    
    var body: some View{
        ZStack{
            Text("Test")
                .font(Font.custom("Marker Felt", size: 25))
                .foregroundColor(Color.black)
                .zIndex(1)
            
            
            
            Rectangle()
                .fill(Color.teal)
                .frame(width: 325, height: 300)
                .cornerRadius(20)
                .shadow(radius: 20)
        }
    }
}

struct buttonSet: View{
    var body: some View{
        
        Button(action: {}, label: {Text("Check")})
    }
}

struct flashCardActivity_Previews: PreviewProvider {
    static var previews: some View {
        flashCardActivity()
    }
}
