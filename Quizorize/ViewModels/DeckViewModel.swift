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

    init(deck: Deck) {
        self.deck = deck
        $deck
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ deck: Deck) {
        deckRepository.addData(deck)
    }
}
