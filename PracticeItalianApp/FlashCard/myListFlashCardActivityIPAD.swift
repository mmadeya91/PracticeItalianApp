//
//  myListFlashCardActivityIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/10/24.
//

import SwiftUI

extension Image {
    
    func imageStarModifierMyListIPAD() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
            .offset(y:50)
    }
}


struct myListFlashCardActivityIPAD: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var isEmpty: Bool {myListCards.isEmpty}
    
    @FetchRequest var myListCards: FetchedResults<UserMadeFlashCard>

    init() {
        self._myListCards = FetchRequest(entity: UserMadeFlashCard.entity(), sortDescriptors: [])
    }
    
    @State  var flipped = false
    @State  var animate3d = false
    @State  var showButtonSet = false
    @State var nextBackClicked = false
    @State var correctShowGif = false
    @State var progress: CGFloat = 0
    
    @State var saved = false
    @State var animatingBear = false
    @State var correctChosen = false
    @State var showFinishedActivityPage = false
    @State  var counter: Int = 0

    
    var body: some View {
        GeometryReader{geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .zIndex(0)
            
            HStack(spacing: 18){
                Spacer()
                NavigationLink(destination: chooseFlashCardSet(), label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 45))
                        .foregroundColor(.gray)
                        
                        
                })
                
                GeometryReader{proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.gray.opacity(0.25))
                        
                        Capsule()
                            .fill(Color.green)
                            .frame(width: proxy.size.width * CGFloat(progress))
                    }
                }.frame(height: 13)
                    .onChange(of: counter){ newValue in
                        progress = CGFloat(newValue) / CGFloat(myListCards.count)
                    }
                
                Image("italyFlag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                Spacer()
            }.zIndex(2)
            ZStack(alignment: .topLeading){
                VStack{
                    
                    scrollViewBuilderMyListIPAD(flipped: self.$flipped, animate3d: self.$animate3d, counter: self.$counter, showGif: self.$correctShowGif, saved: self.$saved, correctChosen: self.$correctChosen, myListCards: myListCards)
                       
                    
                    
                }.frame(width: geo.size.width)
                    .frame(minHeight: geo.size.height)
                    .offset(y: -150)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.6, height: 100)
                    .offset(x: 355, y: animatingBear ? (geo.size.height - 25): 750)
                
                if saved {
                    
                    Image("bubbleChatSaved")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 40)
                        .offset(x: 290, y: geo.size.height - 190 )
                        
                }
            
            if correctChosen{
                
                let randomInt = Int.random(in: 1..<4)
                
                Image("bubbleChatRight"+String(randomInt))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 40)
                    .offset(x: 290, y: geo.size.height - 190 )
            }
                NavigationLink(destination:  ActivityCompletePage(),isActive: $showFinishedActivityPage,label:{}
                                                  ).isDetailLink(false)
                
            }
            .onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
            }
            .onChange(of: counter) { questionNumber in
                 
                if questionNumber > myListCards.count - 1{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showFinishedActivityPage = true
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    
    }
}


struct scrollViewBuilderMyListIPAD: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var leadingPad: CGFloat = 30
    @State var trailingPad: CGFloat = 20
    @State var selected = false

    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    @Binding var counter: Int
    @Binding var showGif: Bool
    @Binding var saved: Bool
    @Binding var correctChosen: Bool
    
    var myListCards: FetchedResults<UserMadeFlashCard>
    
    var body: some View{
        GeometryReader{proxy in
            ScrollViewReader {scrollView in
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<myListCards.count, id: \.self) {i in
                            cardViewMyListIPAD(flipped: $flipped, animate3d: $animate3d, counterTest: i, myListCards: myListCards)
                                .frame(width: proxy.size.width)
                                .frame(minHeight: proxy.size.height)
                            
                        }
                    }
                }.scrollDisabled(true)
                VStack{
                    HStack{
                        Button(action: {
                            
                            withAnimation{
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    animate3d.toggle()
                                    if counter < myListCards.count - 1 {
                                        counter = counter + 1
                                    }
                                    withAnimation{
                                        scrollView.scrollTo(counter, anchor: .center)
                                    }
                                }
                                
                                self.selected.toggle()
                                SoundManager.instance.playSound(sound: .wrong)
                                
                            }
                        }, label:
                                {Image("cancel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .offset(x: selected ? -5 : 0)
                                .animation(Animation.default.repeatCount(5).speed(6))
                            
                            
                            
                        })
                        
                        
                        
                        Button(action: {
                            deleteItems(cardToDelete: myListCards[counter])
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                animate3d.toggle()
                                if counter < myListCards.count - 1 {
                                    counter = counter + 1
                                }
                                withAnimation{
                                    scrollView.scrollTo(counter, anchor: .center)
                                }
                            }
                        }, label: {
                            Text("Remove from List").padding(.top, 5)
                                .font(.system(size: 20))
                                .bold()
                                .frame(width: 250, height: 60)
                                .background(.orange)
                                .foregroundColor(.black)
                                .cornerRadius(20)
                            
                        }).padding([.leading, .trailing], 45)
                        
                        
                        
                        Button(action: {
                            
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                animate3d.toggle()
                                showGif.toggle()
                                if counter < myListCards.count - 1 {
                                    counter = counter + 1
                                }
                                withAnimation{
                                    scrollView.scrollTo(counter)
                                }
                                correctChosen = false
                                
                            }
                            SoundManager.instance.playSound(sound: .correct)
                            correctChosen = true
                            
                        }, label:
                                {Image("checked")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                            
                            
                            
                            
                        }).padding(.trailing, 50)
                    }.offset(x: 20, y:-320)
                }.opacity(flipped ? 1 : 0).animation(.easeIn(duration: 0.3), value: flipped)
            }
        }
      
    }
    
    func deleteItems(cardToDelete: UserMadeFlashCard) {
        withAnimation {

                    viewContext.delete(cardToDelete)
            
            do {
                try viewContext.save()
            } catch {
                
            }
        }
    }
}

