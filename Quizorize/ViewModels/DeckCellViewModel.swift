//
//  DeckCellViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 8/6/21.
//

import Foundation

class DeckCellViewModel: ObservableObject, Identifiable {
    @Published var deck: Deck
    
    var id = ""
    
    init(deck: Deck) {
        self.deck = deck
    }
}
