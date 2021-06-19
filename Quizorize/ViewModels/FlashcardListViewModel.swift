//
//  FlashcardListViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 14/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class FlashcardListViewModel: ObservableObject {
    @Published var flashcardRepository = FlashcardRepository()
    @Published var flashcardViewModels = [FlashcardViewModel]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        flashcardRepository.$flashcards
            .map { flashcards in
                flashcards.map(FlashcardViewModel.init)
            }
            .assign(to: \.flashcardViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ flashcard: Flashcard, deckId: String) {
        flashcardRepository.addData(flashcard, deckId: deckId)
    }
    
    func remove(_ flashcard: Flashcard, deckId: String) {
        flashcardRepository.removeData(flashcard, deckId: deckId)
    }
    
    func update(_ flashcard: Flashcard, deckId: String) {
        flashcardRepository.updateData(flashcard, deckId: deckId)
    }
}
