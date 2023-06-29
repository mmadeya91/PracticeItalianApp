//
//  LAPutDialogueInOrder.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/20/23.
//

import SwiftUI


struct LAPutDialogueInOrder: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    
    @ObservedObject var ListeningActivityQuestionsVM: ListeningActivityQuestionsViewModel

    @State var draggingItem: dialogueBox?
    
    @StateObject var LAPutDialogueInOrderVM: LAPutDialogueInOrderViewModel
    
    @State var isUpdating = false
    @State var reveal = false
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 1)
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size:36))
                    .foregroundColor(.black)
                
            }).padding(.leading, 25)

            
            VStack(spacing: 0){
                
                Text("Place the Dialogue In the Correct Order")
                    .font(Font.custom("", size: 16))
                    .frame(width: 340, height: 35)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                
                
                ScrollView{
                    
                    LazyVGrid(columns: columns, spacing: 20, content: {
                        
                        
                        ForEach(LAPutDialogueInOrderVM.dialogueBoxes){ item in
                            
                            dialogueBoxView(dialogueText: item.dialogueText)
                                .frame(width: 300)
                                .background(.teal.opacity(0.7))
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .opacity(item.id == draggingItem?.id && isUpdating ? 0.5 : 1) // <- HERE
                                .offset(x: item.positionWrong ? -5 : 0)
                                .onDrag {
                                    draggingItem = item
                                    return NSItemProvider(contentsOf: URL(string: "\(item.id)"))!
                                }
                                .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: item, items: $LAPutDialogueInOrderVM.dialogueBoxes, draggingItem: $draggingItem, updating: $isUpdating))
                        }
                    }).animation(.easeIn(duration: reveal ? 2.5 : 0.75), value: LAPutDialogueInOrderVM.dialogueBoxes)
                    
                    
                }.scrollDisabled(true).padding(.top, 20)
                
                HStack{
                    Spacer()
                    Button(action: {
                        
                        for i in 0...LAPutDialogueInOrderVM.dialogueBoxes.count-1{
                            if LAPutDialogueInOrderVM.dialogueBoxes[i].position != i+1 {
                                withAnimation((Animation.default.repeatCount(5).speed(6))) {
                                    LAPutDialogueInOrderVM.dialogueBoxes[i].positionWrong.toggle()
                                }
                                //SoundManager.instance.playSound(sound: .wrong)
                            }
                            else {
                                SoundManager.instance.playSound(sound: .correct)
                            }
                        }
                        
                    }, label: {
                        Text("Check")
                            .font(Font.custom("Chalkboard SE", size: 20)).padding(.bottom, 4)
                            .frame(width: 120, height: 40)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.bottom, 10)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                        
                    
                            LAPutDialogueInOrderVM.dialogueBoxes = LAPutDialogueInOrderVM.correctOrder
                            reveal = true
        
                    }, label: {
                        Text("Reveal")
                            .font(Font.custom("Chalkboard SE", size: 20)).padding(.bottom, 4)
                            .frame(width: 120, height: 40)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.bottom, 10)
                    })
                    Spacer()
                }
            }
        }.onAppear{
            if !reveal {
                LAPutDialogueInOrderVM.dialogueBoxes.shuffle()
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
            .multilineTextAlignment(.leading)
    }
}




struct LAPutDialogueInOrder_Previews: PreviewProvider {
    static let ListeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))
    static let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: ListeningActivityElement.pastaCarbonara.putInOrderDialogueBoxes[0].fullSentences))
    static var previews: some View {
        LAPutDialogueInOrder(ListeningActivityQuestionsVM: ListeningActivityQuestionsVM, LAPutDialogueInOrderVM: LAPutDialogueInOrderVM)
            .environmentObject(ListeningActivityManager())
    }
}
