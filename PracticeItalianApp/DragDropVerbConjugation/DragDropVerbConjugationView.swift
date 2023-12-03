//
//  DragDropVerbConjugationView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/30/23.
//

import SwiftUI

struct DragDropVerbConjugationView: View {
    @StateObject var dragDropVerbConjugationVM: DragDropVerbConjugationViewModel
    @Environment(\.dismiss) var dismiss
    var isPreview: Bool
    @State var questionNumber = 0
    @State var wrongChosen = false
    @State var correctChosen = false
    @State var animatingBear = false
    @State var showFinishedActivityPage = false
    
  
    
    var body: some View{
        GeometryReader {geo in
            
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            
            ScrollViewReader{scroller in
                
                ZStack{
                    
                    VStack{
                        HStack(spacing: 18){
                            NavigationLink(destination: chooseVerbList(), label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                            })
                            
                            Spacer()
                            
                            Text(String(questionNumber) + "/" + String( dragDropVerbConjugationVM.currentTenseDragDropData.count))
                                .font(.title3)
                                .foregroundColor(.black)
                            
                            
                            Image("italyFlag")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
        
                        }.padding([.leading, .trailing], 25)
                        
                        Text(getTenseString(tenseIn: dragDropVerbConjugationVM.currentTense))
                            .font(Font.custom("Chalkboard SE", size: 25))
                            .underline()
                        
                        ScrollView(.horizontal){
                            
                            HStack{
                                ForEach(0..<dragDropVerbConjugationVM.currentTenseDragDropData.count, id: \.self) { i in
                                    VStack{
                                        dragDropViewBuilder(tense: dragDropVerbConjugationVM.currentTense, currentVerb: dragDropVerbConjugationVM.currentTenseDragDropData[i].currentVerb, characters: dragDropVerbConjugationVM.currentTenseDragDropData[i].choices , leftDropCharacters: dragDropVerbConjugationVM.currentTenseDragDropData[i].dropVerbListLeft, rightDropCharacters: dragDropVerbConjugationVM.currentTenseDragDropData[i].dropVerbListRight, questionNumber: $questionNumber, correctChosen: $correctChosen, wrongChosen: $wrongChosen).frame(width: geo.size.width)
                                            .frame(minHeight: geo.size.height)
                                    }
                                        .offset(y:-90)
                                    
                                }
                            }
                            
                        }
                        .scrollDisabled(true)
                        .frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .onChange(of: questionNumber) { newIndex in
                            
                            if newIndex > dragDropVerbConjugationVM.currentTenseDragDropData.count - 1 {
                                showFinishedActivityPage = true
                            }else{
                                
                                withAnimation{
                                    scroller.scrollTo(newIndex, anchor: .center)
                                }
                            }
                            
                        
                        }
                        
                        
                    }.zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WashedWhite"))
                        .frame(width: 365, height: 440)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4)
                        )
                        .offset(y: 50)
                        .zIndex(0)
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 100)
                        .offset(x: 130, y: animatingBear ? 350 : 750)
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 280)
                    }
                          
                    if wrongChosen{
                        
                        let randomInt2 = Int.random(in: 1..<4)
                        
                        Image("bubbleChatWrong"+String(randomInt2))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(y: 280)
                    }
                    
                    NavigationLink(destination:  ActivityCompletePage(),isActive: $showFinishedActivityPage,label:{}
                                                      ).isDetailLink(false)
                    
                }.onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    if isPreview {
                        dragDropVerbConjugationVM.currentTense = 0
                        dragDropVerbConjugationVM.setNonMyListDragDropData()
                    }
                }
            }
        }
    }
    func getTenseString(tenseIn: Int)->String{
        switch tenseIn {
        case 0:
            return "Presente"
        case 1:
            return "Passato Prossimo"
        case 2:
            return "Futuro"
        case 3:
            return "Imperfetto"
        case 4:
            return "Presente Condizionale"
        case 5:
            return "Imperativo"
        default:
            return "No Tense"
        }
    }
    
}


struct dragDropViewBuilder: View{
    
    var tense: Int
    var currentVerb: Verb
    
    @State var progress: CGFloat = 0
    //choices list
    @State var characters: [VerbConjCharacter]
    @State var leftDropCharacters: [VerbConjCharacter]
    @State var rightDropCharacters: [VerbConjCharacter]
    
    @State var draggingItem: VerbConjCharacter?
    
    //for drag
    @State var shuffledRows: [[VerbConjCharacter]] = []
    //for drop
    @State var rows: [[VerbConjCharacter]] = []
    
    @State var animateWrongText: Bool = false
    
    @State var droppedCount: CGFloat = 0
    @State var updating: Bool = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    
    @State var dropCounter = 1
    
