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
    
    @ObservedObject var deckCreationVM: DeckCreationViewModel
    
    @State private var isQuestionTapped = false
    @State private var isAnswerTapped = false
    @State private var question = ""
    @State private var answer = ""
    
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

            
            /*
             .foregroundColor(Color.white)
             .font(font(in: geometry.size))
             .shadow(radius: 1)
             .padding()
             .background(Color.accentColor)
             .cornerRadius(DrawingConstants.cornerRadius)
             .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
             .shadow(color: flipped ? Color.black.opacity(0) : Color.black
             .opacity(0.2), radius: 5, x: 0, y: 2)
             */
            /*
             .foregroundColor(Color.white)
             .font(font(in: geometry.size))
             .shadow(radius: 1)
             .padding()
             .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
             .background(Color.accentColor)
             .cornerRadius(DrawingConstants.cornerRadius)
             .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
             .shadow(color: flipped ? Color.black.opacity(0) : Color.black
             .opacity(0.2), radius: 5, x: 0, y: 2)
             */
            /*
             ZStack {
             RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
             .fill(flipped ? Color.white : Color.accentColor)
             .overlay(
             TextField("Enter question",
             text: flipped ? $answer : $question,
             onEditingChanged: { _ in
             flipped ? deckCreationVM.editAnswerWith(string: answer, at: index) :
             deckCreationVM.editQuestionWith(string: question, at: index)
             },
             onCommit: {
             flipped ? deckCreationVM.editAnswerWith(string: answer, at: index) :
             deckCreationVM.editQuestionWith(string: question, at: index)
             })
             .foregroundColor(flipped ? Color.black : Color.white)
             .font(font(in: geometry.size))
             .padding()
             .shadow(radius: 1)
             
             /*
             Text(flipped ? answer : question)
             .foregroundColor(flipped ? Color.black : Color.white)
             .font(font(in: geometry.size))
             .padding()
             .shadow(radius: 1)
             */
             )
             .onTapGesture {
             withAnimation {
             flipped.toggle()
             }
             }
             }
             .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
             .shadow(color: flipped ? Color.black.opacity(0) : Color.black
             .opacity(0.2), radius: 5, x: 0, y: 2)
             */
        }
    }
    
    var PromptAndQuestionContainer: some View {
        
        RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            .fill(Color.white)

    }
    var questionBody: some View {
        
        
        TextField(StringConstants.promptPlaceholder,
                  text: $question,
                  onEditingChanged: { edit in
                    withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                        isQuestionTapped = edit
                    }
                    print(deckCreationVM.flashcards)
                    deckCreationVM.editPromptWith(string: question, at: index)
                  },
                  onCommit: {
                    print(deckCreationVM.flashcards)
                    deckCreationVM.editPromptWith(string: question, at: index)
                  })
            .font(.body)
            .textFieldStyle(CustomTextFieldStyle(isFieldTapped: $isQuestionTapped, captionTitle: StringConstants.promptTitle, imageName: "question"))
        
        /*
        VStack {
            TextField(StringConstants.promptPlaceholder,
                      text: $question,
                      onEditingChanged: { edit in
                        withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                            isQuestionTapped = edit
                        }
                        print(deckCreationVM.flashcards)
                        deckCreationVM.editPromptWith(string: question, at: index)
                      },
                      onCommit: {
                        print(deckCreationVM.flashcards)
                        deckCreationVM.editPromptWith(string: question, at: index)
                      })
                .font(.body)

            Rectangle().frame(height: DrawingConstants.rectWidth)
                .foregroundColor(isQuestionTapped ? DrawingConstants.tappedColor : DrawingConstants.notTappedColor )
            
            HStack {
                Text(StringConstants.promptTitle)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                Spacer()
            }

        }
        */

    }
    
    var answerBody: some View {
        TextField(StringConstants.answerPlaceholder,
                  text: $answer,
                  onEditingChanged: { edit in
                    withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                        isAnswerTapped = edit
                    }
                    deckCreationVM.editAnswerWith(string: answer, at: index)
                  },
                  onCommit: {
                    deckCreationVM.editAnswerWith(string: answer, at: index)
                  })
            .font(.body)
            .textFieldStyle(CustomTextFieldStyle(isFieldTapped: $isAnswerTapped, captionTitle: StringConstants.answerTitle, imageName: "answer"))

        /*
        VStack {
            TextField(StringConstants.answerPlaceholder,
                      text: $answer,
                      onEditingChanged: { edit in
                        withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                            isAnswerTapped = edit
                        }
                        deckCreationVM.editAnswerWith(string: answer, at: index)
                      },
                      onCommit: {
                        deckCreationVM.editAnswerWith(string: answer, at: index)
                      })
                .font(.body)

            Rectangle().frame(height: DrawingConstants.rectWidth)
        .foregroundColor(isAnswerTapped ? DrawingConstants.tappedColor : DrawingConstants.notTappedColor)
            
            HStack {
                Text(StringConstants.answerTitle)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        */
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

struct DeckCreationFlashCard_Previews: PreviewProvider {
    static var previews: some View {
        DeckCreationFlashCard(deckCreationVM: DeckCreationViewModel(), index: 1)
    }
}
