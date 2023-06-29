//
//  ListeningActivtyDataObject.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/15/23.
//

import Foundation

class ListeningActivtyDataObject {
    var audioName: String
    var audioTranscriptItalian: String
    var audioTranscriptEnglish: String
    var comprehensionQuestioList: [ComprehensionQuestion]
    var fillInDialogueQuestionList: [FillInDialogueQuestion]
    var blankExplanationList: [BlankExplanation]
    
    init(audioName: String, audioTranscriptItalian: String, audioTranscriptEnglish: String, comprehensionQuestioList: [ComprehensionQuestion], fillInDialogueQuestionList: [FillInDialogueQuestion], blankExplanationList: [BlankExplanation]) {
        self.audioName = audioName
        self.audioTranscriptItalian = audioTranscriptItalian
        self.audioTranscriptEnglish = audioTranscriptEnglish
        self.comprehensionQuestioList = comprehensionQuestioList
        self.fillInDialogueQuestionList = fillInDialogueQuestionList
        self.blankExplanationList = blankExplanationList
    }   
}
