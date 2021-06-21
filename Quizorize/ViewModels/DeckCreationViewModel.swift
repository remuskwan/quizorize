//
//  DeckCreationViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 6/6/21.
//

import SwiftUI
import Combine

class DeckCreationViewModel: ObservableObject {
    

    //MARK: Interpret(s) from Model
    @Published private var model: DeckCreationModel = DeckCreationModel(minimumNumberOfCards: 2)

    var flashcards: [DeckCreationModel.EmptyFlashcard] {
        model.flashcards
    }
    
    //MARK: Intent(s) from View
    
    func addFlashcard() {
        model.addFlashcard()
    }
    
    func removeFields(at index: IndexSet) {
        model.removeFields(at: index)
    }
    
    func editPromptWith(string: String, at index: Int) {
        model.editPromptWith(string, at: index)
    }
    
    func editAnswerWith(string: String, at index: Int) {
        model.editAnswerWith(string, at: index)
    }
    
    func getFinalisedFlashcards() -> [Flashcard] {
        model.getFinaliseFlashcards()
    }
    
    func checkIfAnyFieldsAreEmpty() -> Bool {
        for anyFlashcard in flashcards {
            if anyFlashcard.prompt.isEmpty || anyFlashcard.answer.isEmpty {
                return true
            }
        }
        
        return false
    }
}

//MARK: Make views react to keyboard
final class KeyboardResponder: ObservableObject {
    
    private var notificationCenter: NotificationCenter
    
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
       notificationCenter = center
       notificationCenter.addObserver(self, selector:
    #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       notificationCenter.addObserver(self, selector:
    #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
            if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                currentHeight = 0
            }
        }
    @objc func keyBoardWillHide(notification: Notification) {
            currentHeight = 0
        }
    
    deinit {
       notificationCenter.removeObserver(self)
    }
}
