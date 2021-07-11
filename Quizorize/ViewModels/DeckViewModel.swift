//
//  DeckViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 14/6/21.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI

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

    init(deck: Deck) {
        self.deck = deck
        $deck
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
