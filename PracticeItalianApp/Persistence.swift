//
//  Persistence.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
       for _ in 0..<5 {
         let newItem = UserMadeFlashCard(context: viewContext)
           newItem.englishLine1 = "hello"
           newItem.englishLine2 = "test"
           newItem.italianLine1 = "ciao"
           newItem.italianLine2 = "fem"
           
           let newVerbItem = UserAddedVerb(context: viewContext)
           newVerbItem.verbNameEnglish = "To take"
           newVerbItem.verbNameItalian = "Prendere"
           newVerbItem.presente = ["Prendo", "Prendi", "Prende", "Prendeno", "Prendiamo", "Prendete"]
           newVerbItem.passatoProssimo = ["Ho preso", "Hai preso", "Ha preso", "Hanno preso", "Abbiamo preso", "Avete preso"]
           newVerbItem.futuro = ["Prendero", "Prenderei", "Prendere", "Prendereno", "Prenderemo", "Prenderete"]
           newVerbItem.imperativo = ["Prendi", "Prendi", "Prende", "Prendeni", "Prendi", "Prendi"]
           newVerbItem.imperfetto = ["Prendevo", "Prendevi", "Prendeve", "Prendevano", "Prendevamo", "Prendevate"]
           newVerbItem.condizionale = ["Prenderrei", "Prenderesti", "Prenderebbe", "Prenderebbero", "Prenderebiamo", "Prenderette"]
           
           let newVerbListItem = UserVerbList(context: viewContext)
           newVerbListItem.verbNameEnglish = "To take"
           newVerbListItem.verbNameItalian = "Prendere"
           newVerbListItem.passatoProssimo = ["Ho preso", "Hai preso", "Ha preso", "Hanno preso", "Abbiamo preso", "Avete preso"]
           newVerbListItem.futuro = ["Prendero", "Prenderei", "Prendere", "Prendereno", "Prenderemo", "Prenderete"]
           newVerbListItem.imperativo = ["Prendi", "Prendi", "Prende", "Prendeni", "Prendi", "Prendi"]
           newVerbListItem.imperfetto = ["Prendevo", "Prendevi", "Prendeve", "Prendevano", "Prendevamo", "Prendevate"]
           newVerbListItem.condizionale = ["Prenderrei", "Prenderesti", "Prenderebbe", "Prenderebbero", "Prenderebiamo", "Prenderette"]
           
        
           
           
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PracticeItalianApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                //fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
