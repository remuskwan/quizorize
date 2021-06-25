//
//  FlashcardListViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 14/6/21.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI

class FlashcardListViewModel: ObservableObject {
    @Published var flashcardRepository: FlashcardRepository
    @Published var flashcardViewModels = [FlashcardViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    var count: Int {
        return flashcardViewModels.count
    }
    
    @Published var counter = 0

    init(_ deck: Deck) {
        self.flashcardRepository = FlashcardRepository(deck)
        flashcardRepository.$flashcards
            .map { flashcards in  
                flashcards.map(FlashcardViewModel.init)
            }
            .assign(to: \.flashcardViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ flashcard: Flashcard) {
        flashcardRepository.addData(flashcard)
    }
    
    func remove(_ flashcard: Flashcard) {
        flashcardRepository.removeData(flashcard)
    }
    
    func update(_ flashcard: Flashcard) {
        flashcardRepository.updateData(flashcard)
    }
} 
