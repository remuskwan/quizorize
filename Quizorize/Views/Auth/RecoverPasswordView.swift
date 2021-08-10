//
//  RecoverPasswordView.swift
//  Quizorize
//
//  Created by Remus Kwan on 25/5/21.
//

import SwiftUI

struct RecoverPasswordView : View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var email = ""

    var isDisabled: Bool {
        return email.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Reset password")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
                Text("Enter your email address to receive an email to reset your password.")
                    .multilineTextAlignment(.center)
                    .padding()
                VStack {
                    HStack {
                        Text("Email")
                            .frame(width: 90, alignment: .leading)
                        TextField("Enter your email address", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .modifier(TextFieldClearButton(text: $email))
                            //                        .modifier(TextFieldClearButton(isEditing: $isEditing, text: $email))
                            .multilineTextAlignment(.leading)
                    }
                    Divider()
                }
                Spacer()
                Button(action: {
                    viewModel.forgotPassword(email: email)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }, label: {
                    Text("Send recovery email")
                })
                .opacity(isDisabled ? 0.6 : 1)
                .disabled(isDisabled)
                .buttonStyle(AuthButtonStyle())
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .padding()
            }
            .padding(.horizontal, 20)
        }
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView()
    }
}
