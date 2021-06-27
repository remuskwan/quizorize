//
//  UserRepository.swift
//  Quizorize
//
//  Created by Remus Kwan on 15/6/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let path = "users"
    private let db = Firestore.firestore()
    @Published var users = [User]()

    init() {
        loadData()
//        guard let user = Auth.auth().currentUser else { return }
    }
    
    func getDataById(_ userId: String) -> User? {
        var user: User? = nil
        db.collection(path).document(userId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                user = User(id: userId, email: data["email"] as? String ?? "", displayName: data["displayName"] as? String ?? "")
                print("Current data: \(data)")
            }
        print(user)
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
