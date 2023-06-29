//
//  flashCardActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/14/23.
//

import SwiftUI

extension Image {
    
    func imageStarModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
}

struct flashCardActivity: View {
    
    @State var flashCardObj: flashCardObject
    
    @State  var flipped = false
    @State  var animate3d = false
    @State  var showButtonSet = false
    @State var nextBackClicked = false
    @State var correctShowGif = false
    
    @State  var counter: Int = 0
    
    var body: some View {
        ZStack{
            VStack{
                customTopNavBar()
                Spacer()
                progressBar(counter: self.$counter, totalCards: flashCardObj.words.count)
                Spacer()
                scrollViewBuilder(flipped: self.$flipped, animate3d: self.$animate3d, flashCardObj: self.$flashCardObj, counter: self.$counter, showGif: self.$correctShowGif).padding(.bottom, 160).padding(.top, 40)
                Spacer()
                
            }
            
            
            if correctShowGif {
                GifImage("thumbUp")
                    .offset(x:100, y:630)
                    .animation(Animation.easeIn, value: correctShowGif)
                   
            }
            
        }.navigationBarBackButtonHidden(true)
    
    }
}

struct scrollViewBuilder: View {
    
    @State var leadingPad: CGFloat = 20
    @State var trailingPad: CGFloat = 20
    @State var selected = false

    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    @Binding var flashCardObj: flashCardObject
    @Binding var counter: Int
    @Binding var showGif: Bool
    
    var body: some View{
        
        let fCAM = FlashCardAccDataManager(cardName: flashCardObj.words[counter].wordItal)
        
        ScrollViewReader {scrollView in
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<flashCardObj.words.count, id: \.self) {i in
                        cardView(flipped: $flipped, animate3d: $animate3d, counterTest: i , flashCardObj: $flashCardObj)
                            .padding(.leading, leadingPad)
                            .padding(.trailing, trailingPad)
                    }
                }
            }.scrollDisabled(true)
            VStack{
                HStack{
                    Button(action: {
  
                        withAnimation{
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                animate3d.toggle()
                                if counter < flashCardObj.words.count - 1 {
                                    counter = counter + 1
                                }
                                withAnimation{
                                    scrollView.scrollTo(counter)
                                }
                            }
                            
                            if fCAM.isEmptyFlashCardAccData() {
                                fCAM.addNewCardAccEntityIncorrect()
                            }else{
                                
                                fCAM.updateIncorrectInput(card: fCAM.getAccData())
                            }
                            
                            self.selected.toggle()

                        }
                    }, label:
                            {Image("cancel")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .offset(x: selected ? -5 : 0)
                            .animation(Animation.default.repeatCount(5).speed(6))
                        
                        
                        
                    }).padding(.leading, 90)
                    
                    Spacer()
                    
                    Button(action: {
                        
    
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            animate3d.toggle()
                            showGif.toggle()
                            if counter < flashCardObj.words.count - 1 {
                                counter = counter + 1
                            }
                            withAnimation{
                                scrollView.scrollTo(counter)
                            }
                        }
                            SoundManager.instance.playSound(sound: .correct)
                        
                        if fCAM.isEmptyFlashCardAccData() {
                            fCAM.addNewCardAccEntityCorrect()
                        } else {
                            fCAM.updateCorrectInput(card: fCAM.getAccData())
                        }
                        
                        
                            showGif.toggle()
                        
                    }, label:
                            {Image("checked")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                        
                        
                        
                        
                    }).padding(.trailing, 90)
                }
                
                saveToMyListButton(italLine1: flashCardObj.words[counter].wordItal,  engLine1: flashCardObj.words[counter].wordEng, engLine2: flashCardObj.words[counter].gender.rawValue).padding(.top, 20)
                
            }.opacity(flipped ? 1 : 0).animation(.easeIn(duration: 0.3), value: flipped)
        }
      
    }
}


