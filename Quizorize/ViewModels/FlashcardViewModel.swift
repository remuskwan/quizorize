//
//  FlashcardViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 13/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class FlashcardViewModel: ObservableObject {
    @Published var flashcardRepository = FlashcardRepository()
    @Published var flashcards = [Flashcard]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        flashcardRepository.$flashcards
            .assign(to: \.flashcards, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ flashcard: Flashcard) {
        flashcardRepository.addData(flashcard)
    }
}
