//
//  SREngine.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 9/6/21.
//

import Foundation
import UserNotifications


//MARK: Protocol for Spaced repetition algo
//Grade a 'Flashcard' with grade and time
//Parameters:
// - flashcard: Flashcard
// - grade: Grade(enum)
// -currentDateTime: TimeInterval
// - Returns gradedCard: Flashcard
protocol SREngine {
    func gradeFlashcard(flashcard: Flashcard, grade: Grade, currentDateTime: TimeInterval) -> Flashcard
    
}

public struct FlashcardGrader: SREngine {
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
        let newNextDateTime = currentDateTime + Double(extraDays)
        
        newFlashcard.previousDate = flashcard.nextDate
        newFlashcard.nextDate = newNextDateTime
        
        return newFlashcard
    }
    
    
}

//MARK: Grades (modified from SuperMemo Algorithm)
/**
 0 - Complete blackout
 1 - incorrect response
 2 - correct response recalled with moderate difficulty
 3 - correct response with easy difficulty
 */

/*
public enum Grade: Int, CustomStringConvertible {
    //complete blackout
    case null
    //incorrect response
    case fail
    //correct reponse with moderate difficulty
    case pass
    //correct response without difficulty
    case bright
    
    public var description: String {
        switch self {
        case .null:
            return "complete blackout"
        case .fail:
            return "incorrect response"
        case .pass:
            return "correct response with moderate difficulty"
        case .bright:
            return "correct response without difficulty"
        }
    }
}
*/

public enum Grade: Int, CustomStringConvertible {
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
