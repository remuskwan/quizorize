//
//  Flashcard.swift
//  Quizorize
//
//  Created by Remus Kwan on 1/6/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Flashcard: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var prompt: String
    var answer: String
//    var flashCardAge: FlashCardAge
    var dateAdded: Date = Date()
    
    //MARK: SR Algo vars
    var repetition = 0
    var interval = 0
    var easinessFactor = 2.5
    var previousDate: TimeInterval?
    var nextDate: TimeInterval?

    static func ==(lhs: Flashcard, rhs: Flashcard) -> Bool {
        lhs.id == rhs.id
    }
    
    
//    enum FlashCardAge: String, Codable {
//        case new
//        case young
//        case mature
//    }
    
    /*
    init(id: UUID, dateAdded: Date) {
        self.prompt = Initialisers.promptInit
        self.answer = Initialisers.answerInit
        
        self.id = id.uuidString
        self.dateAdded = dateAdded
    }

    private struct Initialisers {
        static let promptInit = ""
        static let answerInit = ""
    }
    */
}
