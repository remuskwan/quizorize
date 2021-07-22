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
    
    //MARK: SR Algo
    
    var hasCardsDue: Bool {
        !self.flashcardViewModels.map { flashcardVM in
            flashcardVM.flashcard
        }
        .filter { flashcard in
            flashcard.repetition > 0 && flashcard.nextDate ?? 0 <= Date().timeIntervalSince1970
        }
        .isEmpty
    }
    
    var badgeNumber: Int {
        self.flashcardViewModels.map { flashcardVM in
            flashcardVM.flashcard
        }
        .filter { flashcard in
            flashcard.repetition > 0 && flashcard.nextDate ?? 0 <= Date().timeIntervalSince1970
        }
        .count
    }
    
    var sortFlashcard: AnyPublisher<[FlashcardViewModel], Never> {
        flashcardRepository.$flashcards
            .map { flashcards in
                flashcards.map(FlashcardViewModel.init)
            }
            .map { flashcardVMs in
                let newOrder = flashcardVMs.sorted { flashcardVM1, flashcardVM2 in
                    flashcardVM1.flashcard.dateAdded < flashcardVM2.flashcard.dateAdded
                }
                
                return newOrder
            }
            .eraseToAnyPublisher()
            
    }

    
    init(_ deck: Deck) {
        self.flashcardRepository = FlashcardRepository(deck)
        
        sortFlashcard
            .receive(on: RunLoop.main)
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
