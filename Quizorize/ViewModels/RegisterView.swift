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
    
    @State var color = Color.black.opacity(0.7)
    @State var visible: Bool = false
    
    var body: some View {
        VStack() {
            TextField("Enter your name", text: $name)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
            
            TextField("Enter your email", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
            
            HStack(spacing: 15) {
                
                VStack {
                    if self.visible {
                        TextField("Password", text: self.$password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                }
                , label: {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                })
            }
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .background(Color(.secondarySystemBackground))
            
            HStack(spacing: 15) {
                
                VStack {
                    if self.visible {
                        TextField("Confirm Password", text: self.$confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                }
                , label: {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                })
            }
            .disableAutocorrection(true)
            .autocapitalization(.none)
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