struct cardView: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var counterTest: Int
    @Binding var flashCardObj: flashCardObject
    
    
    var body: some View{
        ZStack() {
            flashCardItal(counterTest: counterTest, fcO: $flashCardObj).opacity(flipped ? 0.0 : 1.0)
            flashCardEng(counterTest: counterTest, fcO: $flashCardObj).opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
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
    
    @Binding var fcO: flashCardObject
    
    
    var body: some View{
        VStack{
            Text(fcO.words[counterTest].wordItal)
                .font(Font.custom("Marker Felt", size: 40))
                .padding(.top, 70)
                .padding([.leading, .trailing], 10)
            
            starAndAccuracy(cardName: fcO.words[counterTest].wordItal)
            
            
            
        } .frame(width: 325, height: 250)
            .background(Color.teal)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        
        
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
                .padding([.leading, .trailing], 10)
            
        }.frame(width: 325, height: 250)
            .background(Color.teal)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
    }
}

struct starAndAccuracy: View {
    
    var cardName: String
    
    var body: some View{
        let fCAM = FlashCardAccDataManager(cardName: cardName)
        let isEmpty = fCAM.isEmptyFlashCardAccData()
        

        if isEmpty {
            HStack{
                Image("emptyStar")
                    .imageStarModifier()
                Image("emptyStar")
                    .imageStarModifier()
                Image("emptyStar")
                    .imageStarModifier()
                Spacer()
                Text("0/0")
                    .font(Font.custom("Arial Hebrew", size: 30))
            }.padding([.leading, .trailing], 20)
                .padding(.top, 55)
        } else {
            
            let fetchedResults = fCAM.getAccData()
            let numOfStars = fCAM.getNumOfStars(card: fetchedResults)
            
            switch numOfStars {
                case 0:
                    HStack{
                        Image("emptyStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                
                case 1:
                    HStack{
                        Image("fullStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                case 2:
                    HStack{
                        Image("fullStar")
                            .imageStarModifier()
                        Image("fullStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                case 3:
                    HStack{
                        Image("fullStar")
                            .imageStarModifier()
                        Image("fullStar")
                            .imageStarModifier()
                        Image("fullStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                default:
                    HStack{
                        Text("Error")
                    }
            }
            
        }
        
    }
}


struct saveToMyListButton: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var italLine1: String
    var engLine1: String
    var engLine2: String
    
    var body: some View{
        Button(action: {
            
            
        }, label: {
            Text("Save to My List")
                .bold()
                .frame(width: 190, height: 50)
                .background(.orange)
                .foregroundColor(.black)
                .cornerRadius(20)
        })
    }
    
    private func addItem() {
        withAnimation {
            let newFlashCardEntity = UserMadeFlashCard(context: viewContext)
            newFlashCardEntity.italianLine1 = italLine1
            newFlashCardEntity.italianLine2 = ""
            newFlashCardEntity.englishLine1 = engLine1
            newFlashCardEntity.englishLine2 = engLine2
            

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
            }
        }
    }
}

//struct nextPreviousButtonSet: View{
//
//    @Binding var fcO: flashCardObject
//    @Binding var counter: Int
//    @Binding var nextBackClicked: Bool
//
//    var body: some View{
//        HStack{
//            Button(action: {
//                withAnimation{
//                    if counter > 0 {
//                        counter = counter - 1
//                        nextBackClicked.toggle()
//                    }
//                }
//            }, label:
//                    {Image(systemName: "arrow.backward").resizable()
//                    .bold()
//                    .scaledToFit()
//                    .frame(width: 65, height: 65)
//                    .foregroundColor(Color.black)
//
//
//
//            }).padding(.leading, 90)
//
//            Spacer()
//
//            Button(action: {
//                withAnimation{
//                    if counter < fcO.words.count - 1 {
//                        counter = counter + 1
//                        nextBackClicked.toggle()
//                    }
//                }
//            }, label:
//                    {Image(systemName: "arrow.forward").resizable()
//                    .bold()
//                    .scaledToFit()
//                    .frame(width: 65, height: 65)
//                    .foregroundColor(Color.black)
//
//
//
//            }).padding(.trailing, 90)
//        }
//    }
//}

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

struct flashCardActivity_Previews: PreviewProvider {
    static var previews: some View {
        flashCardActivity(flashCardObj: flashCardObject.Food)
    }
}
