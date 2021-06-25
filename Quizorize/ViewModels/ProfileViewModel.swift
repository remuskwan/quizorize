//
//  ProfileViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 25/6/21.
//

import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    private var userRepository = UserRepository()
    
    func getCurrentUser() -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return userRepository.getDataById(user.uid)
    }
}
