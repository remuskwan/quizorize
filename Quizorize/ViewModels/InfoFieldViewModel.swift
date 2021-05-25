//
//  InfoFieldViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 25/5/21.
//

import SwiftUI
import Foundation

class InfoFieldViewModel: ObservableObject {
    
    @Published var userInput: String = ""
    var isSensitive: Bool
    
    init(isSensitive: Bool) {
        self.isSensitive = isSensitive
    }
    
    static let Example: InfoFieldViewModel = InfoFieldViewModel(isSensitive: true)
}
