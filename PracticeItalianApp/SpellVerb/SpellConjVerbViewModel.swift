//
//  SpellConjVerbViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/23/23.
//

import Foundation

final class SpellConjVerbViewModel: ObservableObject {
    
    @Published private(set) var currentTenseSpellConjVerbData: [spellConjVerbObject] = [spellConjVerbObject]()
    
    @Published var currentHintLetterArray: [hintLetterObj] = [hintLetterObj]()
    
    private(set) var SpellConjVerbData: [verbObject] = verbObject.allVerbObject
    
    func setSpellVerbData(tense: Int) {
        
        var SpellConjVerbViewData: [spellConjVerbObject] = [spellConjVerbObject]()
        
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        var i: Int = 0
        
        while i < 15 {
            
            let randomInt: Int = Int.random(in: 0..<6)
            let randomInt2: Int = Int.random(in: 0..<SpellConjVerbData.count)
            
            let pickPronoun: String = pronouns[randomInt]
            
            let verbToDisplay: verbObject = SpellConjVerbData[randomInt2]
            
            var correctTenseList: [String] = [String]()
            
            var tenseNameIn: String = ""
            
            switch tense {
                
            case 0:
                tenseNameIn = "Presente"
                correctTenseList = verbToDisplay.presenteConjList
            case 1:
                tenseNameIn = "Passato Prossimo"
                correctTenseList = verbToDisplay.passatoProssimoConjList
            case 2:
                tenseNameIn = "Futuro"
                correctTenseList = verbToDisplay.futuroConjList
            case 3:
                tenseNameIn = "Imperfetto"
                correctTenseList = verbToDisplay.imperfettoConjList
            case 4:
                tenseNameIn = "Presente Condizionale"
                correctTenseList = verbToDisplay.presenteCondizionaleConjList
            case 5:
                tenseNameIn = "Imperativo"
                correctTenseList = verbToDisplay.imperativoConjList
                
            default:
                tenseNameIn = ""
            }
            
            let correctAnswer: String = correctTenseList[randomInt]
            
            var correctAnswerIntoArray: [String] = correctAnswer.map { String($0) }
            
            
            let spellConjVerbObject = spellConjVerbObject(verbNameItalian: verbToDisplay.verb.verbName, verbNameEnglish: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, pronoun: pickPronoun, hintLetterArray: createArrayOfHintLetterObj(letterArray: correctAnswerIntoArray))
            
            SpellConjVerbViewData.append(spellConjVerbObject)
            
            i+=1
        }
        
        currentTenseSpellConjVerbData = SpellConjVerbViewData
        
    }
    
    func showHint(){
        var count = currentHintLetterArray.count
        
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



    
   

