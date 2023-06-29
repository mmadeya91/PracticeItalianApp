//
//  chooseAudio.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/7/23.
//

import SwiftUI

struct chooseAudio: View {
    
    @EnvironmentObject var audioManager: AudioManager
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                VStack{
                    
                    customTopNavBar()
                    
                    shortStoryContainer2().frame(width: 345, height:675).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 6))
                        .shadow(radius: 10)

                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct shortStoryContainer2: View {
    var body: some View{
        ZStack{
            VStack{
                
                Text("Short Stories")
                    .font(Font.custom("Marker Felt", size: 30))
                    .frame(width: 350, height: 60)
                    .background(Color.teal).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .yellow)
                
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
                    .font(Font.custom("Marker Felt", size: 18))
                    .frame(width: 110, height: 50).background(.white).cornerRadius(10)
                    .multilineTextAlignment(.center)
                
                
                let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
                let listeningActivityQuestionsVM = ListeningActivityQuestionsViewModel(dialogueQuestionView: dialogueViewObject(fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion))

                NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityVM, listeningActivityQuestionsVM: listeningActivityQuestionsVM), label: {
                    Image(audioImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 80)
                })
                
                
                
            }
        }.background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.teal.opacity(0.6))
                .frame(width: 130, height: 160)
                .shadow(radius: 5)
        )
    }
    
}


struct chooseAudio_Previews: PreviewProvider {
    static var previews: some View {
        chooseAudio()
            .environmentObject(AudioManager())
    }
}
