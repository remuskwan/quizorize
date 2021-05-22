//
//  LoginView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct Login : View {
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
    
    /*
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var visible = false
    
    var body: some View {
        VStack{
            Text("Login")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(self.color)
            TextField("Email", text: self.$email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        HStack{
            VStack{
                if self.visible {
                    TextField("Password", text: self.$password)
                } else {
                    SecureField("Password", text: self.$password)
                }
            }
//            Button(action: {
//
//            })
        }
    }
 */
}
