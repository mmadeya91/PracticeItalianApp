//
//  chooseAudio.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/7/23.
//

import SwiftUI

struct chooseAudio: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @State var animatingBear = false
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: 85, y: animatingBear ? -230 : 0)
                
                
                VStack{
                    
                    NavigationLink(destination: chooseActivity(), label: {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }).padding(.trailing, 290)
                    
                    shortStoryContainer2().frame(width:345).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 90)
                    .padding(.bottom, 80)
                    
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
    var body: some View{
        ZStack{
            VStack{
                
                Text("Short Stories")
                    .font(Font.custom("Marker Felt", size: 30))
                    .foregroundColor(Color("WashedWhite"))
                    .frame(width: 350, height: 60)
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
                }.padding([.leading, .trailing], 35)
                    .padding(.top, 30)
                    .padding(.bottom, 50)
                
                Text("Intermediate")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 175, height: 30)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    audioChoiceButton(shortStoryName: bookTitles[2], audioImage: "directions")
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[3], audioImage: "clothesStore")
                }.padding([.leading, .trailing], 35)
                    .padding(.top, 30)
                
                Text("Hard")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 75, height: 30)
                    .padding(.top, 50)
                    .border(width: 3, edges: [.bottom], color: .teal)
                
                HStack{
                    audioChoiceButton(shortStoryName:bookTitles[4], audioImage: "renaissance")
                }.padding([.leading, .trailing], 35)
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
                
                Text(shortStoryName)
                    .font(Font.custom("Futura", size: 15))
                    .padding([.leading, .trailing], 2)
                    .frame(width: 110, height: 50).background(Color("WashedWhite")).cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
                
                
                let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
                let listeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))

                NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityVM, listeningActivityQuestionsVM: listeningActivityQuestionsVM), label: {
                    Image(audioImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 70)
                        .padding(.top, 6)
                    
                })
                .padding(.top, 5)
                
                
                
            }
        }.background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.teal.opacity(0.6))
                .frame(width: 130, height: 160)
                .shadow(radius: 10)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black, lineWidth: 4)
                )
        )
    }
    
}


struct chooseAudio_Previews: PreviewProvider {
    static var previews: some View {
        chooseAudio()
            .environmentObject(AudioManager())
    }
}
