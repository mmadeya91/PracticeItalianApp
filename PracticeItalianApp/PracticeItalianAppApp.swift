//
//  PracticeItalianAppApp.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI

@main
struct PracticeItalianAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var audioManager = AudioManager()
    @StateObject var listeningActivityManager = ListeningActivityManager()
    @StateObject var globalModel = GlobalModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(audioManager)
                .environmentObject(listeningActivityManager)
                .environmentObject(globalModel)
        }
    }
}
