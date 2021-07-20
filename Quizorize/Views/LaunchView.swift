//
//  LaunchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            if authViewModel.signedIn {
                HomeView()
            } else {
                Launch()	
            }
        }
        .onAppear {
            authViewModel.signedIn = authViewModel.isSignedIn
        }
    }
}

struct Launch: View {
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                
                Text("Quizorize")
                    .font(.custom("GlacialIndifference-Bold", size: 52))
                    .padding()
               
                
                Text("Study Hard, Study Smart.")
                    .font(.custom("GlacialIndifference-Regular", size: 24))
                
                Spacer()
                
                NavigationLink(
                    destination: LoginView(),
                    label: {
                        Text("Get Started.")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 45)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            .padding()
                    })
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
