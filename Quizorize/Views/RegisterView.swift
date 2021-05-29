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
                    VStack(spacing: 20) {
                        Text("Create account")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 24)
                        
                        EntryField(placeHolder: "Enter your name", title: "Name", prompt: signupVM.titlePrompt, field: $signupVM.title, isSecure: false)
                            .id(1)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(1, anchor: .center)
                                }
                            }
                        
                        EntryField(placeHolder: "Enter your email", title: "Email", prompt: signupVM.emailPrompt, field: $signupVM.email, isSecure: false)
                            .keyboardType(.emailAddress)
                            .id(2)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(2, anchor: .center)
                                }
                            }
                        
                        EntryField(placeHolder: "Enter your password", title: "Password", prompt: signupVM.passwordPrompt, field: $signupVM.password, isSecure: true)
                            .textContentType(.newPassword)
                            .id(3)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(3, anchor: .center)
                                }
                            }
                        
                        EntryField(placeHolder: "Confirm your password", title: "Confirm Password", prompt: signupVM.confirmPwPrompt, field: $signupVM.confirmPw, isSecure: true)
                            .textContentType(.newPassword)
                            .id(4)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(4, anchor: .bottom)
                                }
                            }
                        
                        Spacer()
                    }
                }
            }
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
        }
        .padding(.horizontal, 20)
    }
}


//MARK: A View that creates any entry row specified.
struct EntryField: View {
    
    @State var isVisible: Bool = false
    
    let fieldHeight: CGFloat = 0
    
    @State var color = Color.black.opacity(0.7)
    
    var placeHolder: String
    var title: String
    var prompt: String
    @Binding var field: String
    var isSecure: Bool

    var body: some View {
        VStack(alignment: .leading) {
            
            if isSecure {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.isVisible.toggle()
                    }, label: {
                        Text(toggleViewChanger())
                            .font(.caption2)
                            .foregroundColor(.accentColor)
                    })
                    .multilineTextAlignment(.trailing)
                }
            }

            HStack {
                Text(title)
                    .frame(width: 90, alignment: .leading)
                    .multilineTextAlignment(.leading)

                if isSecure && !isVisible {
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
    
    func toggleViewChanger() -> String {
        if isVisible {
            return "Hide password"
        } else if self.field.isEmpty {
            return ""
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

