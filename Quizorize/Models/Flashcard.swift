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
    var dateAdded: Date
    
    static func ==(lhs: Flashcard, rhs: Flashcard) -> Bool {
        lhs.id == rhs.id
    }
    
    
//    enum FlashCardAge: String, Codable {
//        case new
//        case young
//        case mature
//    }
  
//  enum CodingKeys: String, CodingKey {
//    case id
//    case title
//    case author
//    case numberOfPages = "pages"
//  }
}
