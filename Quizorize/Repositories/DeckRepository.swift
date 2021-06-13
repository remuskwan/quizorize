//
//  DeckRepository.swift
//  Quizorize
//
//  Created by Remus Kwan on 1/6/21.
//
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class DeckRepository: ObservableObject {
    private let path = "decks"
    private let db = Firestore.firestore()
    @Published var decks = [Deck]()

    init() {
        loadData()
    }
    
    func loadData() {
        db.collection(path).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
            if let querySnapshot = querySnapshot {
                self.decks = querySnapshot.documents.compactMap({ document in
                    try? document.data(as: Deck.self)
                })
            }
            print(self.decks)
        }
    }
    
    func addData(_ deck: Deck) {
        do {
            _ = try db.collection(path).addDocument(from: deck)
        } catch {
            fatalError("Adding deck failed")
        }
    }
}
