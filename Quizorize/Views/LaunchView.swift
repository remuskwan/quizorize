//
//  LaunchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                DecksView()
            } else {
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
                        destination: Login(),
//                            .environmentObject(AuthViewModel()),
                        label: {
                            Text("Get Started.")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 250, height: 50)
                                .background(Color.purple)
                                .cornerRadius(5)
                                .padding()
                        })
                }
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (_) in
                viewModel.signedIn = viewModel.isSignedIn
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
//        .background(NavigationConfigurator { nc in
//            nc.navigationBar.barTintColor = .white
//            //nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
//        })
    }
}


struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
