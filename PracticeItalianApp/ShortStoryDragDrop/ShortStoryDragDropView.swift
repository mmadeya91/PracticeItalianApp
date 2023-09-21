//
//  ShortStoryDragDropView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/29/23.
//

import SwiftUI

struct ShortStoryDragDropView: View{
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    @Environment(\.dismiss) var dismiss
    var isPreview: Bool
    @State var questionNumber = 0
    @State var showPlayer = false
    @State var showUserCheck = false
    
    let shortStoryVM = ShortStoryViewModel(currentStoryIn: 0)
    
    var body: some View{
        GeometryReader {geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            HStack{
                Button(action: {
                    withAnimation(.linear){
                        showUserCheck.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 25))
                        .foregroundColor(.gray)
                    
                })

                    
                Spacer()
                Image("italyFlag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .shadow(radius: 10)
            }.padding([.leading, .trailing], 15).zIndex(1)
            
            if showUserCheck {
                userCheckNavigationPopUp(showUserCheck: $showUserCheck)
                    .transition(.slide)
                    .animation(.easeIn)
                    .padding(.leading, 60)
                    .padding(.top, 60)
                    .zIndex(2)
            }
            
            ScrollViewReader{scroller in
                
                ZStack{
                    
                    VStack{
              
                        ScrollView(.horizontal){
                            
                            HStack{
                                ForEach(0..<shortStoryDragDropVM.currentDragDropQuestions.count, id: \.self) { i in
                                    VStack{
                                        
                                        
                                        
                                        
                                        shortStoryDragDropViewBuilder(charactersSet: shortStoryDragDropVM.currentDragDropChoicesList, questionNumber: $questionNumber, englishSentence: shortStoryDragDropVM.currentDragDropQuestions[i].fullSentence).frame(width: geo.size.width)
                                            .frame(minHeight: geo.size.height)
                                    }
                                    
                                }
                            }
                            
                        }
                        .scrollDisabled(true)
                        .onChange(of: questionNumber) { newIndex in
                            withAnimation{
                                scroller.scrollTo(newIndex, anchor: .center)
                            }
                            
                            if questionNumber == shortStoryDragDropVM.currentDragDropQuestions.count {
                                showPlayer = true
                            }
                        }
                        
                        
                    }.zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WashedWhite"))
                        .frame(width: 360, height: 370)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4)
                        )
                        .zIndex(0)
                        .offset(y:130)
                        
                    
                    
                }
                .fullScreenCover(isPresented: $showPlayer) {
                    NavigationView{
                        ShortStoryPlugInView(shortStoryPlugInVM: shortStoryVM)
                    }
                }
                .onAppear{
                    shortStoryDragDropVM.setData()
                    shortStoryDragDropVM.setChoiceArrayDataSet()
                }
            }
        }
    }
}

struct shortStoryDragDropViewBuilder: View {
        
    @State var progress: CGFloat = 0
    
    //choices
    @State var charactersSet: [[dragDropShortStoryCharacter]]
    
    @State var characters: [dragDropShortStoryCharacter] = []
    
    //for drag
    @State var shuffledRows: [[dragDropShortStoryCharacter]] = []
    //for drop
    @State var rows: [[dragDropShortStoryCharacter]] = []
    
    @State var draggingItem: dragDropShortStoryCharacter?
    @State var updating: Bool = false
    
    @State var animateWrongText: Bool = false
    
    @State var droppedCount: CGFloat = 0
    @Binding var questionNumber: Int
    
    var englishSentence: String
    
