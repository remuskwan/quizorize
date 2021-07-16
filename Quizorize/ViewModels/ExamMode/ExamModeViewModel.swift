//
//  ExamModeViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 11/7/21.
//

import Foundation
import SwiftUI
import Combine

//MARK: Only flashcards that have finished grading will be passed here.
class ExamModeViewModel: ObservableObject {
    
    init(isExamMode: Bool, flashcardVMs: [FlashcardViewModel], databaseFlashcardViewModels: [FlashcardViewModel]) {
        let timeIntervalAsOfClick = Date().timeIntervalSince1970
        
        self.updatedFlashcards = []
        self.flashcardGrader = FlashcardGrader()
        self.isExamMode = isExamMode
        self.cardsDue = flashcardVMs.map { flashcardVM in
            flashcardVM.flashcard
        }
        .filter { flashcard in
            flashcard.nextDate ?? 0 <= timeIntervalAsOfClick
        }
        .count
        
        self.timeIntervalAsOfClick = timeIntervalAsOfClick
        self.databaseFlashcardViewModels = databaseFlashcardViewModels
    }
    
    private(set) var distancesTravelled: [String: CGFloat] = [String: CGFloat]()
    private var updatedFlashcards: [Flashcard] //Should only have flashcards that are updated
    private var flashcardGrader: FlashcardGrader
    
    @Published private(set) var databaseFlashcardViewModels: [FlashcardViewModel] //Flashcards from database, used to compare with current updatedFlashcards
    
    @Published private(set) var isExamMode: Bool
    @Published private(set) var cardsDue: Int
    @Published private(set) var cardsAreDue: Bool = false
        

    private let timeIntervalAsOfClick: TimeInterval

    //MARK: Intent(s)
    
    //Get updatedFlashcards
    func getUpdatedFlashcards() -> [Flashcard] {
        updatedFlashcards
    }
    
    //Toggle ExamMode (while user still inside practice)
    func turnOffExamMode() {
        self.isExamMode = false
        print(isExamMode)
    }
    
    //Set the translation width of a flashcard
    func setTranslationWidthOf(id: String, width: CGFloat) {
        self.distancesTravelled[id] = width
    }
    
    func addAndUpdateFailed(_ currentFlashcard: Flashcard) {
        let updatedFlashcard = self.flashcardGrader.gradeFlashcard(flashcard: currentFlashcard, grade: ExamModeViewModel.Grade.fail, currentDateTime: self.timeIntervalAsOfClick)
        
        self.updatedFlashcards.append(updatedFlashcard)
    }
    
    func addAndUpdatePassed(_ currentFlashcard: Flashcard) {
        let updatedFlashcard = self.flashcardGrader.gradeFlashcard(flashcard: currentFlashcard, grade: ExamModeViewModel.Grade.pass, currentDateTime: self.timeIntervalAsOfClick)
        
        self.updatedFlashcards.append(updatedFlashcard)
        
    }
    
    private func getSortedFlashcards(_ flashcards: [Flashcard]) -> [Flashcard] {
        flashcards.sorted {
            $0.nextDate ?? 0 <= $1.nextDate ?? 0
        }
    }
    
    //Helper for Date in String
    private func getEarliestNextDate() -> Date {
        
        let databaseFlashcards = self.databaseFlashcardViewModels.map { flashcardVM in
            flashcardVM.flashcard
        }
        
        let earliestDate = self.getSortedFlashcards(databaseFlashcards)
            .first?.nextDate ?? 0

        /*
        let sortedDbFlashcards: [Flashcard] = self.getSortedFlashcards(databaseFlashcards)
        let sortedUpdatedFlashcards: [Flashcard] = self.getSortedFlashcards(self.updatedFlashcards)
        var earliestDate: TimeInterval = 0
        
        if let earliestDbFlashcard = sortedDbFlashcards.first?.nextDate, let earliestUpdatedFlashcard = sortedUpdatedFlashcards.first?.nextDate {
            if earliestDbFlashcard < earliestUpdatedFlashcard && self.intervalIsZero() {
                earliestDate = earliestDbFlashcard
            } else {
                earliestDate = earliestUpdatedFlashcard
            }
        }
        
        if earliestDate == 0 {
            earliestDate = sortedUpdatedFlashcards.first?.nextDate ?? sortedDbFlashcards.first?.nextDate ?? 0
        }
        */

        return Date(timeIntervalSince1970: earliestDate)
    }
    
    private func getDateOfCompletion() -> Date {
        
        let databaseFlashcards = self.databaseFlashcardViewModels.map { flashcardVM in
            flashcardVM.flashcard
        }
        
        let dateOfCompletion = self.getSortedFlashcards(databaseFlashcards)
            .last?.previousDate ?? 0

        /*
        let sortedDbFlashcards: [Flashcard] = self.getSortedFlashcards(databaseFlashcards)
        let sortedUpdatedFlashcards: [Flashcard] = self.getSortedFlashcards(self.updatedFlashcards)

        let dateOfCompletion = sortedUpdatedFlashcards.last?.previousDate ?? sortedDbFlashcards.last?.previousDate ?? 0
        
        */
        
        return Date(timeIntervalSince1970: dateOfCompletion)
    }
    
