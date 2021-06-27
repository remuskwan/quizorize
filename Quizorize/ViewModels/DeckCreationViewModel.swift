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
        self.deckTitle = ""
    }
    
    init(flashcardListVM: FlashcardListViewModel, deckVM: DeckViewModel) {
        let flashcards = flashcardListVM.flashcardViewModels
            .map { flashcardVM in
                flashcardVM.flashcard
            }
            .map { flashcard in
                DeckCreationModel.EmptyFlashcard(id: flashcard.id!, prompt: flashcard.prompt, answer: flashcard.answer, dateAdded: flashcard.dateAdded)
            }
        
        let deckTitle = deckVM.deck.title
        
        self.deckTitle = deckTitle
        
        self.model = DeckCreationModel(flashcards, deckTitle)
    }
    
    //MARK: Interpret(s) from Model
    @Published private var model: DeckCreationModel
    
    @Published var alertMessage = ""
    
    @Published var isNotValid = false
    
    @Published var deckTitle: String

    var flashcards: [DeckCreationModel.EmptyFlashcard] {
        model.flashcards
    }
    
    func hasDeckTitleEmpty() -> Bool {
        return self.deckTitle == ""
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

extension String {
    var uuid: String? {
        var string = self
        var index = string.index(string.startIndex, offsetBy: 8)
        print(string.count)
        for _ in 0..<4 {
            string.insert("-", at: index)
            print(string)
            index = string.index(index, offsetBy: 5)
        }
        print(string)
        // The init below is used to check the validity of the string returned.
        return UUID(uuidString: string)?.uuidString
    }
}

