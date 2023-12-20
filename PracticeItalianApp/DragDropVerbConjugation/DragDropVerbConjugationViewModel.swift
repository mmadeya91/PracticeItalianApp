//
//  DragDropVerbConjugationViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/16/23.
//

import SwiftUI

final class DragDropVerbConjugationViewModel: ObservableObject {
    
    @Published private(set) var currentTenseDragDropData: [dragDropQuestionObject] = [dragDropQuestionObject]()
    @Published var isMyList: Bool = false
    @Published var currentTense: Int = 0
    @Published var currentTenseString: String = ""
    
    private(set) var allNonUserMadeVerbs: [verbObject] = verbObject.allVerbObject
    private(set) var allUserMadeVerbs: [verbObject] = [verbObject]()
    
    func setNonMyListDragDropData(){
        var tempVCCO: [dragDropQuestionObject] = [dragDropQuestionObject]()
        let initialVerbCount = allNonUserMadeVerbs.count
        var i = 0
        
        while i < initialVerbCount {
            var dropSpaceLeft: [VerbConjCharacter] = [VerbConjCharacter]()
            var dropSpaceRight: [VerbConjCharacter] = [VerbConjCharacter]()
            var choiceList: [VerbConjCharacter] = [VerbConjCharacter]()
            
            let randomInt2: Int = Int.random(in: 0..<allNonUserMadeVerbs.count)
            
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
            
            let wrongChoice1: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5]}.randomElement()!)
            let wrongChoice2: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5] && $0 != wrongChoice1.value}.randomElement()!)
            let wrongChoice3: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5] && $0 != wrongChoice1.value && $0 != wrongChoice2.value}.randomElement()!)
            let wrongChoice4: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5] && $0 != wrongChoice1.value && $0 != wrongChoice2.value && $0 != wrongChoice3.value}.randomElement()!)
            
            choiceList = [wrongChoice1, wrongChoice2, wrongChoice3, wrongChoice4]
            
            
            //create dropSpaceLeft Verb Items
            for i in 0...2 {
                let verbConjCharacter = VerbConjCharacter(value: correctTenseList[i], pronoun: getPronoun(pronounIn: i))
                
                dropSpaceLeft.append(verbConjCharacter)
            }
            
            //create dropSpaceRight Verb Items
            for i in 3...5 {
                let verbConjCharacter = VerbConjCharacter(value: correctTenseList[i], pronoun:  getPronoun(pronounIn: i))
                
                dropSpaceRight.append(verbConjCharacter)
            }
            
            func getPronoun(pronounIn: Int)->String{
                switch pronounIn {
                case 0:
                    return "Io"
                case 1:
                    return "Tu"
                case 2:
                    return "Lui/Lei/Lei"
                case 3:
                    return "Noi"
                case 4:
                    return "Voi"
                case 5:
                    return "Loro"
                default:
                    return "Default"
                }
            }
            
            
            //append created dropSpace verb items to choice list to keep correct UUID
            for v in dropSpaceLeft {
                choiceList.append(v)
            }
            
            for v in dropSpaceRight {
                choiceList.append(v)
            }
            
            //create view model object
            let dragDropItem: dragDropQuestionObject = dragDropQuestionObject(currentVerb: verbToDisplay.verb, dropVerbListLeft: dropSpaceLeft, dropVerbListRight: dropSpaceRight, choices: choiceList)
            
            //append viewmodel object to viewmodel published lsit
            tempVCCO.append(dragDropItem)
            
    
            //remove verb used from available list so no dublicate questions
            allNonUserMadeVerbs.remove(at: randomInt2)
            
            
            i += 1
        }
        
        currentTenseDragDropData = tempVCCO
    }
    
    func setMyListDragDropData(){
        var tempVCCO: [dragDropQuestionObject] = [dragDropQuestionObject]()
        let initialVerbCount = allUserMadeVerbs.count
        var i = 0
        
        while i < initialVerbCount {
            var dropSpaceLeft: [VerbConjCharacter] = [VerbConjCharacter]()
            var dropSpaceRight: [VerbConjCharacter] = [VerbConjCharacter]()
            var choiceList: [VerbConjCharacter] = [VerbConjCharacter]()
            
            let randomInt2: Int = Int.random(in: 0..<allUserMadeVerbs.count)
            
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
            
            let wrongChoice1: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5]}.randomElement()!)
            let wrongChoice2: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5] && $0 != wrongChoice1.value}.randomElement()!)
            let wrongChoice3: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5] && $0 != wrongChoice1.value && $0 != wrongChoice2.value}.randomElement()!)
            let wrongChoice4: VerbConjCharacter = VerbConjCharacter(value: allConjList.filter(){$0 != correctTenseList[0] && $0 != correctTenseList[1] && $0 != correctTenseList[2] && $0 != correctTenseList[3] && $0 != correctTenseList[4] && $0 != correctTenseList[5] && $0 != wrongChoice1.value && $0 != wrongChoice2.value && $0 != wrongChoice3.value}.randomElement()!)
            
            choiceList = [wrongChoice1, wrongChoice2, wrongChoice3, wrongChoice4]
            
            
            //create dropSpaceLeft Verb Items
            for i in 0...2 {
                let verbConjCharacter = VerbConjCharacter(value: correctTenseList[i], pronoun: getPronoun(pronounIn: i))
                
                dropSpaceLeft.append(verbConjCharacter)
            }
            
            //create dropSpaceRight Verb Items
            for i in 3...5 {
                let verbConjCharacter = VerbConjCharacter(value: correctTenseList[i], pronoun:  getPronoun(pronounIn: i))
                
                dropSpaceRight.append(verbConjCharacter)
            }
            
            func getPronoun(pronounIn: Int)->String{
                switch pronounIn {
                case 0:
                    return "Io"
                case 1:
                    return "Tu"
                case 2:
                    return "Lui/Lei/Lei"
                case 3:
                    return "Noi"
                case 4:
                    return "Voi"
                case 5:
                    return "Loro"
                default:
                    return "Default"
                }
            }
            
            
            //append created dropSpace verb items to choice list to keep correct UUID
            for v in dropSpaceLeft {
                choiceList.append(v)
            }
            
            for v in dropSpaceRight {
                choiceList.append(v)
            }
            
            //create view model object
            let dragDropItem: dragDropQuestionObject = dragDropQuestionObject(currentVerb: verbToDisplay.verb, dropVerbListLeft: dropSpaceLeft, dropVerbListRight: dropSpaceRight, choices: choiceList)
            
            //append viewmodel object to viewmodel published lsit
            tempVCCO.append(dragDropItem)
            
    
            //remove verb used from available list so no dublicate questions
            allUserMadeVerbs.remove(at: randomInt2)
            
            
            i += 1
        }
        
        currentTenseDragDropData = tempVCCO
    }
    
    func setAllUserMadeList(myListIn: FetchedResults<UserVerbList>){
        var tempVerbArray: [verbObject] = [verbObject]()
        for verbIn in myListIn{
            tempVerbArray.append(verbObject(verb: Verb(verbName: verbIn.verbNameItalian!, verbEngl: verbIn.verbNameEnglish!), presenteConjList: verbIn.presente!, passatoProssimoConjList: verbIn.passatoProssimo!, futuroConjList: verbIn.futuro!, imperfettoConjList: verbIn.imperfetto!, presenteCondizionaleConjList: verbIn.condizionale!, imperativoConjList: verbIn.imperativo!))
        }
        
        allUserMadeVerbs = tempVerbArray
    }
    
}

struct dragDropQuestionObject: Identifiable {
    var id = UUID().uuidString
    var currentVerb: Verb
    var dropVerbListLeft: [VerbConjCharacter]
    var dropVerbListRight: [VerbConjCharacter]
    var choices: [VerbConjCharacter]
}

struct VerbConjCharacter: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
    var pronoun: String = "default"
}




