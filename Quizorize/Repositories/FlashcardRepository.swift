//
//  FlashcardRepository.swift
//  Quizorize
//
//  Created by Remus Kwan on 9/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FlashcardRepository: ObservableObject {
    private let path = "flashcards"
    private let db = Firestore.firestore()
    @Published var flashcards = [Flashcard]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        db.collection("flashcards").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
            if let querySnapshot = querySnapshot {
                self.flashcards = querySnapshot.documents.compactMap({ document in
                    try? document.data(as: Flashcard.self)
                })
            }
        }
    }
    
    func addData(_ flashcard: Flashcard) {
        do {
            _ = try db.collection(path).addDocument(from: flashcard)
        } catch {
            fatalError("Adding deck failed")
        }
    }
}
