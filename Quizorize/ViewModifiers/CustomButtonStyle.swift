//
//  CustomButtonStyle.swift
//  Quizorize
//
//  Created by Remus Kwan on 19/7/21.
//

import SwiftUI

struct AuthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .frame(height: 45)
            .font(.headline)
            .foregroundColor(.white)
//            .background(configuration.isPressed ? Color(hex: "15CDA8") : Color.accentColor)
            .background(Color.accentColor
                            .opacity(configuration.isPressed ? 0.3 : 1))
            .cornerRadius(5)
    }
}
