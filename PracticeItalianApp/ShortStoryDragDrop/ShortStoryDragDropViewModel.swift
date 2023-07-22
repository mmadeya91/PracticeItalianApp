//
//  ShortStoryDragDropViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/18/23.
//

import SwiftUI

final class ShortStoryDragDropViewModel: ObservableObject{
    @Published private(set) var currentDragDropQuestions: [dragDropShortStoryObject] = [dragDropShortStoryObject]()
    @Published private(set) var currentStoryData: storyObject
    
    init(chosenStory: Int){
        switch chosenStory {
        case 0:
            currentStoryData = storyObject.columbo
        default:
            currentStoryData = storyObject.columbo
        }
    }
    
    func setData(){
        var tempQuestionArray: [dragDropShortStoryObject] = [dragDropShortStoryObject]()
        var questionChoices: [dragDropShortStoryCharacter] = [dragDropShortStoryCharacter]()
        
        for question in currentStoryData.dragAndDropQuestions {
            for choice in question.choices {
                questionChoices.append(dragDropShortStoryCharacter(value: choice))
            }
            
            tempQuestionArray.append(dragDropShortStoryObject(fullSentence: question.englishSentence, dragDropQuestionChoices: questionChoices))
            
        }
        
        currentDragDropQuestions = tempQuestionArray
    }
}

struct dragDropShortStoryObject: Identifiable {
    var id = UUID().uuidString
    var fullSentence: String
    var dragDropQuestionChoices: [dragDropShortStoryCharacter]
}

struct dragDropShortStoryCharacter: Identifiable, Hashable, Equatable {
        var id = UUID().uuidString
        var value: String
        var padding: CGFloat = 10
        var textSize: CGFloat = .zero
        var fontSize: CGFloat = 19
        var isShowing: Bool = false
        
}


