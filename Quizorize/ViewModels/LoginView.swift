//
//  LoginView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
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
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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

class AppViewModel : ObservableObject {
    let auth = Auth.auth()
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error != nil else {
                return
            }

        }
    }
    
    func signUp(email: String, password: String) {
        
    }
}

/*
struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
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
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
 }
      */

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

