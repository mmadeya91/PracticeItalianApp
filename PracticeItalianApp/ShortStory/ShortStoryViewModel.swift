//
//  ShortStoryViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/30/23.
//

import Foundation

final class ShortStoryViewModel: ObservableObject {
    @Published private(set) var currentTenseMCConjVerbData: [multipleChoiceVerbObject] = [multipleChoiceVerbObject]()
    @Published var isMyList: Bool = false
    @Published var currentTense: Int = 0
    
    private(set) var allNonUserMadeVerbs: [verbObject] = verbObject.allVerbObject
    private(set) var allUserMadeVerbs: [verbObject] = [verbObject]()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
