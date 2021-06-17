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
    
    @State private var flipped = false
    @State private var question = ""
    @State private var answer = ""
    
    var index: Int
    
    var body: some View {
        //MARK: GeoReader makes this View adaptable
        GeometryReader { geometry in
            VStack {
                TextField("Enter question",
                          text: $question,
                          onEditingChanged: { _ in
                            print(deckCreationVM.flashcards)
                            deckCreationVM.editPromptWith(string: question, at: index)
                          },
                          onCommit: {
                            print(deckCreationVM.flashcards)
                            deckCreationVM.editPromptWith(string: question, at: index)
                          })
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
                TextField("Enter answer",
                          text: $answer,
                          onEditingChanged: { _ in
                            deckCreationVM.editAnswerWith(string: answer, at: index)
                          },
                          onCommit: {
                            deckCreationVM.editAnswerWith(string: answer, at: index)
                          })
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
            }
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
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
        static let fontScale: CGFloat = 0.1
    }
}

struct DeckCreationFlashCard_Previews: PreviewProvider {
    static var previews: some View {
        DeckCreationFlashCard(deckCreationVM: DeckCreationViewModel(), index: 1)
    }
}
