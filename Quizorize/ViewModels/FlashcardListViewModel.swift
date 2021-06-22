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
    @Published var topCardOffset: CGSize = .zero
    @Published var activeCard: Flashcard? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var count: Int {
        return flashcardViewModels.count
    }

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
    
    func position(of flashcard: Flashcard) -> Int {
        let flashcards = flashcardViewModels.map { flashcardVM in
            flashcardVM.flashcard
        }
        return flashcards.firstIndex(of: flashcard) ?? 0
    }

    func scale(of flashcard: Flashcard) -> CGFloat {
        let deckPosition = position(of: flashcard)
        let scale = CGFloat(deckPosition) * 0.02
        return CGFloat(1 - scale)
    }

    func deckOffset(of flashcard: Flashcard) -> CGFloat {
        let deckPosition = position(of: flashcard)
        let offset = deckPosition * -10
        return CGFloat(offset)
    }

    func zIndex(of flashcard: Flashcard) -> Double {
        return Double(count - position(of: flashcard))
    }
    
    func rotation(for flashcard: Flashcard, offset: CGSize = .zero) -> Angle {
        return .degrees(Double(offset.width) / 20.0)
    }
    
    func moveToBack(_ state: Flashcard) {
        let topCard = flashcardViewModels.remove(at: position(of: state))
        flashcardViewModels.append(topCard)
    }

    func moveToFront(_ state: Flashcard) {
        let topCard = flashcardViewModels.remove(at: position(of: state))
        flashcardViewModels.insert(topCard, at: 0)
    }
}
