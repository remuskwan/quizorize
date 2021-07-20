//
//  DeckViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 14/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class DeckViewModel: ObservableObject, Identifiable {
    private var deckRepository = DeckRepository()
    @Published var deck: Deck
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Intent(s)
    func toggleExamMode() {
        deckRepository.updateData(deck)
        print(deck.isExamMode)
    }
    
    func updateFlashcards(_ flashcards: [Flashcard]) {
        deckRepository.updateFlashcardsData(self.deck, flashcards: flashcards)
    }
    
    func addFlashcards(_ flashcards: [Flashcard]) {
        deckRepository.addFlashcardData(self.deck, flashcards: flashcards)
    }
    
    func deleteFlashcards(_ flashcards: [Flashcard]) {
        deckRepository.deleteFlashcardsData(self.deck, flashcards: flashcards)
    }
    
    func updatePrevExamScore(_ examScore: Double) {
        self.deck.examModePrevScore = examScore
        deckRepository.updateData(deck)
    }

    init(deck: Deck) {
        self.deck = deck
        $deck
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func getDateCreated() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: deck.dateCreated)
    }
}
