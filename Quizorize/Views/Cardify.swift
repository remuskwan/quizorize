//
//  Cardify.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 11/6/21.
//

import SwiftUI

struct Cardify: ViewModifier {
    init(isFlipped: Bool) {
        rotation = isFlipped ? 0 : 180
    }
    
    var rotation: Double //rotation in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill(Color.white)
            } else {
                shape.fill(Color.accentColor)
            }
            content
        }
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .shadow(color: rotation < 90 ? Color.black.opacity(0) : Color.black
                    .opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
    }
}

extension View {
    func cardify(isFlipped: Bool) -> some View {
        self.modifier(Cardify(isFlipped: isFlipped))
    }
}
