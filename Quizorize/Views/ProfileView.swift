//
//  ProfileView.swift
//  Quizorize
//
//  Created by Remus Kwan on 28/5/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var userListViewModel = UserListViewModel()
    
    @State var password = ""
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Image(systemName: "camera")
                                .background(Circle()
                                                .fill(Color.offWhite)
                                                .frame(width: 50, height: 50))
                                .frame(width: 20, height: 20)
                                .padding()
                            Text("Remus")
                                .font(.title)
                                .padding()
                        }
                    }
                    
                }
                Section(header: Text("Settings")) {
                    NavigationLink(destination: ChangeEmailView()) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Email")
                            
                        }
                    }
                }
                Section{
                    SignOutButton()
                }
            }
            .navigationTitle("Profile")
        }
    }
}
struct EditProfileView: View {
    var body: some View {
        VStack {
            
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangePasswordView: View {
    var body: some View {
        VStack {
        }
        .navigationTitle("Change password")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangeEmailView: View {
    var body: some View {
        VStack {
        }
        .navigationTitle("Change email")
        .navigationBarTitleDisplayMode(.inline)
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
