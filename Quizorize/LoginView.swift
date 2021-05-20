//
//  LoginView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct Login : View {
    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack{
            Text("Log in to your account")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
    }
}
