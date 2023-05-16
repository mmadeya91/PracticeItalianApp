//
//  JSONManager.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 4/26/23.
//

import Foundation

struct verbObject: Codable {
    var verb: Verb
    var presenteConjList, passatoProssimoConjList, futuroConjList, imperfettoConjList: [String]
    var presenteCondizionaleConjList, imperativoConjList: [String]
    
    static let allVerbObject: [verbObject] = Bundle.main.decode(file: "ItalianAppVerbData.json")
    
    
}
    

struct Verb: Codable {
    var verbName, verbEngl: String
}


struct storyObject: Codable {
    var storyName, story: String
    var wordLinks: [WordLink]
    var questionsObjs: [QuestionsObj]
    
    static let allStoryObjects: [storyObject] = Bundle.main.decode(file: "shortStoryAppData.json")
}


struct QuestionsObj: Codable {
    var question: String
    var choices: [String]
    var answer: String
    var mC: Bool?
}


struct WordLink: Codable {
    var wordNameIt, infinitive, wordNameEng, explanation: String
}


struct flashCardObject: Codable {
    var flashSetName: String
    var words: [Word]
    
    static let allFlashCardObjects: [flashCardObject] = Bundle.main.decode(file: "flashCardData.json")
    
    static let Food: flashCardObject = flashCardObject.allFlashCardObjects[0]
    static let Animals: flashCardObject = flashCardObject.allFlashCardObjects[1]
    static let Clothing: flashCardObject = flashCardObject.allFlashCardObjects[2]
    static let Family: flashCardObject = flashCardObject.allFlashCardObjects[3]
    static let CommonNouns: flashCardObject = flashCardObject.allFlashCardObjects[4]
    static let CommonAdjectives: flashCardObject = flashCardObject.allFlashCardObjects[5]
    static let CommonAdverbs: flashCardObject = flashCardObject.allFlashCardObjects[6]
    static let CommonVerbs: flashCardObject = flashCardObject.allFlashCardObjects[7]
    static let CommonPhrases: flashCardObject = flashCardObject.allFlashCardObjects[8]
    
    
}


struct Word: Codable {
    var wordItal: String
    var gender: Gender
    var wordEng: String
}

enum Gender: String, Codable {
    case empty = ""
    case fem = "fem."
    case genderMascFem = "masc.fem."
    case masc = "masc."
    case mascAndFem = "masc. and fem."
    case mascFem = "masc./fem."
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project!")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project!")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Culd not decode \(file) in the project!")
        }
        
        return loadedData
    }
}
