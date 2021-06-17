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
    private let path = "users"
    private let subPath = "decks"
    private let db = Firestore.firestore()
    @Published var decks = [Deck]()

    init() {
        guard let user = Auth.auth().currentUser else { return }
        self.uId = user.uid
        loadData()
    }
    
    func loadData() {
        db.collection(path).document(self.uId)
            .collection(subPath).addSnapshotListener { querySnapshot, error in
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
            _ = try db.collection(path).document(self.uId)
                .collection(subPath).addDocument(from: deck)
        } catch {
            fatalError("Adding deck failed")
        }
    }
    
    func removeData(_ deck: Deck) {
        guard let documentId = deck.id else { return }
        db.collection(path).document(self.uId)
            .collection(subPath).document(documentId).delete { error in
            if let error = error {
                print("Unable to delete deck: \(error.localizedDescription)")
            }
            
        }
    }
    
    func updateData(_ deck: Deck) {
        guard let documentId = deck.id else { return }
        do {
            try db.collection(path).document(self.uId)
                .collection(subPath).document(documentId).setData(from: deck)
        } catch {
            fatalError("Updating deck failed")
        }
    }
}
