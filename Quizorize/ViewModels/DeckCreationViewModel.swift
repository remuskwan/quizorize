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
        //self.model = DeckCreationModel(minimumNumberOfCards: 2)
        self.deckTitle = ""
        
        self.flashcards = []
        self.flashcards.append(EmptyFlashcard(id: UUID().uuidString, dateAdded: Date()))
        self.flashcards.append(EmptyFlashcard(id: UUID().uuidString, dateAdded: Date()))
    }
    
    init(flashcardListVM: FlashcardListViewModel, deckVM: DeckViewModel) {
        let flashcards = flashcardListVM.flashcardViewModels
            .map { flashcardVM in
                flashcardVM.flashcard
            }
            .map { flashcard in
                /*DeckCreationModel.*/EmptyFlashcard(id: flashcard.id!, prompt: flashcard.prompt, answer: flashcard.answer, dateAdded: flashcard.dateAdded)
            }
        
        let deckTitle = deckVM.deck.title
        
        self.deckTitle = deckTitle
        self.flashcards = flashcards
        
        //self.model = DeckCreationModel(flashcards, deckTitle)

    }
    
    //MARK: Interpret(s) from Model
    //@Published private var model: DeckCreationModel

    @Published var alertMessage = ""
    
    @Published var isNotValid = false
    
    @Published var deckTitle: String
    
    @Published var flashcards: [EmptyFlashcard]

    /*
    var flashcards: [DeckCreationModel.EmptyFlashcard] {
        model.flashcards
    }
    */

    func hasDeckTitleEmpty() -> Bool {
        return self.deckTitle == ""
    }
    
    func hasAnyFieldsEmpty() -> Bool {
        print(flashcards)
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
        flashcards.append(EmptyFlashcard(id: UUID().uuidString, dateAdded: Date()))
        //model.addFlashcard()
    }
    
    func removeFields(at indexSet: IndexSet) {
        //model.removeFields(at: indexSet)

        flashcards.remove(atOffsets: indexSet)
    }
    
    func editPromptWith(string: String, at index: Int) {
        //model.editPromptWith(string, at: index)
        flashcards[index].prompt = string
    }
    
    func editAnswerWith(string: String, at index: Int) {
        //model.editAnswerWith(string, at: index)
        flashcards[index].answer = string
    }
    
    func getFinalisedFlashcards() -> [Flashcard] {
        let finalFlashcards = self.flashcards
            .map { flashcard in
                Flashcard(
                    id: flashcard.id,
                    prompt: flashcard.prompt,
                    answer: flashcard.answer,
                    dateAdded: flashcard.dateAdded,
                    repetition: flashcard.repetition,
                    interval: flashcard.interval,
                    easinessFactor: flashcard.easinessFactor,
                    previousDate: flashcard.previousDate,
                    nextDate: flashcard.nextDate)
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
        
        //MARK: SR Algo vars
        var repetition = 0
        var interval = 0
        var easinessFactor = 2.5
        var previousDate: TimeInterval?
        var nextDate: TimeInterval?

        
        static func ==(lhs: EmptyFlashcard, rhs: EmptyFlashcard) -> Bool {
            lhs.id == rhs.id
        }
        
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

