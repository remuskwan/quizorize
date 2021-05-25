//
//  LoginView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

/**
 Quizorize's Login View (First View)
 */

import SwiftUI
import AlertKit
import CryptoKit
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.signedIn {
            DecksView()
        } else {
            Login()
        }
        
    }
}
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
struct Login : View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AuthViewModel
    //@StateObject var customAlertManager = CustomAlertManager()

    @State var username: String = ""
    @State var password: String = ""
    @State var currentNonce:String?
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack {
                    Text("Log in to Quizorize")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 24)
                    Group {
                        VStack {
                            HStack {
                                Text("Email")
                                    .frame(width: 90, alignment: .leading)
                                TextField("Email", text: $username)
                                    .disableAutocorrection(true)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .modifier(TextFieldClearButton(text: $username))
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            }
                            Divider()
                        }
                        .id(1)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.3)) {
                                scrollView.scrollTo(1, anchor: .center)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        VStack {
                            HStack {
                                Text("Password")
                                    .frame(width: 90, alignment: .leading)
                                SecureField("Password", text: $password)
                                    .disableAutocorrection(true)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .modifier(TextFieldClearButton(text: $password))
                                    .textContentType(.password)
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            }
                            Divider()
                        }
                        .id(2)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.3)) {
                                scrollView.scrollTo(2, anchor: .center)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    Button(action: {
                        guard !username.isEmpty, !password.isEmpty else {
                            return
                        }
                        viewModel.signIn(email: username, password: password)
                    }, label: {
                        Text("Sign In")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(5)
                    })
                    .frame(width: 280, height: 45, alignment: .center)
                    .padding(.vertical, 24)
                    
                    NavigationLink(
                        destination: RecoverPasswordView(),
                        label: {
                            Text("Forgot password?")
                                .foregroundColor(.purple)
                                .font(.caption)
//                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    
                    Divider()
                        .padding(.vertical, 32)
                    
                    Group {
                        if self.colorScheme == .light {
                            SignInWithApple()
                                .signInWithAppleButtonStyle(.black)
                        } else {
                            SignInWithApple()
                                .signInWithAppleButtonStyle(.white)
                        }
                        
                        SignInWithGoogle()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("Don't have an account?")
                            .foregroundColor(.primary)
                        NavigationLink(
                            destination: RegisterView(),
                            label: {
                                Text("Register")
                                    .foregroundColor(.purple)
                            })
                            .padding()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    //.ignoresSafeArea(.keyboard, edges: .bottom)
    
}

private struct SignInWithApple: View {
    @State var currentNonce:String?
    
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
    private func randomNonceString(length: Int = 32) -> String {
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
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                let nonce = randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        
                        guard let nonce = currentNonce else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        
                        let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                            if (error != nil) {
                                // Error. If error.code == .MissingOrInvalidNonce, make sure
                                // you're sending the SHA256-hashed nonce as a hex string with
                                // your request to Apple.
                                print(error?.localizedDescription as Any)
                                return
                            }
                            print("signed in")
                        }
                        
                        print("\(String(describing: Auth.auth().currentUser?.uid))")
                    default:
                        break
                        
                    }
                default:
                    break
                }
            }
        )
        .frame(width: 280, height: 45, alignment: .center)
    }
}

struct SignInWithGoogle: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Button(action: {
            viewModel.signInWithGoogle()
        }, label: {
            HStack {
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Sign in with Google")
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
            }
            .padding(12)
            .frame(width: 280, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        })
        .background(RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.primary, lineWidth: 1))
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

