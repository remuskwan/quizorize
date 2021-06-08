//
//  DeckModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import Foundation

//MARK: Model for Deck (to be stored in Firestore)
struct DeckModel<FlashcardContent> where FlashcardContent: Equatable {
    
    private var deckID: UUID
    private var deckTitle: String
    
    private(set) var cards: Array<Flashcard>
    
    //MARK: Functions
    
    //Change the deckTitle
    mutating func changeTitle(to deckTitle: String) {
        self.deckTitle = deckTitle
    }
    
    
    struct Flashcard: Identifiable {
        var isFacedFront = true
        var content: FlashcardContent
        var id: UUID
    }
}
