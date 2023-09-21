//
//  chooseAudio.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/7/23.
//

import SwiftUI

struct chooseAudio: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @State var animatingBear = false
    @State var showInfoPopup = false
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                    .padding(.bottom, 50)
                
                HStack(spacing: 18){
               
                        NavigationLink(destination: chooseActivity(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        }).padding(.leading, 25).padding(.top, 15)
 
                
                    
                    Spacer()
                    VStack{
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
     
                            
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 22))
                        }.padding(.top,10).padding(.trailing, 45)
                    }.padding(.top, 85)
                }.zIndex(2).offset(y:-400)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: -65, y: animatingBear ? -270 : 0)
                
                
                VStack{
                    
                    
                    shortStoryContainer2(showInfoPopUp: $showInfoPopup).frame(width:345, height: 600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 100)
                    .padding(.bottom, 80)
                    
                }
                
                if showInfoPopup{
                    VStack{
                        Text("Listen to the following dialogues performed by a native Italian speaker. \n \nDo your best to comprehend the audio and answer the questions to the best of your ability!")
                            .multilineTextAlignment(.center)
                            .padding()
                    }.frame(width: 300, height: 285)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                }
                
            }.onAppear{
                withAnimation(.easeIn(duration: 1.5)){
                    animatingBear = true
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

struct shortStoryContainer2: View {
    @Binding var showInfoPopUp: Bool
    var body: some View{
        ZStack{
            VStack{
                
                HStack{
                    Text("Audio Stories").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 30))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        withAnimation(.linear){
                            showInfoPopUp.toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                    })
                    .padding(.leading, 5)
                } .frame(width: 350, height: 60)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
                
                audioHStack()
                
            }

        }
    }
}

struct audioHStack: View {
    var body: some View{
        
        let bookTitles: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
        
        ScrollView{
            VStack{
                Text("Beginner")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 120, height: 30)
                    .padding(.top, 10)
                    .border(width: 3, edges: [.bottom], color: .teal)
                HStack{
                    audioChoiceButton(shortStoryName: bookTitles[0], audioImage: "pot")
                    Spacer()
                    audioChoiceButton(shortStoryName:bookTitles[1], audioImage: "dinner")
                }.padding([.leading, .trailing], 28)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                Text("Intermediate")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 175, height: 30)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    audioChoiceButton(shortStoryName: bookTitles[2], audioImage: "directions")
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[3], audioImage: "clothesStore")
                }.padding([.leading, .trailing], 28)
                    .padding(.top, 20)
                
                Text("Hard")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 75, height: 30)
                    .padding(.top, 20)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    audioChoiceButton(shortStoryName:bookTitles[4], audioImage: "renaissance")
                }.padding([.leading, .trailing], 28)
                    .padding(.bottom, 10)
                    .padding(.top, 30)
            }
        }
               
    }
    
}

struct audioChoiceButton: View {
    
    
    var shortStoryName: String
    var audioImage: String
    
    var body: some View{
        ZStack {
            
            VStack(spacing: 0){

                
                let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
                let listeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))

                NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityVM, listeningActivityQuestionsVM: listeningActivityQuestionsVM), label: {
                    Image(audioImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                    
                        .padding()
                        .background(.white)
                        .cornerRadius(60)
                        .overlay( RoundedRectangle(cornerRadius: 60)
                            .stroke(.black, lineWidth: 3))
                        .shadow(radius: 10)
                    
                    
                })
                .padding(.top, 5)
                
                
                Text(shortStoryName)
                    .font(Font.custom("Futura", size: 18))
                    .frame(width: 130, height: 80)
                    .multilineTextAlignment(.center)
                
            }
        }
    }
    
}


struct chooseAudio_Previews: PreviewProvider {
    static var previews: some View {
        chooseAudio()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(AudioManager())
                .environmentObject(GlobalModel())
    }
}
