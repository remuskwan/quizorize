//
//  FlashcardRepository.swift
//  Quizorize
//
//  Created by Remus Kwan on 9/6/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FlashcardRepository: ObservableObject {
    private var uId = ""
    private var deckId = ""
    private let path = "users"
    private let subPath = "decks"
    private let subPath2 = "flashcards"
    private let db = Firestore.firestore()
    @Published var flashcards = [Flashcard]()
    
    init(_ deck: Deck) {
        guard let deckId = deck.id else { return }
        self.deckId = deckId
        guard let user = Auth.auth().currentUser else { return }
        self.uId = user.uid
        loadData()
    }
    
    func loadData() {
        db.collection(path).document(self.uId)
            .collection(subPath).document(self.deckId)
            .collection(subPath2).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
            if let querySnapshot = querySnapshot {
                self.flashcards = querySnapshot.documents.compactMap({ document in
                    if let flashcard = try? document.data(as: Flashcard.self) {
                        return flashcard
                    } else {
                        document.reference.updateData([
                            "repetition": 0,
                            "interval": 0,
                            "easinessFactor": 2.5,
                            "previousDate": nil,
                            "nextDate": nil
                        ]) { err in
                            if let err = err {
                                print("Error updating Flashcard")
                            } else {
                                print("Flashcard successfully updatedd")
                            }
                        }
                        
                        return try? document.data(as: Flashcard.self)
                    }
                })
            }
        }
    }
    
    func addData(_ flashcard: Flashcard) {
        do {
            _ = try db.collection(path).document(self.uId)
                .collection(subPath).document(self.deckId)
                .collection(subPath2).addDocument(from: flashcard)
        } catch {
            fatalError("Adding flashcard failed")
        }
    }
    
    func removeData(_ flashcard: Flashcard) {
        guard let documentId = flashcard.id else { return }
        db.collection(path).document(self.uId)
            .collection(subPath).document(self.deckId)
            .collection(subPath2).document(documentId).delete { error in
            if let error = error {
                print("Unable to delete flashcard: \(error.localizedDescription)")
            }
        }
    }
    
    func updateData(_ flashcard: Flashcard) {
        guard let documentId = flashcard.id else { return }
        do {
            try db.collection(path).document(self.uId)
                .collection(subPath).document(self.deckId)
                .collection(subPath2).document(documentId).updateData([
                    "prompt": flashcard.prompt,
                    "answer": flashcard.answer,
                    "repetition": flashcard.repetition,
                    "interval": flashcard.interval,
                    "easinessFactor": flashcard.easinessFactor,
                    "previousDate": flashcard.previousDate,
                    "nextDate": flashcard.nextDate
                ])
        } catch {
            fatalError("Updating deck failed")
        }
    }
}
