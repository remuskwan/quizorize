//
//  DeckRepository.swift
//  Quizorize
//
//  Created by Remus Kwan on 1/6/21.
//
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class DeckRepository: ObservableObject {
    private var uId = ""
    private let primaryPath = "users"
    private let subPath = "decks"
    private let subPath2 = "flashcards"
    private let db = Firestore.firestore()
    @Published var decks = [Deck]()
    
    init() {
        guard let user = Auth.auth().currentUser else { return }
        self.uId = user.uid
        loadData()
    }
    
    func loadData() {
        db.collection(primaryPath).document(self.uId)
            .collection(subPath).addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("problem getting query")
                    print(error)
                    return
                }
                if let querySnapshot = querySnapshot {
                    self.decks = querySnapshot.documents.compactMap({ document in
//                        if let flashcard = try? document.data(as: Deck.self) {
//                            return flashcard
//                        } else {
//                            document.reference.updateData([
//                                "isExamMode": false,
//                                "examModePrevScore": 0
//                            ]) { err in
//                                if let err = err {
//                                    print("Error updating Deck")
//                                } else {
//                                    print("Deck successfully updated")
//                                }
//                            }
                        return try? document.data(as: Deck.self)
//                        }
                    })
                }
            }
    }
    
    func addData(deck: Deck, flashcards: [Flashcard]) {
        do {
            let batch = db.batch()
            let userRef = db.collection(primaryPath).document(self.uId)
            let deckDocRef = try userRef.collection(subPath).addDocument(from: deck)
            
            _ = try flashcards.forEach { flashcard in
                let docRef = deckDocRef.collection(subPath2).document()
                _ = try batch.setData(from: flashcard, forDocument: docRef)
            }
            batch.commit()
        } catch {
            fatalError("Adding deck failed")
        }
    }
    
    func removeData(_ deck: Deck) {
        guard let documentId = deck.id else { return }
        db.collection(primaryPath).document(self.uId)
            .collection(subPath).document(documentId).delete { error in
                if let error = error {
                    print("Unable to delete deck: \(error.localizedDescription)")
                }
                
            }
    }
    
    func updateData(_ deck: Deck) {
        guard let documentId = deck.id else { return }
        do {
            try db.collection(primaryPath).document(self.uId)
                .collection(subPath).document(documentId).setData(from: deck, merge: true)
        } catch {
            fatalError("Updating deck failed")
        }
    }
    
    func updateTestPrevScore(deck: Deck, testModePrevScore: Double) {
        guard let documentId = deck.id else { return }
        
        db.collection(primaryPath).document(self.uId)
            .collection(subPath).document(documentId).updateData([
                "testModePrevScore": testModePrevScore
            ])
    }

    func addFlashcardData(_ deck: Deck, flashcards: [Flashcard]) {
        guard let documentId = deck.id else { return }
        do {
            //Get new write batch
            let batch = db.batch()
            
            // Set the reference to flashcards
            let flashcardsRef = db.collection(self.primaryPath)
                .document(self.uId)
                .collection(self.subPath)
                .document(documentId)
                .collection(self.subPath2)
            
            for flashcard in flashcards {
                let flashcardRef = flashcardsRef.document(flashcard.id!)
                batch.setData([
                    "prompt": flashcard.prompt,
                    "answer": flashcard.answer,
                    "dateAdded": flashcard.dateAdded,
                    "repetition": flashcard.repetition,
                    "interval": flashcard.interval,
                    "easinessFactor": flashcard.easinessFactor,
                    "previousDate": flashcard.previousDate,
                    "nextDate": flashcard.nextDate
                ]
                , forDocument: flashcardRef)
            }
            
            batch.commit()
        } catch {
            fatalError("Adding flashcards failed")
        }
    }

    func updateFlashcardsData(_ deck: Deck, flashcards: [Flashcard]) {
        guard let documentId = deck.id else { return }
        do {
            //Get new write batch
            let batch = db.batch()
            
            // Set the reference to flashcards
            let flashcardsRef = db.collection(self.primaryPath)
                .document(self.uId)
                .collection(self.subPath)
                .document(documentId)
                .collection(self.subPath2)
            
            for flashcard in flashcards {
                let flashcardRef = flashcardsRef.document(flashcard.id!)
                batch.updateData([
                    "prompt": flashcard.prompt,
                    "answer": flashcard.answer,
                    "repetition": flashcard.repetition,
                    "interval": flashcard.interval,
                    "easinessFactor": flashcard.easinessFactor,
                    "previousDate": flashcard.previousDate,
                    "nextDate": flashcard.nextDate
                ]
                , forDocument: flashcardRef)
            }
            
            batch.commit()
        } catch {
            fatalError("Updating flashcards failed")
        }
    }
    
    func deleteFlashcardsData(_ deck: Deck, flashcards: [Flashcard]) {
        guard let documentId = deck.id else { return }
        
        do {
            //Get new write batch
            let batch = db.batch()
            
            // Set the reference to flashcards
            let flashcardsRef = db.collection(self.primaryPath)
                .document(self.uId)
                .collection(self.subPath)
                .document(documentId)
                .collection(self.subPath2)
            
            for flashcard in flashcards {
                let flashcardRef = flashcardsRef.document(flashcard.id!)
                batch.deleteDocument(flashcardRef)
            }
            
            batch.commit()
        } catch {
            fatalError("Updating flashcards failed")
        }
    }
}

