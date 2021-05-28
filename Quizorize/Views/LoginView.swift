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
import FirebaseAuth
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            if viewModel.signedIn {
                DecksView()
            } else {
                Login()
            }
        }
    }
}
//struct ViewHeightKey: PreferenceKey {
//    static var defaultValue: CGFloat { 0 }
//    static func reduce(value: inout Value, nextValue: () -> Value) {
//        value = value + nextValue()
//    }
//}
struct Login : View {
    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var isHidden: Bool = true

    var body: some View {
        VStack {
//            Button(action: {
//                self.presentationMode.wrappedValue.dismiss()
//            }, label: {
//                Image(systemName: "chevron.left")
//                    .font(.headline)
//                    .foregroundColor(.purple)
//            })
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding()
            ScrollView {
                ScrollViewReader {scrollView in
                    VStack {
                        Text("Log in to Quizorize")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 24)
                        //Email input field
                        Group {
                            VStack {
                                HStack {
                                    Text("Email")
                                        .frame(width: 90, alignment: .leading)
                                    TextField("Email", text: $email)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .disableAutocorrection(true)
                                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                        .modifier(TextFieldClearButton(text: $email))
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
                        }
                        Group {
                            VStack {
                                HStack {
                                    Text("Password")
                                        .frame(width: 90, alignment: .leading)
                                    VStack {
                                        if self.isHidden {
                                            SecureField("Required", text: $password)
                                                .textContentType(.password)
                                                .disableAutocorrection(true)
                                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                                .modifier(TextFieldClearButton(text: $password))
                                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                            
                                        } else {
                                            TextField("Required", text: $password)
                                                .textContentType(.password)
                                                .disableAutocorrection(true)
                                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                                .modifier(TextFieldClearButton(text: $password))
                                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                        }
                                    }
                                }
                                Divider()
                                Button(action: {
                                    self.isHidden.toggle()
                                }, label: {
                                    if self.isHidden {
                                        Text("Reveal password")
                                            .font(.caption2)
                                            .foregroundColor(.purple)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    } else {
                                        Text("Hide password")
                                            .font(.caption2)
                                            .foregroundColor(.purple)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                })
                            }
                            .id(2)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(2, anchor: .center)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        
                        NavigationLink(
                            destination: RecoverPasswordView(),
                            label: {
                                Text("Forgot password?")
                                    .foregroundColor(.purple)
                                    .font(.caption)
                            })
                            .padding(.vertical, 10)
                        
                        SignInButton(email: email, password: password)
                        
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
                        
                    }
                }
            }
            .padding(.horizontal, 20)
            HStack(spacing: 0) {
                Text("Don't have an account?")
                    .foregroundColor(.primary)
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text("Register")
                            .foregroundColor(.purple)
                    })
                    .padding(.horizontal, 6)
            }
            .padding()
        }
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    Image(systemName: "chevron.left")
//                        .font(.headline)
//                        .foregroundColor(.purple)
//                })
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//            }
//        }
    }
}

struct SignInButton: View {
    @EnvironmentObject var viewModel: AuthViewModel

    let email: String
    let password: String
    
    var isDisabled: Bool {
        return email.isEmpty || password.isEmpty
    }
    
    @State var showErrorAlert: Bool = false
    
    var body: some View {
        Button(action: {
            viewModel.signIn(with: .signInWithEmail(email: email, password: password))
        }, label: {
            Text("Sign In")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 50)
                .font(.headline)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(5)
        })
        .opacity(isDisabled ? 0.6 : 1)
        .disabled(isDisabled)
        .alert(isPresented: viewModel.isPresentingAlert) {
            Alert(localizedError: viewModel.activeError!)
        }
        .frame(width: 280, height: 45, alignment: .center)
//        .padding(.vertical, 24)
    }
}


private struct SignInWithApple: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                let nonce = viewModel.randomNonceString()
                viewModel.currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = viewModel.sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        
                        guard let nonce = viewModel.currentNonce else {
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
            viewModel.signIn(with: .signInWithGoogle)
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

