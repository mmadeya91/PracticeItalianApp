//
//  spellVerbData.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import Foundation

class spellVerbData{
    
    var tense: Int
    
    init(tense: Int) {
        self.tense = tense
    }
    
    func collectSpellVerbData(tense: Int) -> spellVerbObject {
        
        let verbList: [verbObject] = verbObject.allVerbObject
        
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        let randomInt: Int = Int.random(in: 0..<6)
        let randomInt2: Int = Int.random(in: 0..<verbList.count)
        
        let pickPronoun: String = pronouns[randomInt]
        
        let verbToDisplay: verbObject = verbList[randomInt2]
        
        var verbArrays = [[String]]()
            verbArrays.append(verbToDisplay.presenteConjList)
            verbArrays.append(verbToDisplay.passatoProssimoConjList)
            verbArrays.append(verbToDisplay.futuroConjList)
            verbArrays.append(verbToDisplay.imperfettoConjList)
            verbArrays.append(verbToDisplay.presenteCondizionaleConjList)
            verbArrays.append(verbToDisplay.imperativoConjList)
        
        let correctTenseList: [String] = verbArrays[tense]
        
        let correctAnswer: String = correctTenseList[randomInt]
        
        var tenseNameIn: String = ""
        
        switch tense {
            
            case 0:
                tenseNameIn = "Presente"
            case 1:
                tenseNameIn = "Passato Prossimo"
            case 2:
                tenseNameIn = "Futuro"
            case 3:
                tenseNameIn = "Imperfetto"
            case 4:
                tenseNameIn = "Presente Condizionale"
            case 5:
                tenseNameIn = "Imperativo"
    
            default:
                tenseNameIn = ""
        }
        
        let spellVerbObject = spellVerbObject(pronoun: pickPronoun, verbNameIt: verbToDisplay.verb.verbName, verbNameEng: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, tenseName: tenseNameIn)
        
        return spellVerbObject
        
        
    }
    
    
}
