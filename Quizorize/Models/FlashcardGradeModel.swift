//
//  FlashcardGradeModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 9/6/21.
//

import Foundation

//Stores the Spaced Repetition properties of flashcards
struct FlashcardGradeModel {
    var id: UUID
    var userID: UUID
    var deckID: UUID
    var flashcardID: UUID
    var repetition: Int
    var interval: Int
    var easinessFactor: Double
    var previousDate: TimeInterval
    var nextDate: TimeInterval
}


