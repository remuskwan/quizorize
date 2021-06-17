//
//  EmptyFlashcards.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 13/6/21.
//

import Foundation

//Model for DeckCreationFlashcards
struct EmptyFlashcard: Identifiable, Equatable {
    var id = UUID()
    var prompt: String
    var answer: String
    var dateAdded: Date
    
    static func ==(lhs: EmptyFlashcard, rhs: EmptyFlashcard) -> Bool {
        lhs.id == rhs.id
    }
}
