//
//  SignupViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 27/5/21.
//

import Foundation

class SignupViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPw = ""
    
    //MARK: - Validation Functions
    
    func passwordsMatch() -> Bool {
        password == confirmPw
    }
    
    //MARK: Field Validities
    
    func isPasswordValid() -> Bool {
        //Criteria is: Pw must be at least 8 characters, no more than 15 characters, and must include at least one upper case letter, one lower case letter, and one numeric digit
        let fieldTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[A-Z]).{8,15}$")
        return fieldTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        //criteria in regx
        let fieldTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return fieldTest.evaluate(with: email)
    }
    
    var isSignUpComplete: Bool {
        if !passwordsMatch() ||
        !isPasswordValid() ||
            !isEmailValid() {
            return false
        }
        
        return true
    }
    
    //MARK: - Validation Prompt Strings
    
    var titlePrompt: String {
        if self.title.isEmpty {
            return ""
        } else {
            return "Enter your display name here"
        }
    }
    
    var confirmPwPrompt: String {
        if passwordsMatch() || self.confirmPw.isEmpty {
            return ""
        } else {
            return "Password fields do not match"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid() || self.email.isEmpty  {
            return ""
        } else {
            return "Enter a valid email address"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid() || self.password.isEmpty{
            return ""
        } else {
            return "Must be between 8 and 15 characters containing at least one number and one capital letter"
        }
    }
    
    
}
