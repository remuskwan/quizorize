//
//  ExamModeViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 11/7/21.
//

import Foundation

class ExamModeViewModel: ObservableObject {
    
    init() {
        self.updatedFlashcards = []
        self.flashcardGrader = FlashcardGrader()
    }
    
    private var updatedFlashcards: [Flashcard]
    private var flashcardGrader: FlashcardGrader
    
    //MARK: Intent(s)
    func addAndUpdateFailed(_ currentFlashcard: Flashcard) {
        let updatedFlashcard = self.flashcardGrader.gradeFlashcard(flashcard: currentFlashcard, grade: ExamModeViewModel.Grade.fail, currentDateTime: Date().timeIntervalSince1970)
        
        self.updatedFlashcards.append(updatedFlashcard)
    }
    
    func addAndUpdatePassed(_ currentFlashcard: Flashcard) {
        let updatedFlashcard = self.flashcardGrader.gradeFlashcard(flashcard: currentFlashcard, grade: ExamModeViewModel.Grade.pass, currentDateTime: Date().timeIntervalSince1970)
        
        self.updatedFlashcards.append(updatedFlashcard)
    }
    
    //Helper for Date in String
    private func getEarliestNextDate() -> Date {
        let sortedUpdatedFlashcards: [Flashcard] = updatedFlashcards.sorted {
            $0.nextDate! < $1.nextDate!
        }
        
        let earliestDate = sortedUpdatedFlashcards.first!.nextDate!
        
        return Date(timeIntervalSince1970: earliestDate)
    }
    
    func nextDate() -> String {
        let nextDate = DateFormatter().string(from: self.getEarliestNextDate())
        
        return nextDate
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
                newFlashcard.nextDate = flashcard.dateAdded.timeIntervalSince1970
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
