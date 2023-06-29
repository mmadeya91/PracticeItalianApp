//
//  ListeningActivityManager.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/15/23.
//

import Foundation

final class ListeningActivityManager: ObservableObject {
    @Published var listeningAcitivtyManager: ListeningActivityManager?
    
    @Published private(set) var ListeningData: [ListeningActivityElement] = ListeningActivityElement.allListeningActivityElements
    
    @Published var currentHintLetterArray: [AnswerArray] = [AnswerArray]()
    
    func retrieveListeningActivityData(chosenAudioName: String) -> ListeningActivityElement {
        
        var listeningActivtyObj: ListeningActivityElement?
        
        ListeningData.forEach { audioObject in
            if audioObject.audioName == chosenAudioName {
                listeningActivtyObj = audioObject
            }
        }
        
        return listeningActivtyObj!
    }
    
    func setCurrentHintLetterArray(fillInBlankDialogueObj: FillInDialogueQuestion) {
        currentHintLetterArray = fillInBlankDialogueObj.answerArray
    }
    
    func resetCurrentHintLetterArray() {
        currentHintLetterArray = [AnswerArray]()
    }
    
    func showHint(){
        var count = currentHintLetterArray.count
        
        for i in 0...count-1 {
            currentHintLetterArray[i].showLetter = true
        }
    }

}
