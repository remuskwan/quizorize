//
//  DeckListViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 8/6/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine
import SwiftUI

class DeckListViewModel: ObservableObject {
    @Published var deckRepository = DeckRepository()
    private var flashcardRepository = FlashcardRepository()
    @Published var deckViewModels = [DeckViewModel]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        deckRepository.$decks
            .map { decks in
                decks.map(DeckViewModel.init)
            }
            .assign(to: \.deckViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func add(deck: Deck, flashcards: [Flashcard]) {
        deckRepository.addData(deck: deck, flashcards: flashcards)
    }
    
    func remove(_ deck: Deck) {
        deckRepository.removeData(deck)
    }
    
    func update(_ deck: Deck) {
        deckRepository.updateData(deck)
    }
    
    func sortDeckVMs(_ sortBy: SortBy) -> [DeckViewModel] {
        switch sortBy {
        case .date:
            return deckViewModels.sorted { deckVM1, deckVM2 in
                deckVM1.deck.dateCreated < deckVM2.deck.dateCreated
            }
        case .name:
            return deckViewModels.sorted { deckVM1, deckVM2 in
                deckVM1.deck.title < deckVM2.deck.title
            }
        case .type:
            return deckViewModels.sorted { deckVM1, deckVM2 in
                deckVM1.deck.dateCreated < deckVM2.deck.dateCreated
            }
        }
    }
}
