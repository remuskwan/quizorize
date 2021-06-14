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
        }
    }
    
    func addData(_ deck: Deck) {
        do {
            _ = try db.collection(path).addDocument(from: deck)
        } catch {
            fatalError("Adding deck failed")
        }
    }
    
    func removeData(_ deck: Deck) {
        guard let documentId = deck.id else { return }
        db.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Unable to delete deck: \(error.localizedDescription)")
            }
            
        }
    }
    
    func updateData(_ deck: Deck) {
        guard let documentId = deck.id else { return }
        do {
            try db.collection(path).document(documentId).setData(from: deck)
        } catch {
            fatalError("Updating deck failed")
        }
    }
}
