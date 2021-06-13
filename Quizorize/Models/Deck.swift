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
    
    //  enum CodingKeys: String, CodingKey {
    //    case id
    //    case title
    //    case author
    //    case numberOfPages = "pages"
    //  }
}

//#if DEBUG
//let testDataDecks(
