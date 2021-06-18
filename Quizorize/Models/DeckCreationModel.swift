//
//  DeckCreationModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 16/6/21.
//

import Foundation

struct DeckCreationModel {
    


    private(set) var flashcards: [EmptyFlashcard]
    
    init(minimumNumberOfCards: Int) {
        flashcards = []
        
        for _ in 0..<minimumNumberOfCards {
            flashcards.append(EmptyFlashcard(id: UUID(), dateAdded: Date()))
        }
    }
    
    
    //Intent(s)
    mutating func addFlashcard() {
        flashcards.append(EmptyFlashcard(id: UUID(), dateAdded: Date()))
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
        var finalisedFlashcards: [Flashcard] = []
        
        for emptyFlashcard in self.flashcards {
            finalisedFlashcards.append(Flashcard(prompt: emptyFlashcard.prompt, answer: emptyFlashcard.answer, dateAdded: emptyFlashcard.dateAdded))
        }
        
        return finalisedFlashcards
    }


    struct EmptyFlashcard: Identifiable, Equatable {
        private struct Initialisers {
            static let promptInit = ""
            static let answerInit = ""
        }
        
        var id: UUID
        var prompt = Initialisers.promptInit
        var answer = Initialisers.answerInit
        var dateAdded: Date
        
        static func ==(lhs: EmptyFlashcard, rhs: EmptyFlashcard) -> Bool {
            lhs.id == rhs.id
        }
        
    }
}
