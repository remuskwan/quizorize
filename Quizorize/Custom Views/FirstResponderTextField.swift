//
//  FirstResponderTextField.swift
//  Quizorize
//
//  Created by Remus Kwan on 6/7/21.
//

import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
    }
}

struct FirstResponderTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becameFirstResponder = false
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}
