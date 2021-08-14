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
    var body: some View {
        Login()
    }
}

struct Login : View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var isHidden = true
    @State private var showRecoverPassword = false

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { scrollView in
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
                                        .frame(height: CGFloat(0))
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
                                                .frame(height: CGFloat(0))
                                            
                                        } else {
                                            TextField("Required", text: $password)
                                                .textContentType(.password)
                                                .disableAutocorrection(true)
                                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                                .modifier(TextFieldClearButton(text: $password))
                                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                                .frame(height: CGFloat(0))
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
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    } else {
                                        Text("Hide password")
                                            .font(.caption2)
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
                        
                        Group {
                            Button(action: {
                                showRecoverPassword.toggle()
                            }, label: {
                                Text("Forgot password?")
                                    .font(.caption)
                            })
                            .fullScreenCover(isPresented: $showRecoverPassword, content: {
                                RecoverPasswordView()
                            })
                            .padding(.vertical, 10)
                        }
                        
                        SignInButton(email: email, password: password)
                        
                        Divider()
                            .padding(.vertical, 32)
                        Group {
                            SignInWithAppleToFirebase({response in
                                if response == .success {
                                    print("success, logged in with apple succeeded")
                                    viewModel.signedIn = true
                                } else if response == .error {
                                    print("error, logged in with apple failed")
                                }
                            })
                            .frame(width: 280, height: 45, alignment: .center)
                            
                            SignInWithGoogle()
                        }
                    }
                    
                    Spacer()
                }
            }
            Spacer()
            HStack(spacing: 0) {
                Text("Don't have an account?")
                    .foregroundColor(.primary)
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text("Register")
                    })
                    .padding(.horizontal, 6)
            }
            
            .padding()
        }
        .padding(.horizontal, 20)
    }
        
}

struct SignInButton: View {
    @EnvironmentObject var viewModel: AuthViewModel
    let email: String
    let password: String
    
    var isDisabled: Bool {
        return email.isEmpty || password.isEmpty
    }
    
    var body: some View {
        Button(action: {
            viewModel.signIn(with: .signInWithEmail(email: email, password: password))
        }, label: {
            Text("Sign in")
        })
        .buttonStyle(AuthButtonStyle())
        .opacity(isDisabled ? 0.6 : 1)
        .disabled(isDisabled)
        .alert(isPresented: viewModel.isPresentingAlert) {
            Alert(localizedError: viewModel.activeError!)
        }
    }
}

struct SignInWithGoogle: View {
    @Environment(\.colorScheme) var colorScheme
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
                    .foregroundColor(colorScheme == .dark ? .black : .primary)
            }
            .padding(12)
            .frame(width: 280, height: 45, alignment: .center)
            
        })
        .background(RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.primary, lineWidth: 1)
                        .background(Color.white.cornerRadius(5)))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

