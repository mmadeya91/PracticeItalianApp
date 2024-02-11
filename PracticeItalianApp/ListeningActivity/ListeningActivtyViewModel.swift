//
//  ListeningActivtyViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/8/23.
//

import Foundation

final class ListeningActivityViewModel: ObservableObject {
    private(set) var audioAct: audioActivty
    
    init(audioAct: audioActivty) {
        self.audioAct = audioAct
    }
    func setAudioData(chosenAudio: String){
        switch chosenAudio {
        case "Pasta alla Carbonara":
            audioAct = audioActivty.pastaCarbonara
          
        case "Cosa Desidera?":
            audioAct = audioActivty.cosaDesidera
      
        case "Indicazioni per gli Uffizi":
            audioAct = audioActivty.uffizi
  
        case "Stili di Bellagio":
            audioAct = audioActivty.bellagio
   
        case "Il Rinascimento":
            audioAct = audioActivty.rinascimento
  
        default:
            audioAct = audioActivty.pastaCarbonara
           
        }
    }
    
}

struct audioActivty {
    let id = UUID()
    let title: String
    let description: String
    let duration: TimeInterval
    let track: String
    let image: String
    let isConversation: Bool
    let numberofDialogueQuestions: Int
    let speaker1Image: String
    let speaker2Image: String
    let comprehensionQuestions: [ComprehensionQuestion]
    let comprehensionQuestionChoices: [[String]]
    let fillInDialogueQuestionElement: [FillInDialogueQuestion]
    let putInOrderSentenceArray: [PutInOrderDialogueBox]
    let audioCutFileNames: [String]

    static let pastaCarbonara = audioActivty(title: "Pasta Carbonara", description: "The Italian chef is reciting instructions on how how make one of Italy's most famous pasta dishes! Do you're best to follow along and maybe even give it a try yourself at home!", duration: 70, track: "pastaCarbonara", image: "pot", isConversation: ListeningActivityElement.pastaCarbonara.isConversation, numberofDialogueQuestions: ListeningActivityElement.pastaCarbonara.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.pastaCarbonara.speaker1Image, speaker2Image: ListeningActivityElement.pastaCarbonara.speaker2Image,  comprehensionQuestions: ListeningActivityElement.pastaCarbonara.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.pastaCarbonara.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.pastaCarbonara.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.pastaCarbonara.audioCutArrays)
    
    static let cosaDesidera = audioActivty(title: "Cosa Desidera", description: "A stranger is trying to find a table at a local restaurant. Do your best to follow the interaction between herself and the waiter. This is a good introduction to ordering food in an Italian restaurant and find out whats on the menu!", duration: 52, track: "cosaDesidera", image: "dinner", isConversation: ListeningActivityElement.cosaDesidera.isConversation, numberofDialogueQuestions: ListeningActivityElement.cosaDesidera.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.cosaDesidera.speaker1Image, speaker2Image: ListeningActivityElement.cosaDesidera.speaker2Image,  comprehensionQuestions: ListeningActivityElement.cosaDesidera.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.cosaDesidera.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.cosaDesidera.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.cosaDesidera.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.cosaDesidera.audioCutArrays)
    
    static let uffizi = audioActivty(title: "Indicazioni per gli Uffizi", description: "Mateo is lost on his way to the Galleria degli Uffizi. Luckily, he finds a stranger who is willing to help him and give him directions. Follow along and try to see what path Mateo must take in order to reach his destination", duration: 59, track: "uffizi", image: "directions", isConversation: ListeningActivityElement.uffizi.isConversation, numberofDialogueQuestions: ListeningActivityElement.uffizi.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.uffizi.speaker1Image, speaker2Image: ListeningActivityElement.uffizi.speaker2Image, comprehensionQuestions: ListeningActivityElement.uffizi.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.uffizi.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.uffizi.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.uffizi.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.uffizi.audioCutArrays)
    
    static let bellagio = audioActivty(title: "Stili di Bellagio", description: "Theres a new clothing store opening up in Bellagio! A beautiful town on Lake Como in northern Italy. Listen along and see what types of clothes the store is selling and other things that may be useful to know about the new shop.", duration: 59, track: "stileBellagio", image: "clothesStore", isConversation: ListeningActivityElement.bellagio.isConversation, numberofDialogueQuestions: ListeningActivityElement.bellagio.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.bellagio.speaker1Image, speaker2Image: ListeningActivityElement.bellagio.speaker2Image, comprehensionQuestions: ListeningActivityElement.bellagio.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.bellagio.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.bellagio.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.bellagio.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.bellagio.audioCutArrays)
    
    static let rinascimento = audioActivty(title: "Il Rinascimento", description: "The Renaissance, one of the most important movements in the world and Italian history. Listen along to this brief description of how this famous movement came to be and some of the incredible accomplishments that resulted from it.", duration: 82, track: "rinascimento", image: "renaissance", isConversation: ListeningActivityElement.rinascimento.isConversation, numberofDialogueQuestions: ListeningActivityElement.rinascimento.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.rinascimento.speaker1Image, speaker2Image: ListeningActivityElement.rinascimento.speaker2Image, comprehensionQuestions: ListeningActivityElement.rinascimento.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.rinascimento.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.rinascimento.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.rinascimento.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.rinascimento.audioCutArrays)

    
}

func setComprehensionQuestions(arrayIn: [ComprehensionQuestion]) -> [[String]]{
    var tempStringArray = [[String]]()
    for question in arrayIn{
        tempStringArray.append(question.choices.shuffled())
    }
    
    return tempStringArray
}

