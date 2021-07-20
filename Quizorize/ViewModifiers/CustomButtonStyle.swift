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
            .background(Color.accentColor)
            .cornerRadius(5)
    }
}
