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
    @State var email: String = ""
    
    var isDisabled: Bool {
        return email.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Reset password")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 24)
            VStack {
                HStack {
                    Text("Email")
                        .frame(width: 90, alignment: .leading)
                    TextField("Enter your email address", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $email))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                Divider()
            }
            .padding(.vertical, 4)
            
            Button(action: {
                viewModel.forgotPassword(email: email)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }, label: {
                Text("Send recovery email")
                    .frame(width: 250, height: 50)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(5)
            })
            .opacity(isDisabled ? 0.6 : 1)
            .disabled(isDisabled)
            .frame(width: 280, height: 45, alignment: .center)
            .padding()
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView()
    }
}
