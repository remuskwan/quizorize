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
import FirebaseFirestore

class AuthViewModel : NSObject, ObservableObject {
    let auth = Auth.auth()
    let db = Firestore.firestore()
    private var userRepository = UserRepository()
    
    @Published var signedIn = false
    @Published var user = Auth.auth().currentUser
    @Published private(set) var activeError: LocalizedError?
    
    @State var currentNonce:String?
    
    var isSignedIn: Bool {
        return user != nil
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
    
    override init() {
        super.init()
        
        GIDSignIn.sharedInstance().delegate = self
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
                print((error?.localizedDescription)!)
                self?.handleErrors(error: error, email: email)
                return
                    //TODO: update credential
            }
//            if let result = result {
//                guard result.user.isEmailVerified else {
//                    self?.activeError = SignUpError.userNotVerified
//                    return
//                }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
//            }
        }
    }
    
    private func handleSignInWithGoogle() {
        if GIDSignIn.sharedInstance().currentUser == nil {
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
//            Auth.auth().addStateDidChangeListener { auth, user in
//                if let user = user {
//                    user.
//                }
//            }
        }
    }
    
    func signUp(email: String, password: String, displayName: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                guard error == nil else {
                    print((error?.localizedDescription)!)
                    self?.handleErrors(error: error, email: email)
                    return
                }
                return
            }
//            let changeRequest = self?.user?.createProfileChangeRequest()
//            changeRequest?.displayName = displayName
//            changeRequest?.commitChanges(completion: { error in
//                guard error == nil else {
//                    print((error?.localizedDescription)!)
//                    return
//                }
//            })
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
        auth.addStateDidChangeListener { _, user in
            if let user = user {
//                if !user.isEmailVerified {
//                    self.activeError = SignUpError.userNotVerified
//                    user.sendEmailVerification { error in
//                        guard let error = error else {
//                            return
//                        }
//                        self.handleErrors(error: error, email: email)
//                    }
//                }
                self.userRepository.addData(User(id: user.uid, email: email, displayName: displayName))
            }
        }
//        print(self.user?.uid)
    }
    
    func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try auth.signOut()
            self.signedIn = false
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
        
    }
    
    func forgotPassword(email: String) {
        auth.useAppLanguage()
        auth.sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                print((error?.localizedDescription)!)
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
                    return self.activeError = SignInError.wrongProvider(provider: result![0])	
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
                    return self.activeError = SignUpError.emailInUseByDifferentProvider(provider: result![0])
                }
                //else set activeError to emailAlreadyInUse
                self.activeError = SignUpError.emailAlreadyInUse
            }
        case .userNotFound:
            self.activeError = EmailVerificationError.userNotFound
        case .tooManyRequests:
            self.activeError = EmailVerificationError.tooManyRequests	
        default:
            self.activeError = SignInError.unknown
        }
    }
    func updateProfile(user: User) {
        let changeRequest = self.user?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.commitChanges { error in
            guard error == nil else {
                return print((error?.localizedDescription)!)
            }
        }
    }
    func updateEmail(email: String) {
        self.user?.updateEmail(to: email) { error in
            guard error == nil else {
                return print((error?.localizedDescription)!)
            }
        }
    }
}

extension AuthViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                print("The user you're trying to sign in with has already been linked")
                if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                    print("Signing in using updated credential")
                    Auth.auth().signIn(with: updatedCredential) { result, error in
                        if let user = result?.user {
                            self.signedIn = true
                        }
                    }
                }
            }
            //Sign In failure
            guard result != nil, error == nil else {
                print((error?.localizedDescription)!)
                return
            }
            self.signedIn = true
            //print(result?.user.email)
        }
    }
}
