//
//  SummaryCardViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 23/6/21.
//

import Foundation
import Combine
import SwiftUI

class PracticeModeViewModel: ObservableObject {
    @Published var practiceFlashcards: [FlashcardViewModel]
    @Published var counter: Int
    @Published var topCardOffset: CGSize = .zero
    @Published var activeCard: Flashcard? = nil
    @Published var swipeLeft = 0
    @Published var swipeRight = 0
    
    //MARK: SR Algo
    private var isExamMode: Bool
    @Published var flipStatuses: [String: Bool]

    
    var count: Int {
        return practiceFlashcards.count
    }
    
    init(_ practiceFlashcards: [FlashcardViewModel], isExamMode: Bool) {
        self.practiceFlashcards = practiceFlashcards
        self.counter = 0
        self.isExamMode = isExamMode
        
        self.flipStatuses = [String: Bool]()
        
        //Keep track of flip statuses of flashcards
        practiceFlashcards.forEach { practiceFlashcard in
            flipStatuses[practiceFlashcard.id] = false
        }
    }
    
    //MARK: Intent(s)
    
    //true means that it is flipped.
    func getFlipStatusOf(uuid: String) -> Bool {
        return flipStatuses[uuid]!
    }
    
    func toggleFlipStatusOf(uuid: String) {
        flipStatuses[uuid] = !(flipStatuses[uuid]!)
    }
    
    /*
    func toggleFail(of uuid: String) {
        failOrPass[uuid] = false
    }
    
    func togglePass(of uuid: String) {
        failOrPass[uuid] = true
    }
    
    func toggleNil(of uuid: String) {
        failOrPass[uuid] = nil
    }
     */
    
   
    //MARK: Display Functions
    func position(of flashcard: Flashcard) -> Int {
        let flashcards = practiceFlashcards.map { flashcardVM in
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
        let topCard = practiceFlashcards.remove(at: position(of: state))
        practiceFlashcards.append(topCard)
    }

    func moveToFront(_ state: Flashcard) {
        let topCard = practiceFlashcards.remove(at: position(of: state))
        practiceFlashcards.insert(topCard, at: 0)
    }
    
    func shuffle() {
        practiceFlashcards.shuffle()
    }
}
