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
    
    @Published var isTesting = true
    
    //MARK: SR Algo variables
    @Published var isSpacedRepetitionOn: Bool = true
    @Published var flipStatuses: [String: Bool]
    private(set) var distancesTravelled: [String: CGFloat] = [String: CGFloat]()
    
    let timeIntervalAsOfClick: TimeInterval
    
    @Published private var spacedRepetitionModel: ExamModeViewModel
    
    var count: Int {
        if isSpacedRepetitionOn {
            return spacedRepetitionModel.updatedFlashcards.count
        } else {
            return practiceFlashcards.count
        }
    }
    
    var actualPracticeFlashcards: [Flashcard] {
        if isSpacedRepetitionOn {
            return spacedRepetitionModel.updatedFlashcards
        } else {
            return practiceFlashcards.map { flashcardVM in
                flashcardVM.flashcard
            }
        }
    }
    
    private var yetToFinishQuizzingPublisher: AnyPublisher<Bool, Never> {
        $counter
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { counter in
                !(counter == self.count)
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellableSet = Set<AnyCancellable>()
    
    //MARK: Constructor
    init(_ practiceFlashcards: [FlashcardViewModel]) {
        self.practiceFlashcards = practiceFlashcards
        self.counter = 0

        self.flipStatuses = [String: Bool]()
        
        let timeIntervalAsOfClick = Date().timeIntervalSince1970
        self.timeIntervalAsOfClick = timeIntervalAsOfClick
        
        let flashcardsDue = practiceFlashcards.map { flashcardVM in
            flashcardVM.flashcard
        }
        .filter { flashcard in
            flashcard.nextDate ?? 0 <= timeIntervalAsOfClick
        }
        
        self.spacedRepetitionModel = ExamModeViewModel(timeIntervalAsOfClick: timeIntervalAsOfClick, updatedFlashcards: flashcardsDue)
        
        //Keep track of flip statuses of flashcards
        practiceFlashcards.forEach { practiceFlashcard in
            flipStatuses[practiceFlashcard.id] = false
        }
        
        self.yetToFinishQuizzingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isTesting, on: self)
            .store(in: &cancellableSet)
    }
    

    //MARK: Intent(s)
    
    //true means that it is flipped.
    func getFlipStatusOf(uuid: String) -> Bool {
        return flipStatuses[uuid]!
    }
    
    func toggleFlipStatusOf(uuid: String) {
        flipStatuses[uuid] = !(flipStatuses[uuid]!)
    }
    
    //Set the translation width of a flashcard
    func setTranslationWidthOf(id: String, width: CGFloat) {
        self.distancesTravelled[id] = width
    }
   
    //MARK: SR Algo functions
    //Helper to get the earliest date for user's next study
    private func getEarliestNextDateInIntervals() -> TimeInterval {
        let sortedUpdatedFlashcards = ExamModeViewModel.getSortedFlashcards(self.spacedRepetitionModel.updatedFlashcards)

        let sortedDBFlashcards = ExamModeViewModel.getSortedFlashcards(self.practiceFlashcards
                                                                    .map { flashcardVM in
                                                                        flashcardVM.flashcard
                                                                    }
                                                                    .filter { flashcard in
                                                                        flashcard.nextDate ?? 0 > self.timeIntervalAsOfClick
                                                                    })

        
        var earliestDate: TimeInterval = 0
        //If updatedFlashcard list is not empty(SR prac is being conducted, compare those cards with DB)
        if let earliestUpdatedDate = sortedUpdatedFlashcards.first?.nextDate, let earliestDBDate = sortedDBFlashcards.first?.nextDate {
            earliestDate = earliestUpdatedDate < earliestDBDate ? earliestUpdatedDate : earliestDBDate
            print(Date(timeIntervalSince1970: earliestDate))
        } else if let earliestUpdatedDate = sortedUpdatedFlashcards.first?.nextDate {
            earliestDate = earliestUpdatedDate
            print(Date(timeIntervalSince1970: earliestDate))
        } else if let earliestDBDate = sortedDBFlashcards.first?.nextDate {
            earliestDate = earliestDBDate
            print(Date(timeIntervalSince1970: earliestDate))
        } else {
            
        }
        
        return earliestDate

        /*
        let earliestDBDateInIntervals = self.practiceFlashcards
            .map { flashcardVM in
                flashcardVM.flashcard
            }
            .sorted {
                $0.nextDate ?? 0 <= $1.nextDate ?? 0
            }
            .first?
            .nextDate ?? 0
        */
    }
    
    func earliestDateInString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dateOffset = 27000 //Needed as there are some bugs when converting to string
        
        let earliestDate = Date(timeIntervalSince1970: self.getEarliestNextDateInIntervals() - Double(dateOffset))
        
        return dateFormatter.string(from: earliestDate)
    }
    
    //Helper to get earliest date for user's date of completion
    private func getDateOfCompletionInIntervals() -> TimeInterval {
        let sortedUpdatedFlashcards = ExamModeViewModel.getSortedFlashcards(self.spacedRepetitionModel.updatedFlashcards)

        let sortedDBFlashcards = ExamModeViewModel.getSortedFlashcards(self.practiceFlashcards
                                                                    .map { flashcardVM in
                                                                        flashcardVM.flashcard
                                                                    }
                                                                    .filter { flashcard in
                                                                        flashcard.nextDate ?? 0 > self.timeIntervalAsOfClick
                                                                    })

        
        var dateOfCompletion: TimeInterval = 0
        //If updatedFlashcard list is not empty(SR prac is being conducted, compare those cards with DB)
        if let latestUpdatedDate = sortedUpdatedFlashcards.last?.previousDate, let latestDBDate = sortedDBFlashcards.last?.previousDate {
            dateOfCompletion = latestUpdatedDate > latestDBDate ? latestUpdatedDate : latestDBDate
        } else if let latestUpdatedDate = sortedUpdatedFlashcards.last?.previousDate {
            dateOfCompletion = latestUpdatedDate
        } else if let latestDBDate = sortedDBFlashcards.last?.previousDate {
            dateOfCompletion = latestDBDate
        } else {
            
        }
        
        /*
        let dateOfCompletionInINtervals = self.practiceFlashcards
            .map { flashcardVM in
                flashcardVM.flashcard
            }
            .sorted {
                $0.previousDate ?? 0 <= $1.previousDate ?? 0
            }
            .last?
            .previousDate ?? 0
        */
        
        return dateOfCompletion
    }
    
    func dateOfCompletionInString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dateOffset = 27000 //Needed as there are some bugs when converting to string
        
        let dateOfCompletion = Date(timeIntervalSince1970: self.getDateOfCompletionInIntervals() - Double(dateOffset))
        
        return dateFormatter.string(from: dateOfCompletion)
    }
    
    func intervalIsZero() -> Bool {
        self.spacedRepetitionModel.intervalIsZero()
    }
    
    func addAndUpdateFailed(_ flashcard: Flashcard) {
        self.spacedRepetitionModel.addAndUpdateFailed(flashcard)
    }
    
    func addAndUpdatePassed(_ flashcard: Flashcard) {
        self.spacedRepetitionModel.addAndUpdatePassed(flashcard)
    }
    
    func reset() {
        self.counter = 0
        self.flipStatuses = self.flipStatuses.mapValues { values in
            return false
        }
        self.distancesTravelled = [String: CGFloat]()
        
        self.shuffle()
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
    
    //function that mainly determines the offset+position, get it to work with other flashcardviewmodels
    func position(of flashcard: Flashcard) -> Int {
        let flashcards = self.isSpacedRepetitionOn ? spacedRepetitionModel.updatedFlashcards : self.practiceFlashcards.map { flashcardVM in
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
        if isSpacedRepetitionOn {
            let topCard = self.spacedRepetitionModel.remove(at: position(of: state))
            self.spacedRepetitionModel.append(topCard)
        } else {
            let topCard = practiceFlashcards.remove(at: position(of: state))
            practiceFlashcards.append(topCard)
        }
    }

    func moveToFront(_ state: Flashcard) {
        if isSpacedRepetitionOn {
            let topCard = self.spacedRepetitionModel.remove(at: position(of: state))
            self.spacedRepetitionModel.insert(topCard, at: 0)
            
        } else {
            let topCard = practiceFlashcards.remove(at: position(of: state))
            practiceFlashcards.insert(topCard, at: 0)
        }
    }
    
    func shuffle() {
        self.isSpacedRepetitionOn ? spacedRepetitionModel.shuffle() : practiceFlashcards.shuffle()
    }
}