struct noCardsInListIPAD: View {
    var body: some View{
        Text("You have no cards in your list!")
            .bold()
            .font(Font.custom("Marker Felt", size: 45))
            .frame(width: 450, height: 300)
            .background(Color.blue.opacity(0.5))
            .cornerRadius(20)
            .padding([.leading, .trailing], 20)
            .multilineTextAlignment(.center)
    }
}


struct cardViewMyListIPAD: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var counterTest: Int
    var myListCards: FetchedResults<UserMadeFlashCard>
    
    
    var body: some View{
        ZStack() {
            flashCardItalMyListIPAD(counterTest: counterTest, userMadeFlashCards: myListCards).opacity(flipped ? 0.0 : 1.0)
            flashCardEngMyListIPAD(counterTest: counterTest, userMadeFlashCards: myListCards).opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.8)) {
                self.animate3d.toggle()
            }
        }
        
    }
}

struct flashCardItalMyListIPAD: View {
    
    var counterTest: Int

    var userMadeFlashCards: FetchedResults<UserMadeFlashCard>
    
    
    var body: some View{
        VStack{
            Text(userMadeFlashCards[counterTest].italianLine1!)
                .font(Font.custom("Marker Felt", size: 60))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            starAndAccuracyMyListIPAD(cardName: userMadeFlashCards[counterTest].italianLine1!)
            
            

        }.frame(width: 515, height: 340)
            .background(Color("WashedWhite"))
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 7)
            )
            .cornerRadius(20)
    }
}

struct flashCardEngMyListIPAD: View {
    
    var counterTest: Int

    var userMadeFlashCards: FetchedResults<UserMadeFlashCard>
    
    
    var body: some View{
        VStack{
            Text(userMadeFlashCards[counterTest].englishLine1!)
                .font(Font.custom("Marker Felt", size: 60))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(userMadeFlashCards[counterTest].englishLine2!)
                .font(Font.custom("Marker Felt", size: 30))
                .foregroundColor(Color.black)
                .padding(.top, 2)
                .padding([.leading, .trailing], 10)
            
        }.frame(width: 515, height: 340)
            .background(Color("WashedWhite"))
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 7)
            )
            .cornerRadius(20)
    }
}

struct starAndAccuracyMyListIPAD: View {
    
    var cardName: String
    
    var body: some View{
        let fCAM = FlashCardAccDataManager(cardName: cardName)
        let isEmpty = fCAM.isEmptyFlashCardAccData()
        

        if isEmpty {
            HStack{
                Image("emptyStar")
                    .imageStarModifierMyListIPAD()
                Image("emptyStar")
                    .imageStarModifierMyListIPAD()
                Image("emptyStar")
                    .imageStarModifierMyListIPAD()
                Spacer()
                Text("0/0")
                    .font(Font.custom("Arial Hebrew", size: 30))
                    .offset(x: -35, y:50)
            }.padding([.leading, .trailing], 20)
                .padding(.top, 55)
        } else {
            
            let fetchedResults = fCAM.getAccData()
            let numOfStars = fCAM.getNumOfStars(card: fetchedResults)
            
            switch numOfStars {
                case 0:
                    HStack{
                        Image("emptyStar")
                            .imageStarModifierMyListIPAD()
                        Image("emptyStar")
                            .imageStarModifierMyListIPAD()
                        Image("emptyStar")
                            .imageStarModifierMyListIPAD()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                            .font(Font.custom("Arial Hebrew", size: 50))
                            .offset(x: -35, y:20)
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                
                case 1:
                    HStack{
                        Image("fullStar")
                            .imageStarModifierMyListIPAD()
                        Image("emptyStar")
                            .imageStarModifierMyListIPAD()
                        Image("emptyStar")
                            .imageStarModifierMyListIPAD()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                            .font(Font.custom("Arial Hebrew", size: 50))
                            .offset(x: -35, y:20)
                    
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                case 2:
                    HStack{
                        Image("fullStar")
                            .imageStarModifierMyListIPAD()
                        Image("fullStar")
                            .imageStarModifierMyListIPAD()
                        Image("emptyStar")
                            .imageStarModifierMyListIPAD()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                            .font(Font.custom("Arial Hebrew", size: 50))
                            .offset(x: -35, y:20)
                    
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                case 3:
                    HStack{
                        Image("fullStar")
                            .imageStarModifierMyListIPAD()
                        Image("fullStar")
                            .imageStarModifierMyListIPAD()
                        Image("fullStar")
                            .imageStarModifierMyListIPAD()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                            .font(Font.custom("Arial Hebrew", size: 50))
                            .offset(x: -35, y:20)
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                default:
                    HStack{
                        Text("Error")
                    }
            }
            
        }
        
    }
}


struct myListFlashCardActivityIPAD_Previews: PreviewProvider {
   static var previews: some View {
    myListFlashCardActivityIPAD().environment(\.managedObjectContext,
      PersistenceController.preview.container.viewContext)

   }
}

