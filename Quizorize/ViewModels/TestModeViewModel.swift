//
//  TestModeViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 5/7/21.
//

import Foundation
import Combine

class TestModeViewModel: ObservableObject {
    @Published var testFlashcards: [FlashcardViewModel]
    @Published var counter: Int
    @Published var activeCard: Int = 0
    @Published var correct = 0
    
    @Published var questionCount = 0
    @Published var isTrueFalse = true
    @Published var isMCQ = true
    @Published var isWritten = true
    
    @Published var questionTypes = ["TF": true, "MCQ": true, "Written": true]
    @Published var currentType = ""
    
    @Published var tfOption = ""
    
    var count: Int {
        return self.testFlashcards.count
    }
    
    init(_ testFlashcards: [FlashcardViewModel]) {
        self.testFlashcards = testFlashcards.shuffled()
        self.counter = 0
    }
    
    func reset() {
        self.activeCard = 0
    }
    
    func submitAnswer(_ answer: String) {
        if testFlashcards[activeCard].flashcard.answer.lowercased() == answer.lowercased() {
            self.correct += 1
        }
        print(correct)
        self.nextCard()
    }
    
    func submitTFAnswer(_ answer: Bool) {
        if answer {
            if self.tfOption == self.testFlashcards[activeCard].flashcard.answer {
                self.correct += 1
            }
        } else {
            if self.tfOption != self.testFlashcards[activeCard].flashcard.answer {
                self.correct += 1
            }
        }
        print(correct)
        self.nextCard()
    }
    
    func nextCard() {
        self.setCurrentType()
        self.counter += 1
        if self.counter < self.count {
            self.activeCard += 1
        }
    }
    
    func setQuestionTypes() {
        if !self.isTrueFalse {
            questionTypes["TF"] = false
        }
        if !self.isMCQ {
            questionTypes["MCQ"] = false
        }
        if !self.isWritten {
            questionTypes["Written"] = false
        }
    }
    
    func setCurrentType() {
        self.currentType = questionTypes
            .filter { $0.value == true }
            .keys
            .randomElement() ?? ""
    }
    
    func setQuestionCount() {
        self.testFlashcards = Array(self.testFlashcards.shuffled()[..<self.questionCount])
    }
    
    func getMCQOptions() -> [String] {
        var mcqOptions: [FlashcardViewModel] = []
        mcqOptions.append(contentsOf: testFlashcards)
        mcqOptions.remove(at: activeCard) //remove correct answer
        mcqOptions = Array(mcqOptions.shuffled().prefix(3)) //pick 3 incorrect answers
        mcqOptions.append(testFlashcards[activeCard]) //add correct answer
        return mcqOptions.shuffled().map { flashcardVM in
            flashcardVM.flashcard.answer
        } //shuffle answers
        
    }
    
    func setTrueFalseOption() {
        var tfOptions: [FlashcardViewModel] = []
        tfOptions.append(contentsOf: testFlashcards)
        
        self.tfOption = tfOptions.randomElement()?.flashcard.answer ?? ""
    }
}
