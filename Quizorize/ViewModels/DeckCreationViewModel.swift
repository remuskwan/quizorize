//
//  DeckCreationViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import SwiftUI
import Combine

class DeckCreationViewModel: ObservableObject {
    

    //MARK: Interpret(s) from Model
    @Published private var model: DeckCreationModel = DeckCreationModel(minimumNumberOfCards: 2)
    @Published private var emptyFlashcards = [EmptyFlashcard](arrayLiteral: EmptyFlashcard(prompt: "", answer: "", dateAdded: Date()))
    
    var flashcards: [DeckCreationModel.EmptyFlashcard] {
        model.flashcards
    }
    
    //MARK: Intent(s) from View
    
    func addFlashcard() {
        model.addFlashcard()
    }
    
    func removeFields(at index: IndexSet) {
        model.removeFields(at: index)
    }
    
    func editPromptWith(string: String, at index: Int) {
        model.editPromptWith(string, at: index)
    }
    
    func editAnswerWith(string: String, at index: Int) {
        model.editAnswerWith(string, at: index)
    }
    
    func getFinalisedFlashcards() -> [Flashcard] {
        model.getFinaliseFlashcards()
    }
    
    func checkIfAnyFieldsAreEmpty() -> Bool {
        for anyFlashcard in flashcards {
            if anyFlashcard.prompt.isEmpty || anyFlashcard.answer.isEmpty {
                return true
            }
        }
        
        return false
    }
}
