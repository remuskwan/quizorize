//
//  User.swift
//  Quizorize
//
//  Created by Remus Kwan on 15/6/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var displayName: String
}

#if DEBUG
//let testDataUsers = [
//    Deck(title: "English"),
//    Deck(title: "Science")
//]
#endif
