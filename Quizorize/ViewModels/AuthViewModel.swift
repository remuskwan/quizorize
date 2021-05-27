//
//  AuthViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 23/5/21.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import GoogleSignIn

class AuthViewModel : ObservableObject {
    let auth = Auth.auth()
    
    @Published var signedIn = false
    @Published private(set) var activeError: LocalizedError?
    
    @State var currentNonce:String?
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(get: {
            return self.activeError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.activeError = nil
        })
    }
    
    enum SignInMethod {
        case signInWithEmail(email: String, password: String)
        case signInWithGoogle
    }
    
    func signIn(with signInMethod: SignInMethod) {
        self.activeError = nil
        
        switch signInMethod {
        case let .signInWithEmail(email, password):
            handleSignInWithEmail(email: email, password: password)
        case . signInWithGoogle:
            handleSignInWithGoogle()
        }
    }
    
    private func handleSignInWithEmail(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                guard error == nil else {
                    print((error?.localizedDescription)!)
                    self?.handleErrors(error: error, email: email)
                    return
                }
                return //TODO
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    private func handleSignInWithGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // from https://firebase.google.com/docs/auth/ios/apple
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                guard error == nil else {
                    print((error?.localizedDescription)!)
                    self?.handleErrors(error: error, email: email)
                    return
                }
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
    
    private func handleErrors(error: Error?, email: String) {
        let errorCode = AuthErrorCode(rawValue: (error as NSError?)!.code)
        switch errorCode {
        case .wrongPassword:
            //fetch sign in methods previously used for provided email address
            auth.fetchSignInMethods(forEmail: email) { result, error in
                guard result == nil, error == nil else {
                    //if result is not empty and there is no error, set the activeError to emailInUseByDifferentProvider
                    self.activeError = SignInError.wrongProvider(provider: result![0])
                    return
                }
                //else set activeError to wrongPassword
                self.activeError = SignInError.wrongPassword
            }
        case .invalidEmail:
            self.activeError = SignInError.invalidEmail
        case .emailAlreadyInUse:
            //fetch sign in methods previously used for provided email address
            auth.fetchSignInMethods(forEmail: email) { result, error in
                guard result == nil, error == nil else {
                    //if result is not empty and there is no error, set the activeError to emailInUseByDifferentProvider
                    self.activeError = SignUpError.emailInUseByDifferentProvider(provider: result![0])
                    return
                }
                //else set activeError to emailAlreadyInUse
                self.activeError = SignUpError.emailAlreadyInUse
            }
        case .userNotFound:
            self.activeError = EmailVerificationError.userNotFound
        default:
            self.activeError = SignInError.unknown
        }
    }
}
