//
//  DeckCreationViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import SwiftUI
import Combine

class DeckCreationViewModel: ObservableObject {
    
    static let oneEmptyFlashCard = EmptyFlashcard<String> (question: "", answer: "")
    
    //MARK: Interpret(s) from Model
    @Published private var emptyFlashcards = [EmptyFlashcard<String>] (arrayLiteral: DeckCreationViewModel.oneEmptyFlashCard)
    
    var EmptyFlashcards: [EmptyFlashcard<String>] {
        return emptyFlashcards
    }
    
    //MARK: Intent(s) from View
    
    func addField() {
        emptyFlashcards.append(DeckCreationViewModel.oneEmptyFlashCard)
    }
    
    func removeField(at index: Int) {
        self.emptyFlashcards.remove(at: index)
    }
    
    func editQuestionWith(string: String, at index: Int) {
        emptyFlashcards[index].question = string
    }
    
    func editAnswerWith(string: String, at index: Int) {
        emptyFlashcards[index].answer = string
    }
    
    func createCards() {
        //link to DB
    }
    
    func checkIfAnyFieldsAreEmpty() -> Bool {
        for anyFlashcard in emptyFlashcards {
            if anyFlashcard.question.isEmpty || anyFlashcard.answer.isEmpty {
                return true
            }
        }
        
        return false
    }
}
