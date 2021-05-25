//
//  RecoverPasswordView.swift
//  Quizorize
//
//  Created by Remus Kwan on 25/5/21.
//

import SwiftUI
import Introspect

struct RecoverPasswordView : View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var email: String = ""
    
    var body: some View {
        VStack {
            Text("Recover password")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 24)
            VStack {
                HStack {
                    Text("Email")
                        .frame(width: 90, alignment: .leading)
                    TextField("Enter your email address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $email))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                Divider()
            }
            .padding(.vertical, 4)
        
            Button(action: {
                guard !email.isEmpty else {
                    return
                }
                viewModel.forgotPassword(email: email)
            }, label: {
                Text("Send recovery email")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(5)
            })
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
