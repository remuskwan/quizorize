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
    //Front of the flashcard
    @State var flipped: Bool = false
    @State private var question = "Hi"
    @State private var answer = "Bye"
    
    var body: some View {
        //MARK: GeoReader makes this View adaptable
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .fill(flipped ? Color.white : Color.accentColor)
                    .overlay(
                        Text(flipped ? answer : question)
                            .foregroundColor(flipped ? Color.black : Color.white)
                            .font(font(in: geometry.size))
                            .padding()
                            .shadow(radius: 1)
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
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
        static let fontScale: CGFloat = 0.3
    }
}

struct DeckCreationFlashCard_Previews: PreviewProvider {
    static var previews: some View {
        DeckCreationFlashCard()
    }
}
