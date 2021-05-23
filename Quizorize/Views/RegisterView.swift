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
    @State var country: String = ""
        
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email Address", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                TextField("", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                TextField("Email Address", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
            }
        }
    }
}

//struct Register : View {
//    @State var email: String = ""
//    @State var password: String = ""
//
//    @EnvironmentObject var viewModel: LoginViewModel
//
//    var body: some View {
//        VStack {
//            Image("flashcard")
//                .resizable()
//                .scaledToFit()
//
//            Text("Study Hard, Study Smart.")
//                .font(.title3)
//
//            HStack {
//                Image("apple")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100, alignment: .center)
//                Image("google")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100, alignment: .center)
//                Image("microsoft")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100, alignment: .center)
//            }
//
//            VStack {
//                TextField("Email Address", text: $email)
//                    .padding()
//                    .background(Color(.secondarySystemBackground))
//
//                SecureField("Password", text: $password)
//                    .padding()
//                    .background(Color(.secondarySystemBackground))
//
//                Button(action: {
//                    guard !email.isEmpty, !password.isEmpty else {
//                        return
//                    }
//                    viewModel.signUp(email: email, password: password)
//                }, label: {
//                    Text("Create Account")
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                        .frame(width: 200, height: 50)
//                        .background(Color.purple)
//                })
//                .padding(4)
//            }
//            .padding()
//        }
//        Spacer()
//    }
//}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
