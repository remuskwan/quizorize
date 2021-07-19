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
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                
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
