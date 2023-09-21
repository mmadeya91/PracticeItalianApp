//
//  shortStoryData.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/8/23.
//

import Foundation


class shortStoryData {
    
    var chosenStoryName: String
    
    init(chosenStoryName: String) {
        self.chosenStoryName = chosenStoryName
    }
    
    func collectShortStoryData(storyName: String) -> shortStoryObject{
        
        let shortStoryList: [storyObject] = storyObject.allStoryObjects
        
        var chosenStoryObject: storyObject = shortStoryList[0]
        
        shortStoryList.forEach { storyObject in
            if storyObject.storyName == chosenStoryName {
                chosenStoryObject = storyObject
            }
        }

        let storyString = chosenStoryObject.story
        
        let storyStringEnglish = chosenStoryObject.storyEnglish

        let wordLinks: [WordLink] = chosenStoryObject.wordLinks

        let questions: [QuestionsObj] = chosenStoryObject.questionsObjs
        
        let plugInQuestions: [FillInBlankQuestion] = chosenStoryObject.fillInBlankQuestions

        let shortStoryObj = shortStoryObject(storyString: storyString, storyStringEnglish: storyStringEnglish, wordLinksArray: wordLinks, questionList: questions, plugInQuestionlist: plugInQuestions)
        
        return shortStoryObj
        
    }
    
    
    
    
    
    
    
}
