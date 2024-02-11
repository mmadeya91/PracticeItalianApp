//
//  LAPutDialogueInOrder.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/20/23.
//

import SwiftUI


struct LAPutDialogueInOrder: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    
    @ObservedObject var globalModel = GlobalModel()

    @State var draggingItem: dialogueBox?
    
    @StateObject var LAPutDialogueInOrderVM: LAPutDialogueInOrderViewModel
    
    @State var isUpdating = false
    @State var reveal = false
    @State var animatingBear = false
    @State var correctChosen = false
    @State var animateInvalidEntry: Bool = false
    @State var wrongOrder = false
    @State var showUserCheck: Bool = false
    @State var showFinishedActivityPage: Bool = false
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 1)
    
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
                    Image("verticalNature")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    
                    
                    HStack(spacing: 18){
                        Button(action: {
                            showUserCheck.toggle()
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
                    }.padding([.leading, .trailing], 25)
                    
                    if showUserCheck {
                        userCheckNavigationPopUpListeningActivity(showUserCheck: $showUserCheck)
                            .transition(.slide)
                            .animation(.easeIn)
                            .padding(.leading, 5)
                            .padding(.top, 60)
                            .zIndex(2)
                    }
                    
        
                        
                        
                        
                        VStack(spacing: 0){
                            
                            ScrollView{
                                
                                LazyVGrid(columns: columns, spacing: 18, content: {
                                    
                                    Text("Rearrange to the Correct Order")
                                        .font(Font.custom("Chalkboard SE", size: 18))
                                        .foregroundColor(.black)
                                       
                                    
                                    ForEach(LAPutDialogueInOrderVM.dialogueBoxes){ item in
                                        
                                        Text(item.dialogueText)
                                            .font(Font.custom("", size: geo.size.height * 0.0178))
                                            .padding([.leading, .trailing], 5)
                                            .padding([.top, .bottom], 6)
                                            .multilineTextAlignment(.leading)
                                        //                                    dialogueBoxView(dialogueText: item.dialogueText)
                                            .frame(width: geo.size.width * 0.85)
                                            .padding([.top, .bottom], 2)
                                            .padding([.leading, .trailing], 5)
                                            .background(item.positionWrong ? .red.opacity(0.7) : .white.opacity(0.9))
                                            .cornerRadius(10)
                                            .overlay( /// apply a rounded border
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.black, lineWidth: 2)
                                            )
                                            .opacity(item.id == draggingItem?.id && isUpdating ? 0.5 : 1) // <- HERE
                                            .scaleEffect(item.positionWrong ? 1.02 : 1)
                                            .onDrag {
                                                draggingItem = item
                                                return NSItemProvider(contentsOf: URL(string: "\(item.id)"))!
                                            }
                                            .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: item, items: $LAPutDialogueInOrderVM.dialogueBoxes, draggingItem: $draggingItem, updating: $isUpdating))
                                    }
                                }).animation(.easeIn(duration: reveal ? 2.5 : 0.75), value: LAPutDialogueInOrderVM.dialogueBoxes)
                                    .offset(y: 50)
                                
                                
                            }.scrollDisabled(true)
                            
                            HStack{
                                Spacer()
                                var tempLoopCounter = 0
                                
                                Button(action: {
                                    
                                    var tempCheck = false
                                    
                                    while tempLoopCounter <= LAPutDialogueInOrderVM.dialogueBoxes.count-1 {
                                        
                                        if LAPutDialogueInOrderVM.dialogueBoxes[tempLoopCounter].position != tempLoopCounter+1 {
                                            withAnimation(.spring()){
                                                LAPutDialogueInOrderVM.dialogueBoxes[tempLoopCounter].positionWrong = true
                                                
                                                
                                            }
                                            tempCheck = true
                                        }else{
                                            withAnimation(.spring()){
                                            LAPutDialogueInOrderVM.dialogueBoxes[tempLoopCounter].positionWrong = false
                                            }
                                        }
                                        
                                        tempLoopCounter += 1
                                        
                                    }
                                    
                                    if tempCheck {
                                        wrongOrder = true
                                    }
                                    
                                    
                                    if !wrongOrder {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                                            showFinishedActivityPage = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            correctChosen = false
                                        }
                                        correctChosen = true
                                        
                                        SoundManager.instance.playSound(sound: .correct)
                                    }else{
                                        SoundManager.instance.playSound(sound: .wrong)
                                        animateView()
                                    }
                                    
                                }, label: {
                                    Text("Check")
                                        .font(Font.custom("Chalkboard SE", size: 18)).padding(.bottom, 4)
                                        .foregroundColor(.white)
                                        .frame(width: 110, height: 35)
                                        .background(Color("DarkNavy"))
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( /// apply a rounded border
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: 3)
                                        )
                                })
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    for var item in LAPutDialogueInOrderVM.dialogueBoxes {
                                        item.positionWrong = false
                                    }
                                    
                                    wrongOrder = false
                                    
                                    LAPutDialogueInOrderVM.dialogueBoxes = LAPutDialogueInOrderVM.correctOrder
                                    reveal = true
                                    
                                }, label: {
                                    Text("Reveal")
                                        .font(Font.custom("Chalkboard SE", size: 18)).padding(.bottom, 4)
                                        .foregroundColor(.white)
                                        .frame(width: 110, height: 35)
                                        .background(Color("DarkNavy"))
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( /// apply a rounded border
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: 3)
                                        )
                                })
                                Spacer()
                            }
                            
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.95)
                            .padding([.leading, .trailing], geo.size.width * 0.05)
                            .padding(.top, 10)
                            .offset(x: animateInvalidEntry ? -30 : 0)
                  
                    
                    
                    
                    NavigationLink(destination: ActivityCompletePage(),isActive: $showFinishedActivityPage,label:{}
                    ).isDetailLink(false)
                    
                }.navigationBarBackButtonHidden(true)
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    if !reveal {
                        LAPutDialogueInOrderVM.dialogueBoxes.shuffle()
                    }
                }
            }else{
                LAPutDialogueInOrderIPAD(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM)
            }
        }
    }
    
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateInvalidEntry = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateInvalidEntry  = false
            }
        }
    }
    
}
                   
    

struct dialogueBoxView: View {

    var dialogueText: String

    var body: some View {
        Text(dialogueText)
            .font(Font.custom("Chalkboard SE", size: 11))
            .padding(5)
            .padding([.leading, .trailing], 10)
            .multilineTextAlignment(.leading)
    }
}




struct LAPutDialogueInOrder_Previews: PreviewProvider {
    static let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: ListeningActivityElement.cosaDesidera.putInOrderDialogueBoxes[0].fullSentences))
    static var previews: some View {
        LAPutDialogueInOrder(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM)
            .environmentObject(ListeningActivityManager())
            .environmentObject(GlobalModel())
    }
}
