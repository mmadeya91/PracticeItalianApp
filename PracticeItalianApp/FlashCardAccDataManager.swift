//
//  FlashCardAccDataManager.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/28/23.
//

import Foundation
import SwiftUI
import CoreData

final class FlashCardAccDataManager {
    
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    var cardName: String
    
    static let instance = FlashCardAccDataManager(cardName: "")
    
    init(cardName: String) {
        self.cardName = cardName
    }
    
    func isEmptyFlashCardAccData() -> Bool {
        
        let fR = FlashCardAccuracy.fetchRequest()
        fR.predicate = NSPredicate(format: "cardName == %@", self.cardName)
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
    
    func getAccData() -> FlashCardAccuracy{
        
        let fR = FlashCardAccuracy.fetchRequest()
        fR.predicate = NSPredicate(format: "cardName == %@", self.cardName)
        
        var results = [FlashCardAccuracy]()
        
        do {
            results = try viewContext.fetch(fR)
            return results[0]
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
        return results[0]

    }
    
    func addNewCardAccEntityCorrect(setName: String){
        let newFlashCardAccData = FlashCardAccuracy(context: viewContext)
        newFlashCardAccData.cardName = self.cardName
        newFlashCardAccData.cardAttempts = 1
        newFlashCardAccData.correct = 1
        newFlashCardAccData.incorrect = 0
        
        self.saveFlashCardAccData()
    }
    
    func addNewCardAccEntityIncorrect(setName: String){
        let newFlashCardAccData = FlashCardAccuracy(context: viewContext)
        newFlashCardAccData.cardName = self.cardName
        newFlashCardAccData.cardAttempts = 1
        newFlashCardAccData.correct = 0
        newFlashCardAccData.incorrect = 1
        
        self.saveFlashCardAccData()
        
    }

    
    func updateCorrectInput(card: FlashCardAccuracy, setName: String) {
            
            card.correct += 1
            card.cardAttempts += 1

        self.saveFlashCardAccData()
    }
    
    func updateIncorrectInput(card: FlashCardAccuracy, setName: String) {

            card.incorrect += 1
            card.cardAttempts += 1

        self.saveFlashCardAccData()
        
    }
    
    func deleteFlashAccData(cardAccData: FlashCardAccuracy, setName: String) {
        viewContext.delete(cardAccData)
        
        self.saveFlashCardAccData()
    }
    
    
    func getNumOfStars(card: FlashCardAccuracy) -> Int {
        
        let accuracy = ((Double(card.correct) / Double(card.cardAttempts)) * 100)
        
        if accuracy > 80.0 {
            return 3
        }
        if accuracy < 80.0 && accuracy > 60.0 {
            return 2
        }
        if accuracy < 50.0 && accuracy > 0.0 {
            return 1
        }else {
            return 0
        }
    
    }
    
    func saveFlashCardAccData() {
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
}
