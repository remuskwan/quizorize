//
//  LoginView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                Text("You are signed in")
            } else {
                
            }
            Login()
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct Login : View {
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("flashcard")
                .resizable()
                .scaledToFit()
            
            Text("Study Hard, Study Smart.")
                .font(.title3)
            
            HStack {
                Image("apple")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                Image("microsoft")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
            }
            
            VStack {
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                }, label: {
                    Text("Sign In")
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.purple)
                })
                .padding(4)
                
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text("Register For An Account")
                            .cornerRadius(8)
                            .foregroundColor(.purple)
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .border(Color.gray)
                    })
            }
            .padding()
        }
        Spacer()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