    var body: some View {
        VStack(spacing: 15) {
            NavBar().padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Complete the Table")
                    .font(.title2.bold())
                
                
                
            }
            VStack{
                Text(currentVerb.verbName + "\n" + currentVerb.verbEngl)
                    .font(.title2.bold()).multilineTextAlignment(.center)
                    .frame(width: 230, height: 80)
                    .background(.teal)
                    .cornerRadius(15)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black, lineWidth: 4)
                    )
                    .padding(.bottom, 20)
                
                VStack{
                    HStack{
                        Spacer()
                        LeftDropArea().padding(.trailing, 10)
                        Spacer()
                        RightDropArea().padding(.leading, 40)
                        Spacer()
                        
                    }
                }.offset(x:7)
            }.padding(.bottom, 20)
            DragArea()
        }
        .padding()
        .onAppear{
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
    func LeftDropArea()->some View{
        VStack(spacing:10){
            ForEach($leftDropCharacters){$item in
                Text(item.value)
                    .font(.system(size: item.fontSize))
                    .opacity(item.isShowing ? 1 : 0)
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(item.isShowing ? .teal : .gray.opacity(0.25))
                            .frame(width: 160, height: 40)
                        
                    }
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.gray)
                            .opacity(item.isShowing ? 1: 0)
                            .frame(width: 160, height: 40)
                            
                        
                    }
                    .padding([.top, .bottom], 10)
                    .onDrop(of: [.url], delegate: VerbConjDropDelegate(currentItem: $item, characters: $characters, draggingItem: $draggingItem, updating: $updating, droppedCount: $droppedCount, animateWrongText: $animateWrongText, shuffledRows: $shuffledRows, progress: $progress, questionNumber: $questionNumber, correctChosen: $correctChosen, wrongChosen: $wrongChosen))
         
            
            }
        }
        
    }
    
//    func getCorrectPerson(personIn: Int)->String{
//
//        switch personIn {
//        case 1:
//            return "Io"
//            dropCounter = dropCounter + 1
//        case 2:
//            return "Tu"
//            dropCounter = dropCounter + 1
//        case 3:
//            return "Lui/Lei/Lei"
//            dropCounter = dropCounter + 1
//        case 4:
//            dropCounter = dropCounter + 1
//            return "Noi"
//        case 5:
//            dropCounter = dropCounter + 1
//            return "Voi"
//        case 6:
//            dropCounter = dropCounter + 1
//            return "Loro"
//        default:
//            dropCounter = dropCounter + 1
//            return "Io"
//        }
//
//    }
    
    
    @ViewBuilder
    func RightDropArea()->some View{
        VStack(spacing:10){
            ForEach($rightDropCharacters){$item in
                Text(item.value)
                    .font(.system(size: item.fontSize))
                    .opacity(item.isShowing ? 1 : 0)
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(item.isShowing ? .teal : .gray.opacity(0.25))
                            .frame(width: 160, height: 40)
                        
                    }
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.gray)
                            .opacity(item.isShowing ? 1: 0)
                            .frame(width: 160, height: 40)
                        
                    }
                    .padding([.top, .bottom], 10)
                    .onDrop(of: [.url], delegate: VerbConjDropDelegate(currentItem: $item, characters: $characters, draggingItem: $draggingItem, updating: $updating, droppedCount: $droppedCount, animateWrongText: $animateWrongText, shuffledRows: $shuffledRows, progress: $progress, questionNumber: $questionNumber, correctChosen: $correctChosen, wrongChosen: $wrongChosen))
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
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .stroke(.gray)
                            }
                            .onDrag{
                                draggingItem = item
                                return NSItemProvider(contentsOf: URL(string: "\(item.id)"))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background{
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                                
                            }
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder
    func NavBar() -> some View{
        
        GeometryReader{proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.gray.opacity(0.25))
                
                Capsule()
                    .fill(Color.green)
                    .frame(width: proxy.size.width * progress)
            }
        }.frame(height: 20)
        
    }
    
    func generateGrid()->[[VerbConjCharacter]]{
        
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
            
        }
        
        var gridArray: [[VerbConjCharacter]] = []
        var tempArray: [VerbConjCharacter] = []
        
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
    
    
    func textSize(character: VerbConjCharacter)->CGFloat{
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
    }
    
    func updateShuffledArray(character: VerbConjCharacter){
        for index in shuffledRows.indices{
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == character.id{
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
}


struct DragDropVerbConjugationView_Previews: PreviewProvider {
    static var dragDropVM: DragDropVerbConjugationViewModel = DragDropVerbConjugationViewModel()
    
    static var previews: some View {
        DragDropVerbConjugationView(dragDropVerbConjugationVM:  dragDropVM, isPreview: true)
    }
}
