//
//  SREngine.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 9/6/21.
//

import Foundation


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

//MARK: Grades (modified from SuperMemo Algorithm)
/**
 0 - Complete blackout
 1 - incorrect response
 2 - correct response recalled with moderate difficulty
 3 - correct response with easy difficulty
 */

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
