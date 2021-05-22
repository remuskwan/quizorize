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
}
