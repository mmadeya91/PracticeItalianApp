//
//  SpellConjVerbViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/23/23.
//

import Foundation
import SwiftUI
import CoreData

final class SpellConjVerbViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Published private(set) var currentTenseSpellConjVerbData: [spellConjVerbObject] = [spellConjVerbObject]()
    
    @Published var currentHintLetterArray: [hintLetterObj] = [hintLetterObj]()
    
    @Published var isMyList: Bool = false
    @Published var currentTense: Int = 0
    
    private(set) var SpellConjVerbData: [verbObject] = verbObject.allVerbObject
    private(set) var allUserMadeVerbs: [verbObject] = [verbObject]()

    func setSpellVerbData(tense: Int) {
        
        var SpellConjVerbViewData: [spellConjVerbObject] = [spellConjVerbObject]()
        
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        var i: Int = 0
        
        while i < 14 {
            
            let randomInt: Int = Int.random(in: 0..<6)
            let randomInt2: Int = Int.random(in: 0..<SpellConjVerbData.count)
            
            let pickPronoun: String = pronouns[randomInt]
            
            let verbToDisplay: verbObject = SpellConjVerbData[randomInt2]
            
            var correctTenseList: [String] = [String]()
            
            
            switch currentTense {
                
            case 0:
                correctTenseList = verbToDisplay.presenteConjList
            case 1:
                correctTenseList = verbToDisplay.passatoProssimoConjList
            case 2:
                correctTenseList = verbToDisplay.futuroConjList
            case 3:
     
                correctTenseList = verbToDisplay.imperfettoConjList
            case 4:
                correctTenseList = verbToDisplay.presenteCondizionaleConjList
            case 5:
                correctTenseList = verbToDisplay.imperativoConjList
                
            default:
                correctTenseList = verbToDisplay.presenteConjList
            }
            
            let correctAnswer: String = correctTenseList[randomInt]
            
            let correctAnswerIntoArray: [String] = correctAnswer.map { String($0) }
            
            
            let spellConjVerbObject = spellConjVerbObject(verbNameItalian: verbToDisplay.verb.verbName, verbNameEnglish: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, pronoun: pickPronoun, hintLetterArray: createArrayOfHintLetterObj(letterArray: correctAnswerIntoArray))
            
            SpellConjVerbViewData.append(spellConjVerbObject)
            
            i+=1
        }
        
        currentTenseSpellConjVerbData = SpellConjVerbViewData
        
    }
    
    func setMyListSpellVerbData() {
        
        var SpellConjVerbViewData: [spellConjVerbObject] = [spellConjVerbObject]()
        
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        var i: Int = 0
        
        while i < 14 {
            
            let randomInt: Int = Int.random(in: 0..<6)
            let randomInt2: Int = Int.random(in: 0..<allUserMadeVerbs.count)
            
            let pickPronoun: String = pronouns[randomInt]
            
            let verbToDisplay: verbObject = allUserMadeVerbs[randomInt2]
            
            var correctTenseList: [String] = [String]()
            
            switch currentTense {
                
            case 0:
                correctTenseList = verbToDisplay.presenteConjList
            case 1:
                correctTenseList = verbToDisplay.passatoProssimoConjList
            case 2:
                correctTenseList = verbToDisplay.futuroConjList
            case 3:
                correctTenseList = verbToDisplay.imperfettoConjList
            case 4:
                correctTenseList = verbToDisplay.presenteCondizionaleConjList
            case 5:
                correctTenseList = verbToDisplay.imperativoConjList
                
            default:
                correctTenseList = verbToDisplay.presenteConjList
            }
            
            let correctAnswer: String = correctTenseList[randomInt]
            
            let correctAnswerIntoArray: [String] = correctAnswer.map { String($0) }
            
            
            let spellConjVerbObject = spellConjVerbObject(verbNameItalian: verbToDisplay.verb.verbName, verbNameEnglish: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, pronoun: pickPronoun, hintLetterArray: createArrayOfHintLetterObj(letterArray: correctAnswerIntoArray))
            
            SpellConjVerbViewData.append(spellConjVerbObject)
            
            i+=1
        }
        
        currentTenseSpellConjVerbData = SpellConjVerbViewData
        
    }
    
    func showHint(){
        let count = currentHintLetterArray.count
        
        for i in 0...count-1 {
            currentHintLetterArray[i].showLetter = true
        }
    }
    
    func setHintLetter(letterArray: [hintLetterObj]) {
        
        currentHintLetterArray = letterArray
        
    }
    
    func createArrayOfHintLetterObj(letterArray: [String]) -> [hintLetterObj] {
        
        var hintLetterObjArray: [hintLetterObj] = [hintLetterObj]()
        
        for letter in letterArray {
            hintLetterObjArray.append(hintLetterObj(letter: letter))
        }
        
        return hintLetterObjArray
        
    }
    
    func createVerbObjects(myListIn: FetchedResults<UserVerbList>){
        var tempVerbObjArray: [verbObject] = [verbObject]()
        for verbObj in myListIn {
            tempVerbObjArray.append(verbObject(verb: Verb(verbName: verbObj.verbNameItalian!, verbEngl: verbObj.verbNameEnglish!), presenteConjList: verbObj.presente!, passatoProssimoConjList: verbObj.passatoProssimo!, futuroConjList: verbObj.futuro!, imperfettoConjList: verbObj.imperfetto!, presenteCondizionaleConjList: verbObj.condizionale!, imperativoConjList: verbObj.imperativo!))
        }
       allUserMadeVerbs = tempVerbObjArray
    }
}



struct spellConjVerbObject: Identifiable{
    
    let id = UUID()
    let verbNameItalian: String
    let verbNameEnglish: String
    let correctAnswer: String
    let pronoun: String
    let hintLetterArray: [hintLetterObj]
    
    
}


struct hintLetterObj: Hashable {
    let id = UUID()
    let letter: String
    var showLetter = false
}



    
   

