//
//  ExamModeViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 11/7/21.
//

import Foundation
import SwiftUI

//MARK: Only flashcards that have finished grading will be passed here.
class ExamModeViewModel: ObservableObject {
    
    //Do an init and pass existing flashcards to filter out which ones should be tested.
    //Only pass in flashcards to this ViewModel whereby Date().timeIntervalSince1970 - flashcard.nextDate <= 0
    
    
    init(isExamMode: Bool) {
        self.updatedFlashcards = []
        self.flashcardGrader = FlashcardGrader()
        self.isExamMode = isExamMode
    }
    
    private(set) var distancesTravelled: [String: CGFloat] = [String: CGFloat]()
    private var updatedFlashcards: [Flashcard] //Should only have flashcards that are updated
    private var flashcardGrader: FlashcardGrader
    
    @Published private(set) var isExamMode: Bool
    
    private var correctCount: Double = 0

    //MARK: Intent(s)
    
    //Toggle ExamMode (while user still inside practice)
    func turnOffExamMode() {
        self.isExamMode = false
    }
    
    //Set the translation width of a flashcard
    func setTranslationWidthOf(id: String, width: CGFloat) {
        self.distancesTravelled[id] = width
    }
    
    func addAndUpdateFailed(_ currentFlashcard: Flashcard) {
        let updatedFlashcard = self.flashcardGrader.gradeFlashcard(flashcard: currentFlashcard, grade: ExamModeViewModel.Grade.fail, currentDateTime: Date().timeIntervalSince1970)
        
        self.updatedFlashcards.append(updatedFlashcard)
    }
    
    func addAndUpdatePassed(_ currentFlashcard: Flashcard) {
        let updatedFlashcard = self.flashcardGrader.gradeFlashcard(flashcard: currentFlashcard, grade: ExamModeViewModel.Grade.pass, currentDateTime: Date().timeIntervalSince1970)
        
        self.updatedFlashcards.append(updatedFlashcard)
        self.correctCount += 1
    }
    
    func getPercentageScore() -> Double {
        correctCount / Double(updatedFlashcards.count)
    }
    
    private func getSortedFlashcards() -> [Flashcard] {
        updatedFlashcards.sorted {
            $0.nextDate! < $1.nextDate!
        }
    }
    
    //Helper for Date in String
    private func getEarliestNextDate() -> Date {
        let sortedUpdatedFlashcards: [Flashcard] = self.getSortedFlashcards()
        
        let earliestDate = sortedUpdatedFlashcards.first!.nextDate ?? 0
        
        return Date(timeIntervalSince1970: earliestDate)
    }
    
    private func getDateOfCompletion() -> Date {
        let sortedUpdatedFlashcards: [Flashcard] = self.getSortedFlashcards()
        
        let dateOfCompletion = sortedUpdatedFlashcards.last!.previousDate ?? 0
        
        return Date(timeIntervalSince1970: dateOfCompletion)
    }
    
    func nextDate() -> String {
        let nextDate = DateFormatter().string(from: self.getEarliestNextDate())
        
        return nextDate
    }
    
    func dateOfCompletion() -> String {
        let dateOfCompletion = DateFormatter().string(from: getDateOfCompletion())
        
        return dateOfCompletion
    }
    
    func reset() {
        self.updatedFlashcards = []
        self.correctCount = 0
        self.distancesTravelled = [String: CGFloat]()
    }
    
    //MARK: Changes (to UI)
    func intervalIsZero() -> Bool {
        let totalSecondsInADay: Double = 86400
        let intervalZeroFlashcards = updatedFlashcards.filter { flashcard in
            (flashcard.nextDate ?? 0) - (flashcard.previousDate ?? 0) < totalSecondsInADay
        }
        
        return !intervalZeroFlashcards.isEmpty
    }
    
    func checkIfFlashcardIsDue(_ flashcard: Flashcard) -> Bool {
        //if nextDate does not exist it means that it has yet to start the algo hence it should return true
        flashcard.nextDate ?? 0 <= Date().timeIntervalSince1970
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
                newFlashcard.nextDate = Date().timeIntervalSince1970
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
            
            newFlashcard.previousDate = flashcard.nextDate
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
