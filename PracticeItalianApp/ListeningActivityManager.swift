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
    
    @Published var currentHintLetterArray: [hintLetter] = [hintLetter]()
    
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
        var tempArray = [hintLetter]()
        for letterObject in fillInBlankDialogueObj.answerArray {
            var tempAnswer = ""
            if letterObject.answer != nil {
                tempAnswer = letterObject.answer!
            }
            
            let newHintLetter = hintLetter(letter: letterObject.letter!, showLetter: letterObject.showLetter, answer: tempAnswer)
            tempArray.append(newHintLetter)
        }
        currentHintLetterArray = tempArray
        
        
    }
    
    func resetCurrentHintLetterArray() {
        currentHintLetterArray = [hintLetter]()
    }
    
    func showHint(){
        var count = currentHintLetterArray.count
        
        for i in 0...count-1 {
            currentHintLetterArray[i].showLetter = true
        }
    }
    

}

struct hintLetter: Hashable{
    let id = UUID()
    let letter: String
    var showLetter: Bool
    let answer: String
}
