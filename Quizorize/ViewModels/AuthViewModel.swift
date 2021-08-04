//
//  AuthViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 23/5/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import Promises

class AuthViewModel : NSObject, ObservableObject {
    let auth = Auth.auth()
    let db = Firestore.firestore()
    private var userRepository = UserRepository()
    
    @Published var signedIn = false
    @Published private(set) var activeError: LocalizedError?
    @Published var userEmail = ""
    
    
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
    
    override init() {
        super.init()
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func setUserEmail() {
        self.userEmail = auth.currentUser?.email ?? ""
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
                print((error?.localizedDescription)!)
                self?.handleErrors(error: error, email: email)
                return
                    //TODO: update credential
            }
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
            let changeRequest = self?.auth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges(completion: { error in
                guard error == nil else {
                    print((error?.localizedDescription)!)
                    return
                }
            })
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
        auth.addStateDidChangeListener { _, user in
            if let user = user {
                self.userRepository.addData(User(id: user.uid, email: email, displayName: displayName))
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
            auth.fetchSignInMethods(forEmail: email) { result, error in
                if error == nil {
                    if let result = result {
                        if result.contains("apple.com") || result.contains("google.com") {
                            self.activeError = SignInError.wrongProvider(provider: result[0])
                        } else {
                            self.activeError = SignInError.wrongPassword
                        }
                    }
                }
            }
//            self.activeError = SignInError.wrongPassword
        case .invalidEmail:
            self.activeError = SignInError.invalidEmail
        case .emailAlreadyInUse:
            //fetch sign in methods previously used for provided email address
            auth.fetchSignInMethods(forEmail: email) { result, error in
                if error == nil {
                    if let result = result {
                        if result.contains("apple.com") || result.contains("google.com") {
                            self.activeError = SignUpError.emailInUseByDifferentProvider(provider: result[0])
                        } else {
                            self.activeError = SignUpError.emailAlreadyInUse
                        }
                    }
                }
            }
        
        case .userNotFound:
            self.activeError = EmailVerificationError.userNotFound
        case .tooManyRequests:
            self.activeError = EmailVerificationError.tooManyRequests
//        case .requiresRecentLogin:
//            self.activeError = UpdateProfileError.requiresRecentLogin
        case .credentialAlreadyInUse:
            if let updatedCredential = (error as NSError?)!.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                print("Signing in using updated credential")
                Auth.auth().signIn(with: updatedCredential) { result, error in
                    if let user = result?.user {
                        self.signedIn = true
                    }
                }
            }
        default:
            self.activeError = SignInError.unknown
        }
    }
    
    private func handleErrors(error: Error?) {
        let errorCode = AuthErrorCode(rawValue: (error as NSError?)!.code)
        print(errorCode)
        switch errorCode {
        case .wrongPassword:
            //fetch sign in methods previously used for provided email address
            self.activeError = SignInError.wrongPassword
        case .invalidEmail:
            self.activeError = SignInError.invalidEmail
        case .userNotFound:
            self.activeError = EmailVerificationError.userNotFound
//        case .tooManyRequests:
//            self.activeError = EmailVerificationError.tooManyRequests
//        case .requiresRecentLogin:
//            self.activeError = UpdateProfileError.requiresRecentLogin
        case .credentialAlreadyInUse:
            if let updatedCredential = (error as NSError?)!.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                print("Signing in using updated credential")
                Auth.auth().signIn(with: updatedCredential) { result, error in
                    if let user = result?.user {
                        self.signedIn = true
                    }
                }
            }
        default:
            self.activeError = SignInError.unknown
        }
    }
    
    func canChangeCredentials() -> Promise<Bool> {
        return Promise<Bool>(on: .global(qos: .background)) { fulfill, reject in
            self.auth.fetchSignInMethods(forEmail: self.auth.currentUser?.email ?? "") { result, error in
                if let error = error {
                    reject(error)
                }
                if result != nil {
                    if let result = result {
                        if result.contains("apple.com") || result.contains("google.com") {
                            self.activeError = UpdateProfileError.emailInUseByDifferentProvider(provider: result[0])
                            fulfill(false)
                        } else {
                            fulfill(true)
                        }
                    }
                }
            }
        }
    }
    
    func updateProfile(user: User) {
        let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.commitChanges { error in
            guard error == nil else {
                return print((error?.localizedDescription)!)
            }
        }
    }
    func updateEmail(email: String) -> Promise<Bool> {
        return Promise<Bool>(on: .global(qos: .background)) { fulfill, reject in
            let fieldTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            if fieldTest.evaluate(with: email) {
                self.auth.currentUser?.updateEmail(to: email) { error in
                    if let error = error {
                        self.handleErrors(error: error, email: email)
                        reject(error)
                    } else {
                        fulfill(true)
                    }
                }
            } else {
                self.activeError = ValidateCredentialError.emailPoorlyFormatted
            }
        }
    }
    
    func updatePassword(password: String, confirmPassword: String) -> Promise<Bool> {
        return Promise<Bool>(on: .global(qos: .background)) { fulfill, reject in
            let fieldTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[A-Z]).{8,15}$")
            if !fieldTest.evaluate(with: password) {
                self.activeError = ValidateCredentialError.passwordPoorlyFormatted
                print("Password poorly formatted.")
            } else if password != confirmPassword {
                self.activeError = ValidateCredentialError.passwordsDoNotMatch
                print("Passwords don't match.")
            } else {
                self.auth.currentUser?.updatePassword(to: password, completion: { error in
                    if let error = error {
                        self.handleErrors(error: error)
                        reject(error)
                    } else {
                        fulfill(true)
                    }
                })
            }
        }
    }
    
    func verifyPassword(_ password: String) -> Promise<Bool> {
        return Promise<Bool>(on: .global(qos: .background)) { fulfill, reject in
            let email = self.auth.currentUser?.email ?? ""
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            self.auth.currentUser?.reauthenticate(with: credential, completion: { _, error in
                if let error = error {
                    self.handleErrors(error: error, email: email)
                    reject(error)
                } else {
                    fulfill(true)
                }
            })
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
        auth.signIn(with: credential) { result, error in
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
