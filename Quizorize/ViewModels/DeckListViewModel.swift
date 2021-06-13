//
//  DeckListViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 8/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class DeckListViewModel: ObservableObject {
    @Published var deckRepository = DeckRepository()
    @Published var decks = [Deck]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        deckRepository.$decks
            .assign(to: \.decks, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ deck: Deck) {
        deckRepository.addData(deck)
    }
//
//      private var db = Firestore.firestore()
//
//      func fetchData() {
//        db.collection("decks").addSnapshotListener { (querySnapshot, error) in
//          guard let documents = querySnapshot?.documents else {
//            print("No documents")
//            return
//          }
//          self.decks = documents.map { queryDocumentSnapshot -> Deck in
//            let data = queryDocumentSnapshot.data()
//            let title = data["title"] as? String ?? ""
//            let isFavorite = data["isFavorite"] as? Bool ?? false
//            return Deck(id: .init(), title: title, isFavorite: isFavorite)
//          }
//        }
//      }
    
}
