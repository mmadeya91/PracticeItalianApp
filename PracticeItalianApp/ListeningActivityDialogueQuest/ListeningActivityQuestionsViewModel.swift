//
//  ListeningActivityQuestionsViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/12/23.
//

import Foundation

final class ListeningActivityQuestionsViewModel: ObservableObject {
    private(set) var dialogueQuestionView: dialogueViewObject
    
    init(dialogueQuestionView: dialogueViewObject) {
        self.dialogueQuestionView = dialogueQuestionView
    }
}

struct dialogueViewObject {
    let id = UUID()
    var fillInDialogueQuestionElement: [FillInDialogueQuestion]
    
  
    
}





