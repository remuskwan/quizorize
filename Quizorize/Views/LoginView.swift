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

class AppViewModel : ObservableObject {
    @EnvironmentObject var viewModel: AuthViewModel
    
    let auth = Auth.auth()
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                DecksView()
            } else {
                Login()
                    .navigationTitle("Login")
            }
        }
    }
}

struct Login : View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var customAlertManager = CustomAlertManager()
    
    @State var showingRegister: Bool = false
    @State var showingForgotPassword: Bool = false
    @State var customAlertText: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var currentNonce:String?
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("Login with your username")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Username", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $email))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(Color.secondary, lineWidth: 1))
                    
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $password))
                        .textContentType(.password)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(Color.secondary, lineWidth: 1))
                    Button("Forgot username or password?") {
                        customAlertManager.show()
                    }
                    .foregroundColor(.purple)
                    .frame(alignment: .leading)
                    .customAlert(manager: customAlertManager, content: {
                        VStack {
                            Text("Forgot password").font(.title)
                            Text("Please type in your email")
                            TextField("Enter your email", text: $customAlertText).textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }, buttons: [
                        .cancel(content: {
                            Text("Cancel").bold()
                        }),
                        .regular(content: {
                            Text("OK")
                        }, action: {
                            print("Sending email: \(customAlertText)")
                        })
                    ])
                }
                .padding(.vertical, 32)
                    
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                }, label: {
                    Text("Sign In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(5)
                })
                
                Divider()
                    .padding(.vertical, 32)
                
                SignInWithApple()
                
                SignInWithGoogle()
                
                Spacer()
                
                HStack {
                    Text("I'm a new user.")
                    Button("Create An Account") {
                        showingRegister.toggle()
                    }
                    .foregroundColor(.purple)
                    .sheet(isPresented: $showingRegister) {
                        RegisterView()
                    }
                }
                .padding()
                //            NavigationLink(
                //                destination: RegisterView(),
                //                label: {
                //                    HStack {
                //                        Text("I'm a new user.")
                //                            .foregroundColor(.primary)
                //                        Text("Create An Account")
                //                            .foregroundColor(.purple)
                //                    }
                //
                //                })
                //                .padding()
            }
            .padding(.horizontal, 32)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
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
    var body: some View {
        Button(action: {
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
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
        Login()
    }
}

