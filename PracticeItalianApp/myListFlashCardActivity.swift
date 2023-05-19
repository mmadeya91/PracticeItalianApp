//
//  myListFlashCardActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/17/23.
//

import SwiftUI

extension View {
    func border5(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct myListFlashCardActivity: View {
    
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
    
    @State  var counter: Int = 0
    
    var body: some View {
        
        VStack {
            
            if isEmpty {
                customTopNavBar()
                Spacer()
                noCardsInList()
                    .padding(.bottom, 260)
            }else{
                
                customTopNavBar()
                
                progressBarMyList(counter: self.$counter, totalCards: myListCards.count)
                    .padding(.bottom, 60)
                
                scrollViewBuilderMyList(flipped: self.$flipped, animate3d: self.$animate3d, counter: self.$counter, myListCards: myListCards)
                
                
                rightWrongButtonSet()
                    .padding(.top, 40)
                removeFromListButton(cardToDelete: myListCards[counter])
                    .padding(.top, 20)
            }
            
        }.navigationBarBackButtonHidden(true)
    }
    
}


struct scrollViewBuilderMyList: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    @Binding var counter: Int
    
    var myListCards: FetchedResults<UserMadeFlashCard>
    
    var body: some View{
        
        ScrollViewReader {scrollView in
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<myListCards.count, id: \.self) {i in
                        cardViewMyList(flipped: $flipped, animate3d: $animate3d, counterTest: i, myListCards: myListCards)
                            .padding([.leading, .trailing], 35)
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
                        if counter < myListCards.count - 1 {
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
            }.padding(.top,20)
        }
      
    }
}

struct noCardsInList: View {
    var body: some View{
        Text("You have no cards in your list!")
            .bold()
            .font(Font.custom("Marker Felt", size: 35))
            .frame(width: 350, height: 200)
            .background(Color.blue.opacity(0.5))
            .cornerRadius(20)
            .padding([.leading, .trailing], 20)
            .multilineTextAlignment(.center)
    }
}


struct cardViewMyList: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var counterTest: Int
    var myListCards: FetchedResults<UserMadeFlashCard>
    
    
    var body: some View{
        ZStack() {
            flashCardItalMyList(counterTest: counterTest, userMadeFlashCards: myListCards).opacity(flipped ? 0.0 : 1.0)
            flashCardEngMyList(counterTest: counterTest, userMadeFlashCards: myListCards).opacity(flipped ? 1.0 : 0.0)
        }
        .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.8)) {
                self.animate3d.toggle()
            }
        }
        
    }
}

struct flashCardItalMyList: View {
    
    var counterTest: Int

    var userMadeFlashCards: FetchedResults<UserMadeFlashCard>
    
    
    var body: some View{
        VStack{
            Text(userMadeFlashCards[counterTest].italianLine1!)
                .font(Font.custom("Marker Felt", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(userMadeFlashCards[counterTest].italianLine2!)
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

struct flashCardEngMyList: View {
    
    var counterTest: Int

    var userMadeFlashCards: FetchedResults<UserMadeFlashCard>
    
    
    var body: some View{
        VStack{
            Text(userMadeFlashCards[counterTest].englishLine1!)
                .font(Font.custom("Marker Felt", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(userMadeFlashCards[counterTest].englishLine2!)
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

struct rightWrongButtonSet5: View{
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

struct removeFromListButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var cardToDelete: UserMadeFlashCard
    
    var body: some View{
        Button(action: {
            deleteItems(cardToDelete: cardToDelete)
        }, label: {
            Text("Remove from List").padding(.top, 5)
                .font(Font.custom("Arial Hebrew", size: 20))
                .foregroundColor(Color.black)
                .frame(width: 200, height: 40)
                .background(Color.orange)
                .cornerRadius(20)
            
        })
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



struct nextPreviousButtonSet5: View{
    
    @Binding var counter: Int
    @Binding var nextBackClicked: Bool
    
    var myListCards: FetchedResults<UserMadeFlashCard>
    
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
                    if counter < myListCards.count - 1 {
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

struct progressBarMyList: View {

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

struct myListFlashCardActivity_Previews: PreviewProvider {
   static var previews: some View {
    myListFlashCardActivity().environment(\.managedObjectContext,
      PersistenceController.preview.container.viewContext)

   }
}
