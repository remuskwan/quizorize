//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI



struct RegisterView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    
    @ObservedObject var signupVM = SignupViewModel()
    

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Your Account")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
                
                EntryField(placeHolder: "Enter your name", title: "Name", prompt: signupVM.titlePrompt, field: $signupVM.title, isSecure: false)
                EntryField(placeHolder: "Enter your email", title: "Email", prompt: signupVM.emailPrompt, field: $signupVM.email, isSecure: false)
                EntryField(placeHolder: "Enter your password", title: "Password", prompt: signupVM.passwordPrompt, field: $signupVM.password, isSecure: true)
                EntryField(placeHolder: "Confirm your password", title: "Confirm Password", prompt: signupVM.confirmPwPrompt, field: $signupVM.confirmPw, isSecure: true)
                
                Button(action: {
                    guard !signupVM.email.isEmpty, !signupVM.password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: signupVM.email, password: signupVM.password)
                }, label: {
                    Text("Create Your Account")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.purple)
                        .cornerRadius(5)
                    })
                .opacity(signupVM.isSignUpComplete ? 1 : 0.6)
                .disabled((!signupVM.isSignUpComplete))  //MARK: Disable sign in until all requirements are met


               Spacer()
                
                
            }
            .padding(.horizontal)
        }
    }
}

struct EntryField: View {
    
    let fieldHeight: CGFloat = 0

    @State var color = Color.black.opacity(0.7)

    var placeHolder: String
    var title: String
    var prompt: String
    @Binding var field: String
    var isSecure: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .frame(width: 90, alignment: .leading)

                if isSecure {
                    TextField(placeHolder, text: $field)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $field))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: fieldHeight)
                } else {
                    SecureField(placeHolder, text: $field)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $field))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: fieldHeight)
                }
            }
            /*
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            */
            Text(prompt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption.bold())
                .foregroundColor(Color.black)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)

        }
        .padding(.horizontal)
        Divider()
        

        Spacer()
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}

