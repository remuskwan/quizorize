//
//  DeckCreationModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 16/6/21.
//

import Foundation

struct DeckCreationModel {
    


    var flashcards: [EmptyFlashcard]
    
    private(set) var deckTitle: String
    
    init(minimumNumberOfCards: Int) {
        flashcards = []
        
        for _ in 0..<minimumNumberOfCards {
            flashcards.append(EmptyFlashcard(id: UUID().uuidString, dateAdded: Date()))
        }
        
        self.deckTitle = ""
    }
    
    init(_ flashcards: [DeckCreationModel.EmptyFlashcard], _ deckTitle: String) {
        self.flashcards = flashcards
        
        self.deckTitle = deckTitle
    }
    
    
    //Intent(s)
    mutating func addFlashcard() {
        flashcards.append(EmptyFlashcard(id: UUID().uuidString, dateAdded: Date()))
    }
    
    mutating func removeFields(at indexSet: IndexSet) {
        flashcards.remove(atOffsets: indexSet)
    }
    
    mutating func editPromptWith(_ string: String, at index: Int) {
        flashcards[index].prompt = string
    }
    
    mutating func editAnswerWith(_ string: String, at index: Int) {
        flashcards[index].answer = string
    }
    
    func getFinaliseFlashcards() -> [Flashcard] {
        let finalFlashcards = self.flashcards
            .map { flashcard in
                Flashcard(prompt: flashcard.prompt, answer: flashcard.answer)
            }
        return finalFlashcards
    }


    struct EmptyFlashcard: Identifiable, Equatable {
        private struct Initialisers {
            static let promptInit = ""
            static let answerInit = ""
        }
        
        var id: String
        var prompt = Initialisers.promptInit
        var answer = Initialisers.answerInit
        var dateAdded: Date
        
        static func ==(lhs: EmptyFlashcard, rhs: EmptyFlashcard) -> Bool {
            lhs.id == rhs.id
        }
        
    }
}
