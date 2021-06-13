//
//  EmptyFlashcards.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 13/6/21.
//

import Foundation

//Model for DeckCreationFlashcards
struct EmptyFlashcard<CardContent>: Identifiable, Equatable {
    var id = UUID()
    var question: CardContent
    var answer: CardContent
    
    static func ==(lhs: EmptyFlashcard<CardContent>, rhs: EmptyFlashcard<CardContent>) -> Bool {
        lhs.id == rhs.id
    }
}
