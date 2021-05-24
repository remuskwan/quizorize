//
//  LoginView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

/**
 Quizorize's Login View (First View)
 */

import SwiftUI
import FirebaseAuth
import AuthenticationServices

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
}

struct LoginView: View {
    
    // MARK: Constant Parameters for Login View to be used in DefaultLoginView and OtherLoginViews
    let frameWidth: CGFloat = 350
    let frameHeight: CGFloat = 50
    let borderWidth: CGFloat = 1.5
    let borderCornerRadius: CGFloat = 20
    let shadowRadius: CGFloat = 1.5
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    Image("flashcard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .topLeading)
                    
                    Text("Quizorize")
                        .font(.title3)
                    
                }
                
                Text("Study Hard, Study Smart.")
                    .font(.title3)

                
                DefaultLoginView(frameWidth: self.frameWidth, frameHeight: self.frameHeight, borderWidth: self.borderWidth, borderCornerRadius: self.borderCornerRadius, shadowRadius: self.shadowRadius)
                
                Text("OR")
                
                OtherLoginViews(frameWidth: self.frameWidth, frameHeight: self.frameHeight, borderWidth: self.borderWidth, borderCornerRadius: self.borderCornerRadius, shadowRadius: self.shadowRadius)
                
                Spacer()
            }
        }
    }
    
    
    func signUp(email: String, password: String) {
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

