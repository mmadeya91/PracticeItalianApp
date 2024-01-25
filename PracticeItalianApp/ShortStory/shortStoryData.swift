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
        
        switch chosenStoryName {
            case "La Mia Introduzione":
                chosenStoryObject = shortStoryList[0]
            case "Il Mio Migliore Amico":
                chosenStoryObject = shortStoryList[1]
            case "La Mia Famiglia":
                chosenStoryObject = shortStoryList[1]
            case "Le Mie Vacanze in Sicilia":
                chosenStoryObject = shortStoryList[2]
            case "La Mia Routine":
                chosenStoryObject = shortStoryList[3]
            case "Ragù Di Maiale Brasato":
                chosenStoryObject = shortStoryList[4]
            case "Il Mio Fine Settimana":
                chosenStoryObject = shortStoryList[5]
            default:
                chosenStoryObject = shortStoryList[0]
            }
        
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
