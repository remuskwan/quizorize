//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI



struct RegisterView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.signedIn {
            DecksView()
        } else {
            Register()
        }
        
    }
}

struct Register: View {
    
    @StateObject var name: InfoFieldViewModel = InfoFieldViewModel(isSensitive: false)
    @StateObject var email: InfoFieldViewModel = InfoFieldViewModel(isSensitive: false)
    @StateObject var password: InfoFieldViewModel = InfoFieldViewModel(isSensitive: true)
    @StateObject var confirmPassword: InfoFieldViewModel = InfoFieldViewModel(isSensitive: true)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var color = Color.black.opacity(0.7)
    @State var visible: Bool = false
    @State var showErrorAlert: Bool = false
    
    var isDisabled: Bool {
        return email.userInput.isEmpty || password.userInput.isEmpty
    }
    
    var body: some View {
        VStack {
            Form {
                Spacer()
                    .listRowBackground(Color.clear)
                
                Section(header: Text("DISPLAY NAME")) {
                    InfoFieldView(InfoType: name, queryCommand: "Enter your name")
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("EMAIL")) {
                    InfoFieldView(InfoType: email, queryCommand: "Enter your email")
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("PASSWORD")) {
                    InfoFieldView(InfoType: password, queryCommand: "Enter your password")
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("CONFIRM PASSWORD")) {
                    InfoFieldView(InfoType: confirmPassword, queryCommand: "Confirm your password")
                }
                .listRowBackground(Color.clear)
                
                /*
                 HStack {
                 Spacer()
                 Button(action: {}, label: {
                 Text("Create Your Account")
                 .font(.headline)
                 .foregroundColor(.white)
                 .frame(width: 250, height: 50)
                 .background(Color.purple)
                 .addBorder(Color.purple, width: 1, cornerRadius: 20)
                 })
                 .listRowBackground(Color.clear)
                 Spacer()
                 }
                 .listRowBackground(Color.clear)
                 */
            }
            .background(Color.white)
            .onAppear {
                UITableViewCell.appearance().backgroundColor = UIColor.clear
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            Button(action: {
                guard !email.userInput.isEmpty, !password.userInput.isEmpty else {
                    return
                }
                
                viewModel.signUp(email: email.userInput, password: password.userInput)
            }, label: {
                Text("Create Your Account")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.purple)
                    .cornerRadius(5)
                /*
                 .background(Color.purple)
                 .font(.headline)
                 .foregroundColor(.white)
                 .overlay(RoundedRectangle(cornerRadius: 25)
                 .stroke(Color.white, lineWidth: 2))
                 */
            })
            .alert(isPresented: viewModel.isPresentingAlert) {
                Alert(localizedError: viewModel.activeError!)
            }
            Spacer()
        }
        .navigationTitle("Create Your Account")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
    }
    
    
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

