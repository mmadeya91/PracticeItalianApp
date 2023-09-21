//
//  shortStoryObject.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/8/23.
//

import Foundation

class shortStoryObject {
    
    var storyString: String
    var storyStringEnglish: String
    var wordLinksArray: [WordLink]
    var questionList: [QuestionsObj]
    var plugInQuestionlist: [FillInBlankQuestion]
    
    init(storyString: String, storyStringEnglish: String, wordLinksArray: [WordLink], questionList: [QuestionsObj], plugInQuestionlist: [FillInBlankQuestion]) {
        self.storyString = storyString
        self.storyStringEnglish = storyStringEnglish
        self.wordLinksArray = wordLinksArray
        self.questionList = questionList
        self.plugInQuestionlist = plugInQuestionlist
    }
    
    
    func collectWordExpl(ssO: shortStoryObject, chosenWord: String) -> WordLink {
        
        var wordLink: WordLink = ssO.wordLinksArray[0]
        
        ssO.wordLinksArray.forEach{ WordLink in
            if WordLink.wordNameIt == chosenWord {
                wordLink = WordLink
            }
        }
        
        return wordLink
    
    }
    
    
    
}
