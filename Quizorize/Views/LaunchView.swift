//
//  LaunchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var userListViewModel = UserListViewModel()

    var body: some View {
        ZStack {
            if viewModel.signedIn {
//                NavigationLink(destination: DecksView(), isActive: $viewModel.signedIn) {EmptyView()}
//                HomeView(userViewModel: (userListViewModel.userViewModels.filter({ userVM in
//                    userVM.user.id == viewModel.user?.uid
//                }).first)!)
                HomeView()
            } else {
                Launch()	
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
            
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
                            .frame(width: 250, height: 50)
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
