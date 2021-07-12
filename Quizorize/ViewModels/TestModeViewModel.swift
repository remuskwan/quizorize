//
//  TestModeViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 5/7/21.
//

import Foundation
import Combine

class TestModeViewModel: ObservableObject {
    @Published var flashcardRepository: FlashcardRepository
    @Published var testFlashcards = [FlashcardViewModel]()
    
    @Published var counter = 0
    @Published var activeCard = 0
    @Published var correct = 0
    
    @Published var questionCount = 0
    @Published var isTrueFalse = true
    @Published var isMCQ = true
    @Published var isWritten = true
    
    @Published var questionTypes = ["TF": true, "MCQ": true, "Written": true]
    @Published var currentType = ""
    
    @Published var tfOption = ""
    @Published var mcqOptions = [String]()
    
    @Published var latestScore = 0.0
    @Published var hasTakenTest = false
    
    @Published var spacedRepetitionOn = true
    @Published var reminderType = ReminderType.never
    @Published var nextReminderTime: TimeInterval = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    
    var count: Int {
        return self.testFlashcards.count
    }
    
    init(_ deck: Deck) {
        self.flashcardRepository = FlashcardRepository(deck)
        flashcardRepository.$flashcards
            .map { flashcards in
                flashcards.map(FlashcardViewModel.init)
            }
            .assign(to: \.testFlashcards, on: self)
            .store(in: &cancellables)
    }

    func reset() {
        self.activeCard = 0
        self.counter = 0
        self.correct = 0
        self.questionCount = self.count
        self.testFlashcards.shuffle()
    }
    
    func submitAnswer(_ answer: String) {
        if testFlashcards[activeCard].flashcard.answer.lowercased() == answer.lowercased() {
            self.correct += 1
        }
        print(correct)
        self.setMCQOptions()
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
        self.setTrueFalseOption()
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
        questionTypes["TF"] = self.isTrueFalse
        questionTypes["MCQ"] = self.isMCQ
        questionTypes["Written"] = self.isWritten
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
    
    func setMCQOptions() {
        var mcqOptions: [FlashcardViewModel] = []
        mcqOptions.append(contentsOf: testFlashcards)
        mcqOptions.remove(at: activeCard) //remove correct answer
        mcqOptions = Array(mcqOptions.shuffled().prefix(3)) //pick 3 incorrect answers
        mcqOptions.append(testFlashcards[activeCard]) //add correct answer
        self.mcqOptions = mcqOptions.shuffled().map { flashcardVM in
            flashcardVM.flashcard.answer
        } //shuffle answers
        
    }
    
    func setTrueFalseOption() {
        var tfOptions: [FlashcardViewModel] = []
        tfOptions.append(contentsOf: testFlashcards)
        
        self.tfOption = tfOptions.randomElement()?.flashcard.answer ?? ""
    }
    
    func setLatestScore() {
        self.latestScore = Double(self.correct) / Double(self.count)
        self.hasTakenTest = true
    }
    
    func setNextReminderTime() {
        if self.reminderType == ReminderType.never {
            self.nextReminderTime = 0
        } else if self.reminderType == ReminderType.oneDay {
            self.nextReminderTime = 86400
//            self.nextReminderTime = 5
        } else if self.reminderType == ReminderType.threeDays {
            self.nextReminderTime = 259200
        } else if self.reminderType == ReminderType.fiveDays {
            self.nextReminderTime = 432000
        } else if self.reminderType == ReminderType.oneWeek {
            self.nextReminderTime = 604800
        } else if self.reminderType == ReminderType.twoWeeks {
            self.nextReminderTime = 1209600
        } else if self.reminderType == ReminderType.oneMonth {
            self.nextReminderTime = 2592000
        }
    }
    
}
