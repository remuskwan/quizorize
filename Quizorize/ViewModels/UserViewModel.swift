//
//  UserViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 15/6/21.
//

import Foundation

import Foundation
import FirebaseFirestore
import Combine

class UserViewModel: ObservableObject, Identifiable {
    private var userRepository = UserRepository()
    @Published var user: User
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()

    init(user: User) {
        self.user = user
        $user
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
