//
//  multipleChoiceObject.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 4/27/23.
//

import Foundation

class multipleChoiceObject {
    
    var pronoun: String
    var verbNameIt: String
    var verbNameEng: String
    
    var correctAnswer: String
    
    var choiceList = [String]()
    
    var tenseName: String
    
    init(pronoun: String, verbNameIt: String, verbNameEng: String, correctAnswer: String, choiceList: [String] = [String](), tenseName: String) {
        self.pronoun = pronoun
        self.verbNameIt = verbNameIt
        self.verbNameEng = verbNameEng
        self.correctAnswer = correctAnswer
        self.choiceList = choiceList
        self.tenseName = tenseName
    }
    
}
