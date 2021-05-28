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

class AuthViewModel : NSObject, ObservableObject {
    let auth = Auth.auth()
    
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
        if GIDSignIn.sharedInstance().currentUser == nil {
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
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
    
//    func getUserProfile() -> Profile? {
//        let user = self.user
//        if let user = user {
//            // The user's ID, unique to the Firebase project.
//            // Do NOT use this value to authenticate with your backend server,
//            // if you have one. Use getTokenWithCompletion:completion: instead.
//            let uid = user.uid
//            let email = user.email
//            let photoURL = user.photoURL
//            var multiFactorString = "MultiFactor: "
//            var displayName = ""
//            for info in user.multiFactor.enrolledFactors {
//                displayName = info.displayName ?? "[DisplayName]"
//                multiFactorString += " "
//            }
//            return Profile(email: email, photoURL: photoURL, displayName: displayName)
//        } else {
//            return nil
//        }
//    }
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

struct Profile {
    let email: String?
    let photoURL: URL?
    let displayName: String?
}
