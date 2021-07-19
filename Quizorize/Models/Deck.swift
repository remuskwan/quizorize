//
//  Deck.swift
//  Quizorize
//
//  Created by Remus Kwan on 1/6/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Deck: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var isFavorite: Bool = false
    var dateCreated: Date = Date()
    
    //MARK: SR Algo
    var isExamMode: Bool = false
    var examModePrevScore: Double = 0
}

#if DEBUG
let testDataDecks = [
    Deck(title: "English"),
    Deck(title: "Science")
]
#endif
