//
//  RecoverPasswordView.swift
//  Quizorize
//
//  Created by Remus Kwan on 25/5/21.
//

import SwiftUI

struct RecoverPasswordView : View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var email: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter your email address", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .modifier(TextFieldClearButton(text: $email))
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .padding(12)
                .textFieldStyle(DefaultTextFieldStyle())
            //                .background(RoundedRectangle(cornerRadius: 5)
            //                                .strokeBorder(Color.secondary, lineWidth: 1))
            Button("Send recovery email") {
                viewModel.forgotPassword(email: email)
            }
            
        }
        .navigationTitle("Recover password")
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView()
    }
}
