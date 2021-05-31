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
                                    scrollView.scrollTo(2, anchor: .center)
                                }
                            }
                        
                        password
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(3, anchor: .center)
                                }
                            }
                        
                        confirmPassword
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    scrollView.scrollTo(4, anchor: .bottom)
                                }
                            }
                        



                        Spacer()
                    }
                }
            }
            
            createYourAccountButton
        }
        .padding(.horizontal)
    }
    
    var name: some View {
        EntryField(placeHolder: "Enter your display name", title: "Name", prompt: signupVM.namePrompt, field: $signupVM.name, isSecure: false)
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


//MARK: A View that creates any entry(text or secure) row specified.
struct EntryField: View {
    @State var isShowingPassword: Bool = false

    let fieldHeight: CGFloat = 0
    
    var placeHolder: String
    var title: String
    var prompt: String
    @Binding var field: String
    var isSecure: Bool  //MARK: If EntryField is a SecureField, = true
    var emptyTextField: String = """
        
    """

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                if isSecure {
                    secureFieldTogglerView //shows 'Reveal password' when string is empty
                } else {
                    emptyFieldTogglerView // shows nothing but takes up the same whitespace
                }
            }
            
            HStack {
                Text(title)
                    .frame(width: 90, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                if isSecure {
                    secureFieldSection
                } else {
                    textFieldSection
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
    
    var textFieldSection: some View {
        TextField(placeHolder, text: $field)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .modifier(TextFieldClearButton(text: $field))
            .multilineTextAlignment(.leading)
            .frame(height: fieldHeight)
    }
    
    var secureFieldSection: some View {
        ZStack {
            SecureField(
                isShowingPassword ? "" : self.placeHolder,
                text: $field) {
                
            }
            .opacity(isShowingPassword ? 0 : 1)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .modifier(TextFieldClearButton(text: $field))
            .multilineTextAlignment(.leading)
            .frame(height: fieldHeight)
            
            if(isShowingPassword){
                HStack{
                    Text(self.field)
                        .foregroundColor(.black)
                        .allowsHitTesting(false)
                    Spacer()
                }
            }
        }
    }
    
    var emptyFieldTogglerView: some View {
        Text(emptyTextField)
            .font(.caption.bold())
            .foregroundColor(.accentColor)
            .multilineTextAlignment(.trailing)
    }

    var secureFieldTogglerView: some View {
        Button {
            
        } label: {
            
            Text(toggleSecureField())
        }
            .foregroundColor(.accentColor)
            .font(.caption.bold())
            .modifier(TouchDownUpEventModifier { (buttonState) in
                if buttonState == .pressed {
                    isShowingPassword = true
                } else {
                    isShowingPassword = false
                }
        })
    }
    
    func toggleSecureField() -> String {
        if self.field.isEmpty {
            return emptyTextField
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

