//
//  ProfileView.swift
//  Quizorize
//
//  Created by Remus Kwan on 28/5/21.
//

import SwiftUI
import Promises

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var showVerifyPasswordView = false
    @State private var showUpdatePassword = false
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: ChangePasswordView(),
                    isActive: $showUpdatePassword,
                    label: {
                        EmptyView()
                    })
                Form {
                    //                Section {
                    //                    NavigationLink(destination: EditProfileView()) {
                    //                        HStack {
                    //                            Image(systemName: "camera")
                    //                                .background(Circle()
                    //                                                .fill(Color.offWhite)
                    //                                                .frame(width: 50, height: 50))
                    //                                .frame(width: 20, height: 20)
                    //                                .padding()
                    //                            Text(authViewModel.user?.displayName ?? "")
                    //                                .font(.title)
                    //                                .padding()
                    //                        }
                    //                    }
                    //
                    //                }
                    Section(header: Text("Settings")) {
                        Button(action: {
                            authViewModel
                                .canChangeCredentials()
                                .then { success in
                                    if success {
                                        showVerifyPasswordView.toggle()
                                    }
                                }
                                .catch { error in
                                    print(error.localizedDescription)
                                }
                            
                            
                        }, label: {
                            HStack {
                                Text("Email")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(authViewModel.userEmail)
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        })
                        .onAppear {
                            authViewModel.setUserEmail()
                        }
                        Button(action: {
                            authViewModel
                                .canChangeCredentials()
                                .then { success in
                                    if success {
                                        showUpdatePassword.toggle()
                                    }
                                }
                                .catch { error in
                                    print(error.localizedDescription)
                                }
                        }, label: {
                            HStack {
                                Text("Password")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            
                        })
                    }
                    .alert(isPresented: authViewModel.isPresentingAlert) {
                        Alert(localizedError: authViewModel.activeError!)
                    }
                    Section{
                        SignOutButton()
                    }
                }
                .fullScreenCover(isPresented: $showVerifyPasswordView, onDismiss: {
                    authViewModel.setUserEmail()
                }, content: {
                    VerifyPasswordView()
                        .environmentObject(authViewModel)
                })
                .navigationTitle("Profile")
            }
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
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showRecoverPassword = false
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    var body: some View {
        Form {
            Section(footer:
                        Button(action: {
                            showRecoverPassword.toggle()
                        }, label: {
                            Text("Forgot Password?")
                                .font(.caption)
                                .padding(.horizontal)
                        })
            ) {
                HStack {
                    Text("Current password")
                        .frame(width: 140, alignment: .leading)
                    
                    SecureField("Password", text: $currentPassword)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $currentPassword))
                }
            }
            
            Section {
                HStack {
                    Text("New password")
                        .frame(width: 140, alignment: .leading)
                  
                    SecureField("At least 8 characters", text: $newPassword)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $newPassword))
                }
                HStack {
                    Text("Confirm password")
                        .frame(width: 140, alignment: .leading)
                    
                    SecureField("At least 8 characters", text: $confirmPassword)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $confirmPassword))
                }
            }
        }
        .navigationTitle("Update password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    authViewModel.verifyPassword(currentPassword)
                        .then { success in
                            if success {
                                authViewModel.updatePassword(password: newPassword, confirmPassword: confirmPassword)
                                    .then { success in
                                        if success {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                    .catch { error in
                                        print(error.localizedDescription)
                                    }
                            }
                        }
                        .catch { error in
                            print(error.localizedDescription)
                        }
                }
            }
        })
        .fullScreenCover(isPresented: $showRecoverPassword, content: {
            RecoverPasswordView()
        })
    }
}

struct VerifyPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var password = ""
    @State private var showingEmailView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("Verify your password")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 24)
                    Text("Re-enter your password to continue.")
                        .multilineTextAlignment(.center)
                        .padding()
                    CustomTextField(title: "Password", placeholder: "Password", isSecure: true, input: $password, isHidden: true)
                    
                    Spacer()
                    NavigationLink(
                        destination: ChangeEmailView(),
                        isActive: $showingEmailView,
                        label: {
                            EmptyView()
                        })
                    Button(action: {
                        authViewModel
                            .verifyPassword(password)
                            .then { success in
                                if success {
                                    showingEmailView.toggle()
                                }
                            }
                            .catch { error in
                                print(error.localizedDescription)
                            }
                    }, label: {
                        Text("Next")
                    })
                    .opacity(password.isEmpty ? 0.6 : 1)
                    .disabled(password.isEmpty)
                    .alert(isPresented: authViewModel.isPresentingAlert) {
                        Alert(localizedError: authViewModel.activeError!)
                    }
                    .buttonStyle(AuthButtonStyle())
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.headline)
                    .padding()
                }
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: authViewModel.isPresentingAlert) {
                    Alert(localizedError: authViewModel.activeError!)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct ChangeEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Change email")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
                Text("Your current email is \(authViewModel.userEmail). What would you like to change it to?")
                    .multilineTextAlignment(.center)
                    .padding()
                CustomTextField(title: "Email", placeholder: "Enter new email address", isSecure: false, input: $email)
                Spacer()
                Button(action: {
                    authViewModel.updateEmail(email: email)
                        .then { success in
                            if success {
                                authViewModel.setUserEmail()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .catch { error in
                            print(error)
                        }
                }, label: {
                    Text("Change email address")
                })
                .opacity(email.isEmpty ? 0.6 : 1)
                .disabled(email.isEmpty)
                .alert(isPresented: authViewModel.isPresentingAlert) {
                    Alert(localizedError: authViewModel.activeError!)
                }
                .buttonStyle(AuthButtonStyle())
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .padding()
            }
            .onAppear {
                authViewModel.setUserEmail()
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: authViewModel.isPresentingAlert) {
                Alert(localizedError: authViewModel.activeError!)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct CustomTextField: View {
    let title: String
    let placeholder: String
    let isSecure: Bool
    
    @Binding var input: String
    @State var isHidden = true
    
    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                    .frame(width: 90, alignment: .leading)
                
                if self.isSecure && self.isHidden {
                    SecureField("Required", text: $input)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $input))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: CGFloat(0))
                    
                } else {
                    TextField(self.placeholder, text: $input)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $input))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: CGFloat(0))
                }
            }
            Divider()
            if self.isSecure {
                Button(action: {
                    self.isHidden.toggle()
                }, label: {
                    if self.isHidden {
                        Text("Reveal password")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text("Hide password")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                })
            }
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

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
