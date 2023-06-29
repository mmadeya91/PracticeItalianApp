//
//  multipleChoiceObject.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 4/27/23.
//

import Foundation

class multipleChoiceData{
    
    var tense: Int
    
    init(tense: Int) {
        self.tense = tense
    }
    
    func createArrayOfMCD(numberOfVerbs: Int, tense: Int) -> [multipleChoiceObject] {
        var counter = 1
        var arrayOfMCD: [multipleChoiceObject] = [multipleChoiceObject]()
        while counter <= numberOfVerbs{
            let mcOtoAdd = collectMultipleChoiceData(tense: tense)
            if !arrayOfMCD.contains(where: { mcO in return mcO.correctAnswer == mcOtoAdd.correctAnswer}) {
                arrayOfMCD.append(mcOtoAdd)
                counter = counter + 1
            }
        }
        
        return arrayOfMCD
    }
    
    func collectMultipleChoiceData(tense: Int) -> multipleChoiceObject {
        
        let verbList: [verbObject] = verbObject.allVerbObject
        
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        let randomInt: Int = Int.random(in: 0..<6)
        let randomInt2: Int = Int.random(in: 0..<verbList.count)
        
        let pickPronoun: String = pronouns[randomInt]
        
        let verbToDisplay: verbObject = verbList[randomInt2]
     
        let allConjList: [String] = verbToDisplay.imperativoConjList + verbToDisplay.futuroConjList + verbToDisplay.imperfettoConjList  + verbToDisplay.passatoProssimoConjList + verbToDisplay.presenteConjList + verbToDisplay.presenteCondizionaleConjList
        
        var verbArrays = [[String]]()
            verbArrays.append(verbToDisplay.presenteConjList)
            verbArrays.append(verbToDisplay.passatoProssimoConjList)
            verbArrays.append(verbToDisplay.futuroConjList)
            verbArrays.append(verbToDisplay.imperfettoConjList)
            verbArrays.append(verbToDisplay.presenteCondizionaleConjList)
            verbArrays.append(verbToDisplay.imperativoConjList)
        
        let correctTenseList: [String] = verbArrays[tense]
        
        let correctAnswer: String = correctTenseList[randomInt]
        
        let choice2: String = allConjList.randomElement()!
        let choice3: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2}.randomElement()!
        let choice4: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3}.randomElement()!
        let choice5: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3 && $0 != choice4}.randomElement()!
        let choice6: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3 && $0 != choice4 && $0 != choice5}.randomElement()!
        
        let choiceList: [String] = [correctAnswer, choice2, choice3, choice4, choice5, choice6]
        
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
        
        let multipleChoiceObject = multipleChoiceObject(pronoun: pickPronoun, verbNameIt: verbToDisplay.verb.verbName, verbNameEng: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, choiceList: choiceList, tenseName: tenseNameIn)
        
        return multipleChoiceObject
        
        
    }
    
    
}