    func nextDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let nextDate = dateFormatter.string(from: self.getEarliestNextDate())
        return nextDate
    }
    
    func dateOfCompletion() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dateOfCompletion = dateFormatter.string(from: getDateOfCompletion())
        return dateOfCompletion
    }
    
    func reset() {
        self.updatedFlashcards = []
        self.distancesTravelled = [String: CGFloat]()
    }

    //MARK: Changes (to UI)
    func intervalIsZero() -> Bool {
        let intervalZeroFlashcards = updatedFlashcards.filter { flashcard in
            flashcard.nextDate ?? 0 <= self.timeIntervalAsOfClick
        }
        
        return !intervalZeroFlashcards.isEmpty
    }
    
    //Checks for whether or not to show flashcard
    func checkIfFlashcardIsDue(_ flashcard: Flashcard) -> Bool {
        //if nextDate does not exist it means that it has yet to start the algo hence it should return true
        
        //For debug
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        /*
        print("flashcard's nextDate is \(dateFormatter.string(from: Date(timeIntervalSince1970: flashcard.nextDate ?? 0))) and currentDateIs \(dateFormatter.string(from: Date()))")
        */
        return flashcard.nextDate ?? 0 <= self.timeIntervalAsOfClick
    }
    
    //Converts flashcardVM to flashcards
    private func convertFlashcardViewModelToFlashcard(flashcardViewModels: [FlashcardViewModel]) -> [Flashcard] {
        flashcardViewModels.map { flashcardVM in
            flashcardVM.flashcard
        }
    }
    
    //Checks for whether or not to show summary view first or flashcard view first
    func cardsAreDue(flashcards: [FlashcardViewModel]) -> Bool {
        let cardsDue =
            self.getCardViewModelsThatAreDue(from: flashcards)

        return !cardsDue.isEmpty
    }
    
    func getCardViewModelsThatAreDue(from flashcardViewModels: [FlashcardViewModel]) -> [FlashcardViewModel] {
        let cardViewModelsDue = self.convertFlashcardViewModelToFlashcard(flashcardViewModels: flashcardViewModels)
            .filter { flashcard in
                flashcard.nextDate ?? 0 <= self.timeIntervalAsOfClick
            }
            .map { flashcard in
                FlashcardViewModel(flashcard: flashcard)
            }
        
        print("There are \(cardViewModelsDue.count) cards due for study")
        return cardViewModelsDue
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Engine to run the algo
    struct FlashcardGrader {
        private let maxQuality = 2
        private let easinessFactor = 1.3
        
        /**
         Returns flashcard with new interval and repetition
            Only Right/Wrong
            0 - null
            1 - fail
            2 - pass
         */
        func gradeFlashcard(flashcard: Flashcard, grade: Grade, currentDateTime: TimeInterval) -> Flashcard {
            let cardGrade = grade.rawValue
            
            var newFlashcard = flashcard
            
            //Shouldnt be needed but I will add it just in case
            if let _ = flashcard.nextDate {
            } else {
                newFlashcard.nextDate = currentDateTime
            }
            

            if cardGrade == 0 {
                newFlashcard.repetition = 0
                newFlashcard.interval = 0
            } else {
                let qualityFactor = Double(maxQuality - cardGrade)
                
                let newEasinessFactor = flashcard.easinessFactor + (0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))
                
                if newEasinessFactor < easinessFactor {
                    newFlashcard.easinessFactor = easinessFactor
                } else {
                    newFlashcard.easinessFactor = newEasinessFactor
                }
                
                newFlashcard.repetition += 1
                switch flashcard.repetition {
                case 1:
                    newFlashcard.interval = 1
                case 2:
                    newFlashcard.interval = 6
                default:
                    let newInterval = ceil(Double(newFlashcard.repetition - 1) * newFlashcard.easinessFactor)
                    
                    newFlashcard.interval = Int(newInterval)
                }
            }
            
            if cardGrade == 1 {
                newFlashcard.interval = 0
            }
            
            let seconds = 60
            let minutes = 60
            let hours = 24
            let dayMultiplier = seconds * minutes * hours
            let extraDays = dayMultiplier * newFlashcard.interval
            let newNextDateTime = currentDateTime + Double(extraDays) //Time interval since 1970
            
            newFlashcard.previousDate = newFlashcard.nextDate
            newFlashcard.nextDate = newNextDateTime
            
            return newFlashcard
        }
        
        
    }
    enum Grade: Int, CustomStringConvertible {
        //complete blackout
        case null
        //incorrect response
        case fail
        //correct reponse with moderate difficulty
        case pass

        public var description: String {
            switch self {
            case .null:
                return "complete blackout"
            case .fail:
                return "incorrect response"
            case .pass:
                return "correct response with moderate difficulty"
            }
        }
    }
}
