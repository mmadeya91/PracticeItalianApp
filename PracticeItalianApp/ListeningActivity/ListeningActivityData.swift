//
//  ListeningActivityData.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/15/23.
//

import Foundation

class ListeningActivityData {
    
    var chosenAudioName: String
    
    init(chosenAudioName: String) {
        self.chosenAudioName = chosenAudioName
    }
    
    func collectChosenAudioData(chosenAudio: String) -> ListeningActivtyDataObject {
        
        let listeningActivityDataList: [ListeningActivityElement] = ListeningActivityElement.allListeningActivityElements
        
        var chosenAudioObject: ListeningActivityElement = listeningActivityDataList[0]
        
        listeningActivityDataList.forEach { audioObject in
            if audioObject.audioName == chosenAudioName {
                chosenAudioObject = audioObject
            }
        }
        
        let audioName = chosenAudioObject.audioName
        let audioTranscriptItalian = chosenAudioObject.audioTranscriptItalian
        let audioTranscriptEnglish = chosenAudioObject.audioTranscriptEnglish
        let comprehensionQuestions = chosenAudioObject.comprehensionQuestions
        let fillInDialogueQuestions = chosenAudioObject.fillInDialogueQuestion
        let blankExplanationQuestions = chosenAudioObject.blankExplanation
        
        let audioActivityObj = ListeningActivtyDataObject(audioName: audioName, audioTranscriptItalian: audioTranscriptItalian, audioTranscriptEnglish: audioTranscriptEnglish, comprehensionQuestioList: comprehensionQuestions, fillInDialogueQuestionList: fillInDialogueQuestions, blankExplanationList: blankExplanationQuestions)
        
        return audioActivityObj
    }
    
    
}
