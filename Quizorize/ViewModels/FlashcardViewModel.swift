//
//  FlashcardViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 13/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class FlashcardViewModel: ObservableObject, Identifiable {
    //private var flashcardRepository = FlashcardRepository()
    @Published var flashcard: Flashcard
    @Published var flipped = false
    
    var display: String {
        if self.flipped {
            return flashcard.answer
        } else {
            return flashcard.prompt
        }
    }
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Intent(s)

    init(flashcard: Flashcard) {
        self.flashcard = flashcard
        $flashcard
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
