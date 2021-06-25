//
//  ProfileViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 25/6/21.
//

import Foundation

class ProfileViewModel: ObservableObject {
    private var userRepository = UserRepository()
    @Published var user: User? = nil
    
    init(_ userId: String) {
        self.user = userRepository.getDataById(userId)
    }
    
}
