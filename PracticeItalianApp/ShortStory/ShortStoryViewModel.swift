//
//  ShortStoryViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/30/23.
//

import Foundation

final class ShortStoryViewModel: ObservableObject {
    @Published private(set) var currentPlugInStoryData: [shortStoryPlugInDataObj] = [shortStoryPlugInDataObj]()
    @Published private(set) var currentPlugInQuestions: [FillInBlankQuestion] = [FillInBlankQuestion]()
    @Published private(set) var currentPlugInQuestionsChoices: [[pluginShortStoryCharacter]] = [[pluginShortStoryCharacter]]()
    @Published private(set) var currentHints: [String] = [String]()
    @Published private(set) var currentStory: String
    @Published private(set) var currentStoryData: storyObject
    
    init(currentStoryIn: String){
        switch currentStoryIn {
        case "La Mia Introduzione":
            currentStoryData = storyObject.introduzione
            currentStory = "La Mia Introduzione"
        case "Il Mio Migliore Amico":
            currentStoryData = storyObject.amico
            currentStory = "Il Mio Migliore Amico"
        case "La Mia Famiglia":
            currentStoryData = storyObject.famiglia
            currentStory = "La Mia Famiglia"
        case "Le Mie Vacanze in Sicilia":
            currentStoryData = storyObject.vacanza
            currentStory = "Le Mie Vacanze in Sicilia"
        case "La Mia Routine":
            currentStoryData = storyObject.routine
            currentStory = "La Mia Routine"
        case "Ragù Di Maiale Brasato":
            currentStoryData = storyObject.ragu
            currentStory = "Ragù Di Maiale Brasato"
        case "Il Mio Fine Settimana":
            currentStoryData = storyObject.weekend
            currentStory = "Il Mio Fine Settimana"
        default:
            currentStoryData = storyObject.introduzione
            currentStory = "La Mia Introduzione"
        }
    }
    
//
//    static let introduzione: storyObject = allStoryObjects[0]
//    static let amico: storyObject = allStoryObjects[1]
//    static let famiglia: storyObject = allStoryObjects[2]
//    static let vacanza: storyObject = allStoryObjects[3]
//    static let routine: storyObject = allStoryObjects[4]
//    static let ragu: storyObject = allStoryObjects[5]
//    static let weekend: storyObject = allStoryObjects[6]

    
    func setShortStoryData() {
        
        var tempArray: [shortStoryPlugInDataObj] = [shortStoryPlugInDataObj]()
        var tempChoicesArray: [[pluginShortStoryCharacter]] = [[pluginShortStoryCharacter]]()
        var tempHintArray: [String] = [String]()
        
        let storyString = currentStoryData.story

        let wordLinks: [WordLink] = currentStoryData.wordLinks

        let questions: [QuestionsObj] = currentStoryData.questionsObjs
        
        let plugInQuestions: [FillInBlankQuestion] = currentStoryData.fillInBlankQuestions
        
        currentPlugInQuestions = plugInQuestions
        
        for question in plugInQuestions {
            var tempChoices: [pluginShortStoryCharacter] = [pluginShortStoryCharacter]()
            
            tempHintArray.append(question.englishLine1)
            
            for choice in question.plugInChoices.shuffled(){
                var newPlugInCharacter = pluginShortStoryCharacter(value: choice.choice, isCorrect: choice.isCorrect)
                tempChoices.append(newPlugInCharacter)
                
            }
            
            tempChoicesArray.append(tempChoices)
        }
        
        var newObj = shortStoryPlugInDataObj(storyString: storyString, wordLinksArray: wordLinks, questionList: questions, plugInQuestionlist: plugInQuestions)
        
        tempArray.append(newObj)
        
        currentPlugInStoryData = tempArray
        currentPlugInQuestionsChoices = tempChoicesArray
        currentHints = tempHintArray
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

struct pluginShortStoryCharacter: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var isCorrect: Bool
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
    
}

struct shortStoryPlugInDataObj: Identifiable{
    var id = UUID().uuidString
    var storyString: String
    var wordLinksArray: [WordLink]
    var questionList: [QuestionsObj]
    var plugInQuestionlist: [FillInBlankQuestion]
}