    var body: some View {
        VStack {
            NavBar().padding(.bottom, 20)
            
            VStack {
                Text("Form this sentence")
                    .font(.title2.bold())
                    .padding(.bottom, 60)
                    
                Text(englishSentence)
                    .bold()
                    .font(Font.custom("Marker Felt", size: 20))
                    .padding([.leading, .trailing], 3)
                    .frame(width:300, height: 110)
                    .background(Color.teal)
                    .cornerRadius(10)
                    .foregroundColor(Color("WashedWhite"))
                    .multilineTextAlignment(.center)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black, lineWidth: 4)
                    )
            }
            DropArea()
                .padding(.vertical, 30)
            DragArea()
        }
        .padding()
        .onChange(of: questionNumber) { newIndex in
            rows.removeAll()
            shuffledRows.removeAll()
            characters = charactersSet[newIndex]
            if rows.isEmpty{
                //First Creating shuffled On
                //then normal one
                characters = characters.shuffled()
                rows = generateGrid()
                shuffledRows = generateGrid()
                rows = generateGrid()
            }
    
        }
        .onAppear{
            if questionNumber == 0{
                characters = charactersSet[0]
            }else{
                characters = charactersSet[questionNumber]
            }
            if rows.isEmpty{
                //First Creating shuffled On
                //then normal one
                characters = characters.shuffled()
                rows = generateGrid()
                shuffledRows = generateGrid()
                rows = generateGrid()
            }
        }
        .offset(x: animateWrongText ? -30 : 0)
    }
    
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 12){
            ForEach($rows, id: \.self){$row in
                HStack(spacing:10){
                    ForEach($row){$item in
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .opacity(item.isShowing ? 1 : 0)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1: 0)
                            }
                            .onDrop(of: [.url], delegate: ShortStoryDragDropDelegate(currentItem: $item, characters: $characters, draggingItem: $draggingItem, updating: $updating, droppedCount: $droppedCount, animateWrongText: $animateWrongText, shuffledRows: $shuffledRows, progress: $progress, questionNumber: $questionNumber))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func DragArea()->some View {
        VStack(spacing: 12){
            ForEach(shuffledRows, id: \.self){row in
                HStack(spacing:10){
                    ForEach(row){item in
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                            .onDrag{
                                return .init(contentsOf: URL(string: item.id))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder
    func NavBar() -> some View{
        HStack(spacing: 18){
            Spacer()
            GeometryReader{proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.gray.opacity(0.25))
                    
                    Capsule()
                        .fill(Color.green)
                        .frame(width: proxy.size.width * CGFloat(progress))
                }
            }.frame(height: 13)
            Spacer()
        }
        
    }
    
    func generateGrid()->[[dragDropShortStoryCharacter]]{
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
            
        }
        
        var gridArray: [[dragDropShortStoryCharacter]] = []
        var tempArray: [dragDropShortStoryCharacter] = []
        
        var currentWidth: CGFloat = 0
        
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in characters {
            currentWidth += character.textSize
            
            if currentWidth < totalScreenWidth{
                tempArray.append(character)
            }else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        
        return gridArray
    }
    
    func textSize(character: dragDropShortStoryCharacter)->CGFloat{
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
    }
    
    func updateShuffledArray(character: dragDropShortStoryCharacter){
        for index in shuffledRows.indices{
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == character.id{
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateWrongText = false
            }
        }
    }
}

struct userCheckNavigationPopUp: View{
    @Binding var showUserCheck: Bool
    
    var body: some View{
        
        
        ZStack{
            VStack{
                
                
                Text("Are you Sure you want to Leave the Page?")
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 17))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                
                Text("You will be returned to the 'select story page' and progress on this exercise will be lost")
                    .font(Font.custom("Arial Hebrew", size: 15))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                
                HStack{
                    Spacer()
                    NavigationLink(destination: availableShortStories(), label: {
                        Text("Yes")
                            .font(Font.custom("Arial Hebrew", size: 15))
                            .foregroundColor(Color.blue)
                    })
                    Spacer()
                    Button(action: {showUserCheck.toggle()}, label: {
                        Text("No")
                            .font(Font.custom("Arial Hebrew", size: 15))
                            .foregroundColor(Color.blue)
                    })
                    Spacer()
                }
            }
                
    
        }.frame(width: 265, height: 200)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
    }
}

struct ShortStoryDragDropView_Previews: PreviewProvider {
    static var shortStoryDragDropVM: ShortStoryDragDropViewModel = ShortStoryDragDropViewModel(chosenStory: 0)
    static var previews: some View {
        ShortStoryDragDropView(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: true)
    }
}

