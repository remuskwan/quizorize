//
//  ProfileView.swift
//  Quizorize
//
//  Created by Remus Kwan on 28/5/21.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            //            ScrollView {
            //                let userProfile = viewModel.getUserProfile()
            //                if let userProfile = userProfile {
            //                    let displayName = userProfile.displayName
            //                    Text("Welcome \(displayName)")
            //                }
            
            Form {
                Section{
                    SignOutButton()
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct SignOutButton: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showSignOutConfirm = false
    
    var body: some View {
        Button("Sign out") {
            showSignOutConfirm = true
        }
        .foregroundColor(.primary)
        .actionSheet(isPresented: $showSignOutConfirm, content: {
            ActionSheet(title: Text(""), message: Text("Are you sure you want to sign out?"), buttons: [
                .destructive(Text("Sign out").foregroundColor(.red)) {
                    viewModel.signOut()
                },
                .cancel()
            ])
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
