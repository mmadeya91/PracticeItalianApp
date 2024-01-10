//
//  createFlashCardIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/10/24.
//

import SwiftUI

struct createFlashCardIPAD: View {
    
    @State var showingSheet = false
    
    @State  var flipped = false
    @State  var animate3d = false
    
    @State var frontUserInput1: String = ""
    @State var frontUserInput2: String = ""
    @State var backUserInput1: String = ""
    @State var backUserInput2: String = ""
    
    var body: some View {
        GeometryReader {geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            VStack{
                
                VStack{
                    
                    Text("Front")
                        .font(Font.custom("Marker Felt", size: 38))
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                    
                    TextField("", text: $frontUserInput1)
                        .background(Color.white.cornerRadius(10))
                        .opacity(0.75)
                        .shadow(color: Color.black, radius: 12, x: 0, y:10)
                        .font(Font.custom("Marker Felt", size: 40))
                        .padding([.leading, .trailing], 30)
                    
                    
                    Spacer()
                    
                    TextField("", text: $frontUserInput2)
                        .background(Color.white.cornerRadius(10))
                        .opacity(0.75)
                        .shadow(color: Color.black, radius: 12, x: 0, y:10)
                        .font(Font.custom("Marker Felt", size: 40))
                        .padding([.leading, .trailing], 30)
                        .padding(.bottom, 60)
                    
                }.frame(width: 425, height: 270)
                    .background(Color("WashedWhite"))
                    .overlay( RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 4))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                
                
                VStack{
                    
                    Text("Back")
                        .font(Font.custom("Marker Felt", size: 38))
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
                        .font(Font.custom("Marker Felt", size: 40))
                        .padding([.leading, .trailing], 30)
                        .padding(.bottom, 60)
                    
                }.frame(width: 425, height: 270)
                    .background(Color("WashedWhite"))
                    .overlay( RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 4))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.top, 20)
                
                
                HStack{
                    saveButtonIPAD(fPI1: self.frontUserInput2, fPI2: self.frontUserInput2, bUI1: self.backUserInput1, bUI2: self.backUserInput2)
                    previewButtonIPAD(showingSheet: self.$showingSheet)
                }.padding(.top, 50)
                clearButtonIPAD(fui1: self.$frontUserInput1, fui2: self.$frontUserInput2, bui1: self.$backUserInput1, bui2: self.$backUserInput2)
                    .padding(.top, 15)
                
                    .sheet(isPresented: $showingSheet) {
                        SheetViewIPAD(flipped: self.$flipped, animate3d: self.$animate3d, fPI1: frontUserInput1, fPI2: frontUserInput2, bUI1: backUserInput1, bUI2: backUserInput2)
                    }
                
                Spacer()
            }.navigationBarBackButtonHidden(true)
                .padding(.leading, 130)
                .padding(.top, 100)
            
        }
    }
}

struct SheetViewIPAD: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View {
        GeometryReader {geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            ZStack(alignment: .topLeading){
                
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .tint(Color.white)
                    
                }).padding()
                
                cardViewPreviewIPAD(flipped: $flipped, animate3d: $animate3d, fPI1: fPI1, fPI2: fPI2, bUI1: bUI1, bUI2: bUI2).padding([.leading, .trailing], 40)
                    .padding(.top, 200)
            }
        }
    }
}


struct cardViewPreviewIPAD: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View{
        ZStack() {
            flashCardItalPreviewIPAD(frontUserInput1: fPI1, frontUserInput2: fPI2).opacity(flipped ? 0.0 : 1.0)
            flashCardEngPreviewIPAD(backUserInput1: bUI1, backUserInput2: bUI2).opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.8)) {
                self.animate3d.toggle()
            }
        }
        .offset(x: 80)
        
    }
}

struct flashCardItalPreviewIPAD: View {
    
    var frontUserInput1: String
    var frontUserInput2: String
    
    var body: some View{
        VStack{
            Text(frontUserInput1)
                .font(Font.custom("Marker Felt", size: 47))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(frontUserInput2)
                .font(Font.custom("Marker Felt", size: 35))
                .foregroundColor(Color.black)
                .padding(.top, 2)
                .padding([.leading, .trailing], 10)
            
        }.frame(width: 450, height: 290)
            .background(Color("WashedWhite"))
            .overlay( RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 4))
            .cornerRadius(20)
            .shadow(radius: 10)
            
        
    }
}

struct flashCardEngPreviewIPAD: View {
    
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
            
        }.frame(width: 425, height: 280)
            .background(Color("WashedWhite"))
            .overlay( RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 4))
            .cornerRadius(20)
            .shadow(radius: 10)
    }
    
}

struct saveButtonIPAD: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View{
        Button(action: {
            addItem(f1: fPI1, f2: fPI2, b1: bUI1, b2: bUI2)
        }, label: {
            Text("Save to My List")
                .font(Font.custom("Arial Hebrew", size: 25))
                .padding(.top, 5)
                .foregroundColor(Color("WashedWhite"))
                .frame(width: 260, height: 55)
                .overlay( RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4))
                .background(Color.teal)
                .cornerRadius(20)
                .shadow(radius: 10)
        })
        
        
    }
    
    func addItem(f1: String, f2: String, b1: String, b2: String) {
        withAnimation {
            let newUserMadeFlashCard = UserMadeFlashCard(context: viewContext)
            newUserMadeFlashCard.italianLine1 = f1
            newUserMadeFlashCard.italianLine2 = f2
            newUserMadeFlashCard.englishLine1 = b1
            newUserMadeFlashCard.englishLine2 = b2
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct clearButtonIPAD: View{
    
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
                .font(Font.custom("Arial Hebrew", size: 25))
                .padding(.top, 5)
                .foregroundColor(Color("WashedWhite"))
                .frame(width: 260, height: 55)
                .overlay( RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4))
                .background(Color.teal)
                .cornerRadius(20)
                .shadow(radius: 10)
        })
    }
}

struct previewButtonIPAD: View{
    
    @Binding var showingSheet: Bool
    
    var body: some View{
        Button(action: {
            withAnimation(Animation.spring()){
                showingSheet.toggle()
            }
        }, label: {
            Text("Preview")
                .font(Font.custom("Arial Hebrew", size: 25))
                .padding(.top, 5)
                .foregroundColor(Color("WashedWhite"))
                .frame(width: 260, height: 55)
                .overlay( RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4))
                .background(Color.teal)
                .cornerRadius(20)
                .shadow(radius: 10)
        })
    }
}



struct FlipEffectPreviewIPAD: GeometryEffect {
    
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

struct createFlashCardIPAD_Previews: PreviewProvider {
    static var previews: some View {
        createFlashCardIPAD()
    }
}
