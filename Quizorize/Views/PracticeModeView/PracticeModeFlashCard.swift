//
//  PracticeModeFlashCard.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 8/6/21.
//

import SwiftUI

struct PracticeModeFlashCard: View {
    //Front of the flashcard
    @State var flipped: Bool = false
    @State private var question = "Hi"
    @State private var answer = "Bye"
    
    var body: some View {
        //MARK: GeoReader makes this View adaptable
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .fill(flipped ? Color.white : Color.purple)
                    .overlay(
                        Text(flipped ? answer : question)
                            .font(font(in: geometry.size ))
                    )
            }
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

struct PracticeModeFlashCard_Previews: PreviewProvider {
    static var previews: some View {
        PracticeModeFlashCard()
    }
}
