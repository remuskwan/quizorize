//
//  SignupViewModel.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 27/5/21.
//

import Foundation

class SignupViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPw = ""

    @Published private(set) var SignUpError: LocalizedError?
    

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
    
    //MARK: Not sure if Firebase stores names. Else have to use another database like CoreData.
    func isTitleValid() -> Bool {
       return true
    }
    
    var isSignUpComplete: Bool {
        if !passwordsMatch() ||
        !isPasswordValid() ||
            !isEmailValid() ||
            name.isEmpty {
            return false
        }
        
        return true
    }
    
    //MARK: - Validation Prompt Strings
    
    var namePrompt: String {
        if self.name.isEmpty {
            return FieldConstants.emptyString
        } else {
            return FieldConstants.namePromptText
        }
    }
    

    var emailPrompt: String {
        if isEmailValid() || self.email.isEmpty  {
            return FieldConstants.emptyString
        } else {
            return FieldConstants.emailPromptText
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid() || self.password.isEmpty{
            return FieldConstants.emptyString
        } else {
            return FieldConstants.passwordPromptText
        }
    }
    
    var confirmPwPrompt: String {
        if passwordsMatch() || self.confirmPw.isEmpty {
            return FieldConstants.emptyString
        } else {
            return FieldConstants.confirmPwPromptText
        }
    }
    
    //MARK: Toggler for SecureFields if needed
    var passwordTogglerPrompt: String {
        if !self.password.isEmpty {
            return "Reveal password"
        } else {
            return FieldConstants.emptyString
        }
    }

    private struct FieldConstants {
        static let emptyString = """
            
        """
        
        static let namePromptText = """
        Enter your display name here
        
        """
        
        static let emailPromptText = """
        Enter a valid email address
            
        """
        
        static let passwordPromptText = """
        Must be between 8 and 15 characters containing at least one
        number and one capital letter
        """
        
        static let confirmPwPromptText = """
        Password fields do not match
            
        """
    }
    
    
}
