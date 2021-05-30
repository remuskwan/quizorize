//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI



struct RegisterView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var signupVM = SignupViewModel()
    
    var body: some View {
        VStack {
            //            Button(action: {
            //                self.presentationMode.wrappedValue.dismiss()
            //            }, label: {
            //                Image(systemName: "chevron.left")
            //                    .font(.headline)
            //                    .foregroundColor(.purple)
            //            })
            //            .padding()
            
            ScrollView {
                ScrollViewReader {scrollView in
                    VStack {
                        Text("Create account")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 24)
                        
                        name
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(1, anchor: .center)
                                }
                            }
                        email
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(1, anchor: .center)
                                }
                            }
                        
                        CustomSecureField()
                        
                        /*
                        password
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(1, anchor: .center)
                                }
                            }
                        confirmPassword
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(1, anchor: .center)
                                }
                            }
                        */
                        
                        /*
                        EntryField(placeHolder: "Enter your name", title: "Name", prompt: signupVM.titlePrompt, field: $signupVM.title, isSecure: false)
                            .id(1)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(1, anchor: .center)
                                }
                            }
                            .onAppear {
                                signupVM.title = ""
                            }
                        
                        EntryField(placeHolder: "Enter your email", title: "Email", prompt: signupVM.emailPrompt, field: $signupVM.email, isSecure: false)
                            .keyboardType(.emailAddress)
                            .id(2)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(2, anchor: .center)
                                }
                            }
                            .onAppear {
                                signupVM.email = ""
                            }
                        
                        EntryField(placeHolder: "Enter your password", title: "Password", prompt: signupVM.passwordPrompt, field: $signupVM.password, isSecure: true)
                            .textContentType(.newPassword)
                            .id(3)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(3, anchor: .center)
                                }
                            }
                            .onAppear {
                                signupVM.password = ""
                            }
                        
                        EntryField(placeHolder: "Confirm your password", title: "Confirm Password", prompt: signupVM.confirmPwPrompt, field: $signupVM.confirmPw, isSecure: true)
                            .textContentType(.newPassword)
                            .id(4)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(4, anchor: .bottom)
                                }
                            }
                            .onAppear {
                                signupVM.confirmPw = ""
                            }
                            */
                        
                        Spacer()
                    }
                }
            }
            
            createYourAccountButton
            /*
            Button(action: {
                viewModel.signUp(email: signupVM.email, password: signupVM.password, displayName: signupVM.title)
            }, label: {
                Text("Create your account")
                    .foregroundColor(.white)
                    .frame(width: 280, height: 45)
                    .background(Color.purple)
                    .cornerRadius(5)
            })
            .opacity(signupVM.isSignUpComplete ? 1 : 0.6)
            .disabled((!signupVM.isSignUpComplete))  //MARK: Disable sign in until all requirements are met
            .padding()
            */
        }
        .padding(.horizontal)
    }
    
    var name: some View {
        EntryField(placeHolder: "Enter your name", title: "Name", prompt: signupVM.namePrompt, field: $signupVM.name, isSecure: false)
            .id(1)
            .onAppear {
                signupVM.name = ""
            }
    }
    
    var email: some View {
        EntryField(placeHolder: "Enter your email", title: "Email", prompt: signupVM.emailPrompt, field: $signupVM.email, isSecure: false)
            .keyboardType(.emailAddress)
            .id(2)
            .onAppear {
                signupVM.email = ""
            }
        
    }
    
    var password: some View {
        EntryField(placeHolder: "Enter your password", title: "Password", prompt: signupVM.passwordPrompt, field: $signupVM.password, isSecure: true)
            .textContentType(.newPassword)
            .id(3)
            .onAppear {
                signupVM.password = ""
            }

    }
    
    var confirmPassword: some View {
        EntryField(placeHolder: "Confirm your password", title: "Confirm Password", prompt: signupVM.confirmPwPrompt, field: $signupVM.confirmPw, isSecure: true)
            .textContentType(.newPassword)
            .id(4)
            .onAppear {
                signupVM.confirmPw = ""
            }
    }

    var createYourAccountButton: some View {
        Button(action: {
            viewModel.signUp(email: signupVM.email, password: signupVM.password, displayName: signupVM.name)
        }, label: {
            Text("Create your account")
                .foregroundColor(.white)
                .frame(width: 280, height: 45)
                .background(Color.purple)
                .cornerRadius(5)
        })
        .opacity(signupVM.isSignUpComplete ? 1 : 0.6)
        .disabled((!signupVM.isSignUpComplete))  //MARK: Disable sign in until all requirements are met
        .padding()
        
    }
}


//MARK: A View that creates any entry row specified.
struct EntryField: View {
    
    @State var isVisible: Bool = false
    
    let fieldHeight: CGFloat = 0
    
    var placeHolder: String
    var title: String
    var prompt: String
    @Binding var field: String
    var isSecure: Bool
    var emptyTextField: String = "         "

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Button(action: {
                    self.isVisible.toggle()
                }, label: {
                    if isSecure {
                        Text(toggleSecureField())
                            .font(.caption.bold())
                            .foregroundColor(.accentColor)
                    } else {
                        Text(emptyTextField)
                            .font(.caption.bold())
                            .foregroundColor(.accentColor)
                    }
                })
                .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Text(title)
                    .frame(width: 90, alignment: .leading)
                    .multilineTextAlignment(.leading)

                if isSecure && !isVisible  {
                    SecureField(placeHolder, text: $field)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .modifier(TextFieldClearButton(text: $field))
                        .multilineTextAlignment(.leading)
                        .frame(height: fieldHeight)
                } else {
                    TextField(placeHolder, text: $field)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .modifier(TextFieldClearButton(text: $field))
                        .multilineTextAlignment(.leading)
                        .frame(height: fieldHeight)
                }
            }
            /*
             .padding(8)
             .background(Color(UIColor.secondarySystemBackground))
             .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
             */
            
            Divider()
            
            Text(prompt)
                .font(.caption.bold())
                .foregroundColor(Color.black)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func toggleSecureField() -> String {
        if self.field.isEmpty {
            return "             "
        } else if isVisible {
            return "Hide password"
        } else {
            return "Reveal password"
        }
    }
}





struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}

