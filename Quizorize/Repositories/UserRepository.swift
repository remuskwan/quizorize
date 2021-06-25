//
//  UserRepository.swift
//  Quizorize
//
//  Created by Remus Kwan on 15/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let path = "users"
    private let db = Firestore.firestore()
    @Published var users = [User]()

    init() {
        loadData()
    }
    
    func getDataById(_ userId: String) -> User? {
        var user: User?
        db.collection(path).document(userId)
            .addSnapshotListener { querySnapshot, error in
                guard let document = querySnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                user = try? document.data(as: User.self)
            }
        return user
    }
    
    func loadData() {
        db.collection(path).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
            if let querySnapshot = querySnapshot {
                self.users = querySnapshot.documents.compactMap({ document in
                    try? document.data(as: User.self)
                })
            }
        }
    }
    
    func addData(_ user: User) {
        db.collection(path).document(user.id).setData([
            "email": user.email,
            "displayName": user.displayName
        ])
    }
    
    //Hard-delete
    func removeData(_ user: User) {
        db.collection(path).document(user.id).delete { error in
            if let error = error {
                print("Unable to delete user: \(error.localizedDescription)")
            }
        }
    }
    
    func updateData(_ user: User) {
        db.collection(path).document(user.id).setData([
            "email": user.email,
            "displayName": user.displayName
        ])
    }
}
