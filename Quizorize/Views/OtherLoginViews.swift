//
//  OtherLoginViews.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 24/5/21.
//

/**
 Other Login Methods for Quizorize(Apple, Google)
 */

import SwiftUI
import AuthenticationServices

struct OtherLoginViews: View {
    let frameWidth: CGFloat
    let frameHeight: CGFloat
    let borderWidth: CGFloat
    let borderCornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    let googleBlue: String = "#4285F4"
    
    var body: some View {
        VStack {
            //Apple's Login View
            QuickSignInWithApple()
                .background(Color.black)
                .frame(width: frameWidth, height: frameHeight, alignment: .center)
                .addBorder(Color.black, width: borderWidth, cornerRadius: borderCornerRadius)
                .onTapGesture(perform: showAppleLoginView)
                .shadow(radius: shadowRadius)
            
            //Google's Login View
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Continue With Google")
                    .font(.system(size: 19.5))
            })
            .cornerRadius(8)
            .foregroundColor(.secondary)
            .frame(width: frameWidth, height: frameHeight)
            .background(Color.white)
            .cornerRadius(borderCornerRadius)
            .shadow(radius: 1.5)
            .padding(4)
        }
    }
    
    //Uses apple's default login method
    private func showAppleLoginView() {
        //1. Instantiate the AuthorizationAppleIDProvider
        let provider = ASAuthorizationAppleIDProvider()
        
        //2. Create a request with the help of provider - ASAuthorizationAppleIDRequest
        let request = provider.createRequest()
        
        //3. Scope to contact information to be request from user during authentication
        request.requestedScopes = [.fullName, .email]
        
        //4. A controller that manages authorization requests created by a provider
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        //5. Initiate the authorization flow
        controller.performRequests()
    }
}

struct OtherLoginViews_Previews: PreviewProvider {
    static var previews: some View {
        OtherLoginViews(frameWidth: 250, frameHeight: 100, borderWidth: 1, borderCornerRadius: 20, shadowRadius: 1.5)
    }
}
