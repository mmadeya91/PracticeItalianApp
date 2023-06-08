//
//  spellVerbObject.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import Foundation

class spellVerbObject {
    
    var pronoun: String
    var verbNameIt: String
    var verbNameEng: String
    
    var correctAnswer: String
    
    var tenseName: String
    
    init(pronoun: String, verbNameIt: String, verbNameEng: String, correctAnswer: String, tenseName: String) {
        self.pronoun = pronoun
        self.verbNameIt = verbNameIt
        self.verbNameEng = verbNameEng
        self.correctAnswer = correctAnswer
        self.tenseName = tenseName
    }
}
