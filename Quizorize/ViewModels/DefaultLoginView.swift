//
//  DefaultLoginView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 24/5/21.
//

import SwiftUI

struct DefaultLoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    let frameWidth: CGFloat = 250
    let frameHeight: CGFloat = 50
    let borderWidth: CGFloat = 1.5

    let borderCornerRadius: CGFloat = 20
    let shadowRadius: CGFloat = 1.5
    
    var body: some View {
        VStack {
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Sign In")
                        .font(.headline)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(width: frameWidth, height: frameHeight)
                        .background(Color.purple)
                        .addBorder(Color.purple, width: borderWidth, cornerRadius: borderCornerRadius)
                        .shadow(radius: 1.5)
                })
                .padding(4)
                
                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text("Register For An Account")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .frame(width: frameWidth, height: frameHeight)
                            .background(Color.white)
                            .addBorder(Color.purple, width: borderWidth, cornerRadius: borderCornerRadius)
                            .shadow(radius: shadowRadius)
                    })
            }
            .padding()
            
            Text("OR")
            
            OtherLoginViews(frameWidth: self.frameWidth, frameHeight: self.frameHeight, borderWidth: self.borderWidth, borderCornerRadius: self.borderCornerRadius, shadowRadius: self.shadowRadius)
            
            
        }
    }
}

struct DefaultLoginView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLoginView()
    }
}
