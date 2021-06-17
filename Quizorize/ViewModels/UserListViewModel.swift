//
//  UserListViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 16/6/21.
//

import Foundation
import FirebaseFirestore
import Combine

class UserListViewModel: ObservableObject {
    @Published var userRepository = UserRepository()
    @Published var userViewModels = [UserViewModel]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        userRepository.$users
            .map { users in
                users.map(UserViewModel.init)
            }
            .assign(to: \.userViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ user: User) {
        userRepository.addData(user)
    }
    
    func remove(_ user: User) {
        userRepository.removeData(user)
    }
    
    func update(_ user: User) {
        userRepository.updateData(user)
    }
    
    func searchForVM(_ user: User) -> UserViewModel? {
        userViewModels.filter({ userVM in
            userVM.user.id == user.id
        })
            .first
    }
}
