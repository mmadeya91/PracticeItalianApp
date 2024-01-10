//
//  RightWrongButtons.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/1/23.
//

import SwiftUI

struct incorrectMCButton: View {
    
    var choiceString: String
    
    @State var defColor = Color.teal
    @State private var pressed: Bool = false
    @State var selected = false
    @Binding var wrongChosen: Bool

    
    var body: some View {
        
        Button(action: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                wrongChosen = false
            }
            
            defColor = Color("wrongRed")
            wrongChosen = true
            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            SoundManager.instance.playSound(sound: .wrong)
            selected.toggle()
            
            
        }, label: {
            Text(choiceString)
                .font(Font.custom("Arial Hebrew", size: 18))
                .padding(.top, 6)
                .padding([.leading, .trailing], 2)
            
        }).frame(width:165, height: 40)
             .background(defColor)
             .foregroundColor(Color.white)
             .cornerRadius(20)
             .overlay( /// apply a rounded border
                 RoundedRectangle(cornerRadius: 20)
                     .stroke(.black, lineWidth: 3)
             )
         
             .shadow(radius: 5)
             .padding(.trailing, 5)
             .offset(x: selected ? -5 : 0)
  

    }
}

struct correctMCButton: View {
    
    var choiceString: String
    
    @State var defColor = Color.teal
    @State private var pressed: Bool = false
    @State var selected = false
    @Binding var counter: Int
    @Binding var correctChosen: Bool
    
    var body: some View {
        
        Button(action: {
            
        }, label: {
            Text(choiceString)
                .font(Font.custom("Arial Hebrew", size: 18))
                .padding(.top, 6)
                .padding([.leading, .trailing], 2)
            
        }).frame(width:165, height: 40)
            .background(defColor)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
            .shadow(radius: 5)
            .padding(.trailing, 5)
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.pressed = pressing
                }
                if pressing {
    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        counter += 1
                        correctChosen = false
                    }
                    defColor = Color("correctGreen")
                    SoundManager.instance.playSound(sound: .correct)
                    correctChosen = true
                 
                  
                }
            }, perform: { })
    }
}


struct correctShortStoryButton: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    
    var body: some View{
        

        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                
                if questionNumber != 3 {
                    questionNumber = questionNumber + 1
                    correctChosen.toggle()
                }else{
                    progress = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showShortStoryDragDrop = true
                    }
                }
                
                if progress != 1 {
                    colorOpacity = 0.0
                    chosenOpacity = 0.0
                }
            }
            
            
                correctChosen = false
         

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 17))
                    .padding([.leading, .trailing], 15)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:330, height: 40)
        .background(Color.green.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .scaleEffect(pressed ? 1.10 : 1.0)
        .padding([.leading, .trailing], 10)
        .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring()) {
                self.pressed = pressing
            }
            if pressing {
                
            } else {
                colorOpacity = 0.40
                chosenOpacity = 1.0
                SoundManager.instance.playSound(sound: .correct)
            }
        }, perform: { })
        
        
    }
    
}

struct incorrectShortStoryButton: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @Binding var correctChosen: Bool
    
    var body: some View{
        

        Button(action: {
            
                chosenOpacity = 1.0
                colorOpacity = 0.4
                SoundManager.instance.playSound(sound: .wrong)

            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            
            selected.toggle()
            
            
        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 17))
                    .padding([.leading, .trailing], 15)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:330, height: 40)
        .background(Color.red.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .offset(x: selected ? -5 : 0)
        .padding([.leading, .trailing], 10)
        .onChange(of: correctChosen) { newValue in
            if newValue == true {
                resetColors()
            }
        }

    }
    
    func resetColors() {
        colorOpacity = 0.0
        chosenOpacity = 0.0
    }
    
}

struct correctLAComprehensionButton: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showDiag: Bool
    
    var body: some View{
        

        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                correctChosen = false
                withAnimation(.linear) {
                    
                        questionNumber = questionNumber + 1
                    if questionNumber == 4 {
                        showDiag = true
                    }
                    
                }
                
                colorOpacity = 0.0
                chosenOpacity = 0.0
            }
            
            correctChosen = true
            

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 14))
                    .padding([.leading, .trailing], 10)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:330, height: 40)
        .background(Color.green.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .scaleEffect(pressed ? 1.10 : 1.0)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 3)
        .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring()) {
                self.pressed = pressing
            }
            if pressing {
                
            } else {
                colorOpacity = 0.40
                chosenOpacity = 1.0
                SoundManager.instance.playSound(sound: .correct)
            }
        }, perform: { })
        
        
    }
    
}

struct incorrectLAComprehensionButton: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    
    var body: some View{
        

        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
               wrongChosen = false
            }
            
                wrongChosen = true
                chosenOpacity = 1.0
                colorOpacity = 0.4
                SoundManager.instance.playSound(sound: .wrong)

            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            
            selected.toggle()
            
            
        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 14))
                    .padding([.leading, .trailing], 5)
                
                Spacer()
                
                Circle().fill(Color.gray.opacity(0.1)).scaleEffect(0.5).overlay(Circle().stroke(.black, lineWidth: 3).scaleEffect(0.5)).overlay(Circle().fill(Color.black.opacity(chosenOpacity)).scaleEffect(0.25))
                
            }.padding([.leading, .trailing], 10)
        })
        .frame(width:330, height: 40)
        .background(Color.red.opacity(colorOpacity))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .offset(x: selected ? -5 : 0)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 3)
        .onChange(of: correctChosen) { newValue in
            if newValue == true {
                resetColors()
            }
        }

    }
    
    func resetColors() {
        colorOpacity = 0.0
        chosenOpacity = 0.0
    }
    
}

struct spellConjVerbButton: View {
    
    var userAnswer: String
    var correctAnswer: String
    
    @State var selected = false
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    
    var body: some View {
        Button(action: {
            if userAnswer.elementsEqual(correctAnswer) {
                questionNumber += 1
                SoundManager.instance.playSound(sound: .correct)
                
            }else {
                selected.toggle()
                SoundManager.instance.playSound(sound: .wrong)
            }
        }, label: {
            Text("Check")
            
        }).font(Font.custom("Marker Felt", size:  18))
            .frame(width:180, height: 40)
            .background(Color.teal)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .offset(x: selected ? -5 : 0)
            .shadow(radius: 10)
            .padding(.trailing, 5)
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.pressed = pressing
                }
            }, perform: { })
    }
}

struct RightWrongButtons_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Text("test")
        }
    }
}
