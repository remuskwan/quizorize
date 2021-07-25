//
//  DeckCreationViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import SwiftUI
import Combine

class DeckCreationViewModel: ObservableObject {
    
    private var cancellableSet = Set<AnyCancellable>()

    init() {
        //self.model = DeckCreationModel(minimumNumberOfCards: 2)
        self.deckTitle = ""
        self.isEditMode = false
        
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
        
        self.isEditMode = true
        

        //self.model = DeckCreationModel(flashcards, deckTitle)

    }
    
    //MARK: Interpret(s) from Model
    //@Published private var model: DeckCreationModel

    @Published var alertMessage = ""
    
    @Published var isNotValid = false
    
    @Published var deckTitle: String
    
    @Published var flashcards: [EmptyFlashcard]
    
    //MARK: For Alerts
    var requirementsNotMet: Bool {
        self.hasAnyFieldsEmpty() || self.hasDeckTitleEmpty() || self.hasLessThanTwoCards()
    }
    
    @Published var requirementsNotMetMessage: String = ""

    let isEditMode: Bool
    
    private var deckTitleEmptyPubliser: AnyPublisher<Bool, Never> {
        $deckTitle
            .map { deckTitle in
                deckTitle == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var anyFieldEmptyPublisher: AnyPublisher<Bool, Never> {
        $flashcards
            .map { flashcards in
                let anyFieldEmpty = !flashcards.map { flashcard in
                    flashcard.prompt == "" || flashcard.answer == ""
                }
                .isEmpty
                
                return anyFieldEmpty
            }
            .eraseToAnyPublisher()
    }
    
    private var hasLessThanTwoFlashcardsPublisher: AnyPublisher<Bool, Never> {
        $flashcards
            .map { flashcards in
                flashcards.count < 2
            }
            .eraseToAnyPublisher()
    }
    
    var requirementsNotMetPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(deckTitleEmptyPubliser, anyFieldEmptyPublisher, hasLessThanTwoFlashcardsPublisher)
            .map { deckTitleEmpty, anyFieldEmpty, hasLessThanTwo in
                deckTitleEmpty || anyFieldEmpty || hasLessThanTwo
            }
            .eraseToAnyPublisher()
    }
    
    var requirementsNotMetMessagePublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest3(deckTitleEmptyPubliser, anyFieldEmptyPublisher, hasLessThanTwoFlashcardsPublisher)
            .map { deckTitleEmpty, anyFieldEmpty, hasLessThanTwo in
                var message = """
                    """
                if (deckTitleEmpty || anyFieldEmpty || hasLessThanTwo) {
                    if (deckTitleEmpty) {
                        message = message + "You must have a deck title."
                    }
                    
                    if (anyFieldEmpty) {
                        message = message + "You must fill up all fields in your deck."
                    }
                    
                    if (hasLessThanTwo) {
                        message = message + "You must create a minimum of two flashcards."
                    }
                }

                return message
            }
            .eraseToAnyPublisher()
    }

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

