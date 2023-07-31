//
//  VerbConjMultipleChoiceViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/7/23.
//

import Foundation
import SwiftUI

final class VerbConjMultipleChoiceViewModel: ObservableObject {
    
    @Published private(set) var currentTenseMCConjVerbData: [multipleChoiceVerbObject] = [multipleChoiceVerbObject]()
    @Published var isMyList: Bool = false
    @Published var currentTense: Int = 0
    
    private(set) var allNonUserMadeVerbs: [verbObject] = verbObject.allVerbObject
    private(set) var allUserMadeVerbs: [verbObject] = [verbObject]()
    

    func setMultipleChoiceData() {
        
        var tempMCVO: [multipleChoiceVerbObject] = [multipleChoiceVerbObject]()
        var i = 0
    
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        while i < 14 {
            
            let randomInt: Int = Int.random(in: 0..<6)
            let randomInt2: Int = Int.random(in: 0..<allNonUserMadeVerbs.count)
            
            let pickPronoun: String = pronouns[randomInt]
            let verbToDisplay: verbObject = allNonUserMadeVerbs[randomInt2]
            
            let allConjList: [String] = verbToDisplay.imperativoConjList + verbToDisplay.futuroConjList + verbToDisplay.imperfettoConjList  + verbToDisplay.passatoProssimoConjList + verbToDisplay.presenteConjList + verbToDisplay.presenteCondizionaleConjList
            
            var verbArrays = [[String]]()
            verbArrays.append(verbToDisplay.presenteConjList)
            verbArrays.append(verbToDisplay.passatoProssimoConjList)
            verbArrays.append(verbToDisplay.futuroConjList)
            verbArrays.append(verbToDisplay.imperfettoConjList)
            verbArrays.append(verbToDisplay.presenteCondizionaleConjList)
            verbArrays.append(verbToDisplay.imperativoConjList)
            
            let correctTenseList: [String] = verbArrays[currentTense]
            
            let correctAnswer: String = correctTenseList[randomInt]
            
            let choice2: String = allConjList.randomElement()!
            let choice3: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2}.randomElement()!
            let choice4: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3}.randomElement()!
            let choice5: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3 && $0 != choice4}.randomElement()!
            let choice6: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3 && $0 != choice4 && $0 != choice5}.randomElement()!
            
            let choiceList: [String] = [correctAnswer, choice2, choice3, choice4, choice5, choice6]
            
            var tenseNameIn: String = ""
            
            switch currentTense {
                
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
            
            let multipleChoiceObject = multipleChoiceVerbObject(pronoun: pickPronoun, verbNameIt: verbToDisplay.verb.verbName, verbNameEng: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, choiceList: choiceList, tenseName: tenseNameIn, pres: verbArrays[0], pass: verbArrays[1], fut: verbArrays[2], imp: verbArrays[3], impera: verbArrays[4], cond: verbArrays[5])
            
            tempMCVO.append(multipleChoiceObject)
            
            i += 1
        }
        
        currentTenseMCConjVerbData = tempMCVO
        
    }
    
    func setMyListMultipleChoiceData() {
        
        var tempMCVO: [multipleChoiceVerbObject] = [multipleChoiceVerbObject]()
        var i = 0
    
        let pronouns: [String] = ["Io", "Tu", "Lui, Lei, Lei", "Noi", "Voi", "Loro"]
        
        while i < 14 {
            
            let randomInt: Int = Int.random(in: 0..<6)
            let randomInt2: Int = Int.random(in: 0..<allUserMadeVerbs.count)
            
            let pickPronoun: String = pronouns[randomInt]
            
            let verbToDisplay: verbObject = allUserMadeVerbs[randomInt2]
            
            let allConjList: [String] = verbToDisplay.imperativoConjList + verbToDisplay.futuroConjList + verbToDisplay.imperfettoConjList  + verbToDisplay.passatoProssimoConjList + verbToDisplay.presenteConjList + verbToDisplay.presenteCondizionaleConjList
            
            var verbArrays = [[String]]()
            verbArrays.append(verbToDisplay.presenteConjList)
            verbArrays.append(verbToDisplay.passatoProssimoConjList)
            verbArrays.append(verbToDisplay.futuroConjList)
            verbArrays.append(verbToDisplay.imperfettoConjList)
            verbArrays.append(verbToDisplay.presenteCondizionaleConjList)
            verbArrays.append(verbToDisplay.imperativoConjList)
            
            let correctTenseList: [String] = verbArrays[currentTense]
            
            let correctAnswer: String = correctTenseList[randomInt]
            
            let choice2: String = allConjList.randomElement()!
            let choice3: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2}.randomElement()!
            let choice4: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3}.randomElement()!
            let choice5: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3 && $0 != choice4}.randomElement()!
            let choice6: String = allConjList.filter(){$0 != correctAnswer && $0 != choice2 && $0 != choice3 && $0 != choice4 && $0 != choice5}.randomElement()!
            
            let choiceList: [String] = [correctAnswer, choice2, choice3, choice4, choice5, choice6].shuffled()
            
            var tenseNameIn: String = ""
            
            switch currentTense {
                
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
            
            let multipleChoiceObject = multipleChoiceVerbObject(pronoun: pickPronoun, verbNameIt: verbToDisplay.verb.verbName, verbNameEng: verbToDisplay.verb.verbEngl, correctAnswer: correctAnswer, choiceList: choiceList, tenseName: tenseNameIn, pres: verbArrays[0], pass: verbArrays[1], fut: verbArrays[2], imp: verbArrays[3], impera: verbArrays[4], cond: verbArrays[5])
            
            tempMCVO.append(multipleChoiceObject)
            
            i += 1
        }
        
        currentTenseMCConjVerbData = tempMCVO
        
    }
    
    func createMultipleChoiceVerbObjects(myListIn: FetchedResults<UserVerbList>){
        var tempVerbObjArray: [verbObject] = [verbObject]()
        for verbObj in myListIn {
            tempVerbObjArray.append(verbObject(verb: Verb(verbName: verbObj.verbNameItalian!, verbEngl: verbObj.verbNameEnglish!), presenteConjList: verbObj.presente!, passatoProssimoConjList: verbObj.passatoProssimo!, futuroConjList: verbObj.futuro!, imperfettoConjList: verbObj.imperfetto!, presenteCondizionaleConjList: verbObj.condizionale!, imperativoConjList: verbObj.imperativo!))
        }
       allUserMadeVerbs = tempVerbObjArray  
    }
    
}



struct multipleChoiceVerbObject: Identifiable{
    
    let id = UUID().uuidString
    let pronoun: String
    let verbNameIt: String
    let verbNameEng: String
    let correctAnswer: String
    let choiceList: [String]
    let tenseName: String
    let pres: [String]
    let pass: [String]
    let fut: [String]
    let imp: [String]
    let impera: [String]
    let cond: [String]
    
    
}


