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
    
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    private var uuid: String
    var body: some View {
        //MARK: GeoReader makes this View adaptable
        GeometryReader { geometry in
            ZStack {
                Text(practiceModeViewModel.getFlipStatusOf(uuid: uuid) ? answer : question)
                    .foregroundColor(flipped ? Color.black : Color.white)
                    .font(font(in: geometry.size))
                    .padding()
                    .shadow(radius: 1)
            }
            .cardify()
            .onTapGesture {
                withAnimation {
                    practiceModeViewModel.toggleFlipStatusOf(uuid: uuid)
                }
            }
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.3
    }
}
