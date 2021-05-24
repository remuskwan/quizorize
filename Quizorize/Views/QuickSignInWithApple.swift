//
//  QuickSignInWithApple.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 24/5/21.
//

/**
 Implementing Sign-In with Apple using their default buttons
 */

import SwiftUI
import AuthenticationServices

struct QuickSignInWithApple: UIViewRepresentable {
    //typealias gives a new name for an existing data type(ASAuthorizationAppIDButton -> The sign in image that apple provides)
    typealias UIViewType = ASAuthorizationAppleIDButton
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: Context) -> UIViewType {
        return ASAuthorizationAppleIDButton(type: .continue, style: colorScheme == .dark ? .white : .black)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct QuickSignInWithApple_Previews: PreviewProvider {
    static var previews: some View {
        QuickSignInWithApple()
    }
}
