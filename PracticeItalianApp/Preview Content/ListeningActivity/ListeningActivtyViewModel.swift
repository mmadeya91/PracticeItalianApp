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
}

struct audioActivty {
    let id = UUID()
    let title: String
    let description: String
    let duration: TimeInterval
    let track: String
    let image: String

    static let data = audioActivty(title: "Pasta Carbonara", description: "Recipe to Make Pasta Carbonara", duration: 70, track: "pastaCarbonara", image: "pasta")
}
