//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

struct RegisterView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""

    var body: some View {
        NavigationView {
            VStack() {
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Confirm your password", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Spacer()
               
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Create Your Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .background(Color.purple)
                        .addBorder(Color.purple, width: 1, cornerRadius: 20)
                        .shadow(radius: 1.5)
                })
                
            }
            .navigationTitle("Create Your Account")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
