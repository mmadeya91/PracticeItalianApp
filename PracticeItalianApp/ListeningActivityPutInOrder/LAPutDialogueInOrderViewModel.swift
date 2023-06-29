//
//  LAPutDialogueInOrderViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/20/23.
//

import Foundation

final class LAPutDialogueInOrderViewModel: ObservableObject {
    
    private(set) var dialoguePutInOrderVM: dialoguePutInOrderObj
    
    @Published var selectedBox = "box"
    
    @Published var dialogueBoxes = [dialogueBox]()
    
    var stringArray = [String]()
    
    var correctOrder = [dialogueBox]()
    
    init(dialoguePutInOrderVM: dialoguePutInOrderObj) {
        self.dialoguePutInOrderVM = dialoguePutInOrderVM
        self.dialogueBoxes = dialoguePutInOrderVM.dialogueBoxArray
        self.correctOrder = dialoguePutInOrderVM.dialogueBoxArray
    }
    
}

struct dialoguePutInOrderObj {
    let id = UUID()
    var dialogueBoxArray = [dialogueBox]()
    var stringArray = [FullSentence]()
    
    init(stringArray: [FullSentence]) {
        self.dialogueBoxArray = setDialogueBoxes(stringArray: stringArray)
    }
    
    func setDialogueBoxes(stringArray: [FullSentence]) -> [dialogueBox]{
        
        
        var placeHolderArray = [dialogueBox]()
        
        for text in stringArray {
            placeHolderArray.append((dialogueBox(dialogueText: text.sentence, position: text.position)))
        }
        
        return placeHolderArray
    }
    
}

struct dialogueBox: Identifiable, Equatable {
   let id = UUID().uuidString
    let dialogueText: String
    let position: Int
    var positionWrong = false
}
