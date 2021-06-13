//
//  DeckListViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 8/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class DeckListViewModel: ObservableObject {
    @Published var deckRepository = DeckRepository()
    @Published var decks = [Deck]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        deckRepository.$decks
            .assign(to: \.decks, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ deck: Deck) {
        deckRepository.addData(deck)
    }
}
