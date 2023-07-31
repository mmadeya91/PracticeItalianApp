//
//  VerbConjDropDelegate.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/1/23.
//

import SwiftUI

struct VerbConjDropDelegate: DropDelegate{
    
    @Binding var currentItem: VerbConjCharacter
    var characters: Binding<[VerbConjCharacter]>
    var draggingItem: Binding<VerbConjCharacter?>
    @Binding var updating: Bool
    @Binding var droppedCount: CGFloat
    @Binding var animateWrongText: Bool
    @Binding var shuffledRows: [[VerbConjCharacter]]
    @Binding var progress: CGFloat
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    

    func performDrop(info: DropInfo) -> Bool {
        
        if let first = info.itemProviders(for: [.url]).first{
            let _ = first.loadObject(ofClass: URL.self) {
                value,error in

                guard let url = value else{return}
                if currentItem.id == "\(url)"{
                    droppedCount += 1
                    
                    if droppedCount == 6{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            questionNumber += 1
                            correctChosen = false
                        }
                        correctChosen = true
                    }
                    
                    let progress = (droppedCount / 6)
                    withAnimation{
                        currentItem.isShowing = true
                        SoundManager.instance.playSound(sound: .correct)
                        updateShuffledArray(character: currentItem)
                        self.progress = progress

                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        wrongChosen = false
                    }
                    wrongChosen = true
                    SoundManager.instance.playSound(sound: .wrong)
                    animateView()
                }
            }
        }
        
        return false
    }
    
    func dropEntered(info: DropInfo) {

    }
           
    func dropUpdated(info: DropInfo) -> DropProposal? {
       return DropProposal(operation: .move)
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

