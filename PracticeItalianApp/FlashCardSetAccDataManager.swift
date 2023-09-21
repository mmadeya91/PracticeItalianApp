//
//  FlashCardSetAccDataManager.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 8/26/23.
//

import Foundation
import SwiftUI
import CoreData

final class FlashCardSetAccDataManager {
    
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    static let instance = FlashCardSetAccDataManager()
    
    
    func isEmptyFlashCardSetAccData(setName: String) -> Bool {
        
        let fR = FlashCardSetAccuracy.fetchRequest()
        fR.predicate = NSPredicate(format: "setName == %@", setName)
        
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
    
    func checkSetData(){
        let tempString: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own"]
        
        for setNameString in tempString {
            if isEmptyFlashCardSetAccData(setName: setNameString){
                addNewFlashCardSetData(setName: setNameString)
            }
        }
    }
    
    func getAccData(setName: String) -> FlashCardSetAccuracy{
        
        let fR = FlashCardSetAccuracy.fetchRequest()
        fR.predicate = NSPredicate(format: "setName == %@", setName)
        
        var results = [FlashCardSetAccuracy]()
        
        do {
            results = try viewContext.fetch(fR)
            return results[0]
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
        return results[0]

    }
    
    func calculateSetAccuracy(setAccObj: FlashCardSetAccuracy) -> Double{
        
        var accuracy: Double = 0.0
        let attempts = (Double(setAccObj.correct) + Double(setAccObj.incorrect))
        
        if setAccObj.correct == 0 && setAccObj.incorrect == 0 {
            accuracy = 0.0
        }else{
            
            accuracy = ((Double(setAccObj.correct) / attempts) * 100)
        }
                        
        return accuracy
    }
        
    func addNewFlashCardSetData(setName: String){
        let newFlashCardSetAccData = FlashCardSetAccuracy(context: viewContext)
        newFlashCardSetAccData.setName = setName
        newFlashCardSetAccData.correct = 0
        newFlashCardSetAccData.incorrect = 0
        
        self.saveFlashCardAccData()
    }
    
    func updateCorrectInput(setName: String) {
            
 
        
        let fR = FlashCardSetAccuracy.fetchRequest()
        fR.predicate = NSPredicate(format: "setName == %@", setName)
        
        var results = [FlashCardSetAccuracy]()
        
        do {
            results = try viewContext.fetch(fR)
            results[0].correct += 1
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        

        self.saveFlashCardAccData()
    }
    
    func updateIncorrectInput(setName: String) {

        let fR = FlashCardSetAccuracy.fetchRequest()
        fR.predicate = NSPredicate(format: "setName == %@", setName)
        
        var results = [FlashCardSetAccuracy]()
        
        do {
            results = try viewContext.fetch(fR)
            results[0].incorrect += 1
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }

        self.saveFlashCardAccData()
        
    }
    
    func deleteFlashAccData(setName: String) {
        //viewContext.delete(cardAccData)
        
        self.saveFlashCardAccData()
    }
    
    
    func saveFlashCardAccData() {
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
}
