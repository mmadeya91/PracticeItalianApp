//
//  createFlashCard.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/16/23.
//

import SwiftUI


struct createFlashCard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showingSheet = false
    
    @State  var flipped = false
    @State  var animate3d = false
    @State var saved = true
    
    @State var frontUserInput1: String = ""
    @State var frontUserInput2: String = ""
    @State var backUserInput1: String = ""
    @State var backUserInput2: String = ""
    
    var body: some View {
        GeometryReader {geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
                    Image("verticalNature")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    
                    HStack(alignment: .top){
                        
                        NavigationLink(destination: chooseActivity(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        }).padding(.leading, 25)
                            .padding(.top, 20)
                        
                        
                        Spacer()
                     
                            Image("italyFlag")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .shadow(radius: 10)
                                .padding()
                            
                       
                    
                        
                    }
                    VStack{
                        
                   
                            Text("Saved!")
                                .font(Font.custom("Marker Felt", size: 25))
                                .opacity(saved ? 0.0 : 1.0)
                                .offset(y: 35)
                             
                    
                        
                        VStack{
                            
                            Text("Front")
                                .font(Font.custom("Marker Felt", size: 25))
                                .padding(.top, 25)
                            VStack{
                                Spacer()
                                
                                TextField("", text: $frontUserInput1)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Marker Felt", size: 32))
                                    .padding([.leading, .trailing], 30)
                                    
                                
                                Spacer()
                                
                                TextField("", text: $frontUserInput2)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Marker Felt", size: 32))
                                    .padding([.leading, .trailing], 30)
                                    .padding(.bottom, 25)
                               
                                
                                Spacer()
                            }
                            
                        }.frame(width: geo.size.width * 0.85, height: geo.size.height * 0.30)
                            .background(Color("WashedWhite"))
                            .overlay( RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.top, 30)
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                        
                        
                        VStack{
                            
                            Text("Back")
                                .font(Font.custom("Marker Felt", size: 25))
                                .padding(.top, 25)
                            
                            
                            VStack{
                                Spacer()
                                
                                TextField("", text: $frontUserInput1)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Marker Felt", size: 32))
                                    .padding([.leading, .trailing], 30)
                                
                                
                                Spacer()
                                
                                TextField("", text: $frontUserInput2)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Marker Felt", size: 32))
                                    .padding([.leading, .trailing], 30)
                                    .padding(.bottom, 25)
                                 
                                
                                Spacer()
                            }
                            
                        }.frame(width: geo.size.width * 0.85, height: geo.size.height * 0.30)
                            .background(Color("WashedWhite"))
                            .overlay( RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.top, 20)
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                        
                        Spacer()
                        
                        HStack{
                            saveButton(saved: $saved, fPI1: self.frontUserInput2, fPI2: self.frontUserInput2, bUI1: self.backUserInput1, bUI2: self.backUserInput2)
                            previewButton(showingSheet: self.$showingSheet)
                        }
                        clearButton(fui1: self.$frontUserInput1, fui2: self.$frontUserInput2, bui1: self.$backUserInput1, bui2: self.$backUserInput2)
                          
                        
                            .sheet(isPresented: $showingSheet) {
                                SheetView(flipped: self.$flipped, animate3d: self.$animate3d, fPI1: frontUserInput1, fPI2: frontUserInput2, bUI1: backUserInput1, bUI2: backUserInput2)
                            }
                        
                        Spacer()
                    }.padding(.top, 35)
               
                }.navigationBarBackButtonHidden(true)
            }else{
                createFlashCardIPAD()
            }
            
        }
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
                        .tint(Color.black)
                    
                }).padding()
                
                cardViewPreview(flipped: $flipped, animate3d: $animate3d, fPI1: fPI1, fPI2: fPI2, bUI1: bUI1, bUI2: bUI2).frame(width: geo.size.width * 0.9, height: 200)
                    .padding([.leading, .trailing], geo.size.width * 0.05)
                    .padding(.top, 200)
            }
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
            withAnimation(Animation.linear(duration: 0.5)) {
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
            
        }.frame(width: 290, height: 240)
            .background(Color("WashedWhite"))
            .overlay( RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 4))
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
            
        }.frame(width: 290, height: 240)
            .background(Color("WashedWhite"))
            .overlay( RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 4))
            .cornerRadius(20)
            .shadow(radius: 10)
    }
    
}

struct saveButton: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var saved: Bool
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View{
        Button(action: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              saved = true
            }
            addItem(f1: fPI1, f2: fPI2, b1: bUI1, b2: bUI2)
            
            saved = false
        }, label: {
            Text("Save to My List")
                .font(Font.custom("Arial Hebrew", size: 16))
                .padding(.top, 5)
                .foregroundColor(Color("WashedWhite"))
                .frame(width: 150, height: 40)
                .overlay( RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4))
                .background(Color("DarkNavy"))
                .cornerRadius(20)
                .shadow(radius: 10)
                .enabled(saved)
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
                .font(Font.custom("Arial Hebrew", size: 16))
                .padding(.top, 5)
                .foregroundColor(Color("WashedWhite"))
                .frame(width: 150, height: 40)
                .overlay( RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4))
                .background(Color("DarkNavy"))
                .cornerRadius(20)
                .shadow(radius: 10)
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
                .font(Font.custom("Arial Hebrew", size: 16))
                .padding(.top, 5)
                .foregroundColor(Color("WashedWhite"))
                .frame(width: 150, height: 40)
                .overlay( RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4))
                .background(Color("DarkNavy"))
                .cornerRadius(20)
                .shadow(radius: 10)
        })
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
