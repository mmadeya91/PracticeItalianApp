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
    
    init(currentStoryIn: Int){
        switch currentStoryIn {
        case 0:
            currentStory = "Cristofo Columbo"
        default:
            currentStory = "Cristofo Columbo"
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

    
    func setShortStoryData(storyName: String) {
        
        var tempArray: [shortStoryPlugInDataObj] = [shortStoryPlugInDataObj]()
        var tempChoicesArray: [[pluginShortStoryCharacter]] = [[pluginShortStoryCharacter]]()
        var tempHintArray: [String] = [String]()
        
        let shortStoryList: [storyObject] = storyObject.allStoryObjects
        
        var chosenStoryObject: storyObject = shortStoryList[0]
        
        switch storyName {
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
        
        let storyString = chosenStoryObject.story

        let wordLinks: [WordLink] = chosenStoryObject.wordLinks

        let questions: [QuestionsObj] = chosenStoryObject.questionsObjs
        
        let plugInQuestions: [FillInBlankQuestion] = chosenStoryObject.fillInBlankQuestions
        
        currentPlugInQuestions = plugInQuestions
        
        for question in plugInQuestions {
            var tempChoices: [pluginShortStoryCharacter] = [pluginShortStoryCharacter]()
            
            tempHintArray.append(question.englishLine1)
            
            for choice in question.plugInChoices{
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
