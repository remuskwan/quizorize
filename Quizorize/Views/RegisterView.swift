//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var visible: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                //            HStack {
                //                Button("Cancel") {
                //                    presentationMode.wrappedValue.dismiss()
                //                }
                //                .frame(maxWidth: .infinity, alignment: .topLeading)
                //                Button("Submit") {
                //                    presentationMode.wrappedValue.dismiss()
                //                }
                //                .frame(maxWidth: .infinity, alignment: .topTrailing)
                //
                //            }.padding()
                //            Text("Create Account")
                //                .font(.largeTitle.bold())
                //                .frame(maxWidth: .infinity, alignment: .leading)
                //                .padding()
                
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
                            .foregroundColor(.secondary)
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
                            .foregroundColor(.secondary)
                    })
                }
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
            }
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Create Your Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(Color.purple)
                    //.addBorder(Color.purple, width: 1, cornerRadius: 20)
                    .shadow(radius: 1.5)
            })
        }.navigationTitle("Create your account")
        .toolbar {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
