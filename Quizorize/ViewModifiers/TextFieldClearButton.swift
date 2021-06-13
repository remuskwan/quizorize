//
//  TextFieldClearButton.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
//    @Binding var isEditing: Bool
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}

/*
struct SecureFieldClearButton: ViewModifier {
    @Binding var text: String
    @Binding var isVisible: Bool
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button {
                    self.text = ""
                    self.isVisible = false
                } label: {
                    
                }
            }
            
        }
    }
}
 */

