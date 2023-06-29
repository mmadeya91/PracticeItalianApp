//
//  Character.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/29/23.
//

import SwiftUI


struct Character: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
    
}

var characters_: [Character] = [

    Character(value: "Lorem"),
    Character(value: "Ipsum"),
    Character(value: "is"),
    Character(value: "simply"),
    Character(value: "dummy"),
    Character(value: "text"),
    Character(value: "if"),
    Character(value: "the"),
    Character(value: "design"),

]
