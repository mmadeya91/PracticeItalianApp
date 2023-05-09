//
//  shortStoryObject.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/8/23.
//

import Foundation

class shortStoryObject {
    
    var storyString: String
    var wordLinksArray: [WordLink]
    var questionList: [QuestionsObj]
    
    init(storyString: String, wordLinksArray: [WordLink], questionList: [QuestionsObj]) {
        self.storyString = storyString
        self.wordLinksArray = wordLinksArray
        self.questionList = questionList
    }
    
    
    
    
    
}
