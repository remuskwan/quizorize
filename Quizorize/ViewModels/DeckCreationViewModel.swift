//
//  DeckCreationViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import SwiftUI
import Combine

class DeckCreationViewModel: ObservableObject {
    

    init() {
        self.model = DeckCreationModel(minimumNumberOfCards: 2)
    }
    
    //MARK: Interpret(s) from Model
    @Published private var model: DeckCreationModel
    
    @Published var alertMessage = ""
    
    @Published var isNotValid = false

    var flashcards: [DeckCreationModel.EmptyFlashcard] {
        model.flashcards
    }
    
    @Published var deckTitle = ""
    
    func hasDeckTitleEmpty() -> Bool {
        return deckTitle == ""
    }
    
    func hasAnyFieldsEmpty() -> Bool {
        for flashcard in flashcards {
            if flashcard.prompt == "" || flashcard.answer == "" {
                return true
            }
        }
        
        return false
    }
    
    func hasLessThanTwoCards() -> Bool {
        flashcards.count < 2
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
    
}

