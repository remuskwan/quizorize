//
//  DeckCreationFlashCard.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 8/6/21.
//

import SwiftUI

//MARK: Adaptable Flashcard view for deck creation
//Includes: 
struct DeckCreationFlashCard: View {
    
    var deckCreationVM: DeckCreationViewModel
    
    @State private var isQuestionTapped = false
    @State private var isAnswerTapped = false
    @State var question: String
    @State var answer: String
    
    var index: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {

                VStack {

                    questionBody

                    answerBody
                }
                .padding()

            }
        }
    }
    
    var PromptAndQuestionContainer: some View {
        
        RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            .fill(Color.white)

    }
    
    var questionBody: some View {
        
        
        TextField(StringConstants.promptPlaceholder,
                  text: Binding(get: {self.deckCreationVM.flashcards[self.index].prompt},
                                set: {self.deckCreationVM.flashcards[self.index].prompt = $0}),
                  onEditingChanged: { edit in
                    withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                        isQuestionTapped = edit
                    }
                  }
                )
                  
            .font(.body)
            .textFieldStyle(CustomTextFieldStyle(isFieldTapped: $isQuestionTapped, captionTitle: StringConstants.promptTitle, imageName: "question"))
    }
    
    var answerBody: some View {
        TextField(StringConstants.answerPlaceholder,
                  text: Binding(get: {self.deckCreationVM.flashcards[self.index].answer},
                                set: {self.deckCreationVM.flashcards[self.index].answer = $0}),
                  onEditingChanged: { edit in
                    withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                        isAnswerTapped = edit
                    }
                  }
                )
            .font(.body)
            .textFieldStyle(CustomTextFieldStyle(isFieldTapped: $isAnswerTapped, captionTitle: StringConstants.answerTitle, imageName: "answer"))
    }

    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let heightMultiplier: CGFloat = 1
        static let cornerRadius: CGFloat = 6
        static let lineWidth: CGFloat = 1.5
        static let fontScale: CGFloat = 0.1
        
        static let easeInDuration: Double = 0.1
    }
    
    private struct StringConstants {
        static let promptPlaceholder = "Enter prompt"
        static let promptTitle = "PROMPT"
        
        static let answerPlaceholder = "Enter answer"
        static let answerTitle = "ANSWER"
    }
}

