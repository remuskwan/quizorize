//
//  AuthViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 23/5/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

class AuthViewModel : ObservableObject {
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    func signIn(email: String, password: String) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        }
    }
    
    func signInWithGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
        
        self.signedIn = true
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
        try? auth.signOut()
        
        self.signedIn = false
    }
    
    func forgotPassword(email: String) {
        auth.useAppLanguage()
        auth.sendPasswordReset(withEmail: email) { error in
            guard error != nil else {
                return
            }
        }
    }
}
