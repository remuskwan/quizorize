//
//  DeckCreationViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import SwiftUI

class DeckCreationViewModel: ObservableObject {
    
    //MARK: Writable data
    @Published private var deckTitle = ""
    @Published private var flashcardFrontContent = ""
    @Published private var flashcardBackContent = ""
    
    
}
