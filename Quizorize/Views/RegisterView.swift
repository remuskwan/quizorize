//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI



struct RegisterView: View {
    /*
    //MARK: Information Fields that User have to enter
    @StateObject var name: InfoFieldViewModel = InfoFieldViewModel(field: "Display Name", isSensitive: false)
    @StateObject var email: InfoFieldViewModel = InfoFieldViewModel(field: "Email", isSensitive: false)
    @StateObject var password: InfoFieldViewModel = InfoFieldViewModel(field: "Password", isSensitive: true)
    @StateObject var confirmPassword: InfoFieldViewModel = InfoFieldViewModel(field: "Confirm Password", isSensitive: true)
    
    //MARK: Bool to check if Password and ConfirmPassword are equal
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode

    @State var color = Color.black.opacity(0.7)
    @State var visible: Bool = false
    */
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @ObservedObject var signupVM = SignupViewModel()
    

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Your Account")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
                
                EntryField(placeHolder: "Enter your name", title: "Name", prompt: signupVM.titlePrompt, field: $signupVM.title, isSecure: false)
                EntryField(placeHolder: "Enter your email", title: "Email", prompt: signupVM.emailPrompt, field: $signupVM.email, isSecure: false)
                EntryField(placeHolder: "Enter your password", title: "Password", prompt: signupVM.passwordPrompt, field: $signupVM.password, isSecure: true)
                EntryField(placeHolder: "Confirm your password", title: "Confirm Password", prompt: signupVM.confirmPwPrompt, field: $signupVM.confirmPw, isSecure: true)
                
                Button(action: {
                    guard !signupVM.email.isEmpty, !signupVM.password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: signupVM.email, password: signupVM.password)
                }, label: {
                    Text("Create Your Account")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.purple)
                        .cornerRadius(5)
                    })
                .opacity(signupVM.isSignUpComplete ? 1 : 0.6)
                .disabled((!signupVM.isSignUpComplete))  //MARK: Disable sign in until all requirements are met


               Spacer()
                
                
            }
            .padding(.horizontal)
        }
    }
    
    /*
    var body: some View {
       
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Your Account")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)

                Spacer()
                
                InfoFieldView(InfoType: name, queryCommand: "Enter your name")
                InfoFieldView(InfoType: email, queryCommand: "Enter your email")
                InfoFieldView(InfoType: password, queryCommand: "Enter your password")
                InfoFieldView(InfoType: confirmPassword, queryCommand: "Confirm your password")

                Button(action: {
                    guard !email.userInput.isEmpty, !password.userInput.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email.userInput, password: password.userInput)
                }, label: {
                    Text("Create Your Account")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
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
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Important"), message: Text("Your passwords do not match"))
                })

               Spacer()
                
            }
            .padding(.horizontal, 20)
        }
        

        /*
        VStack {
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
               Spacer()
            }
        }
        .navigationTitle("Create Your Account")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
        */
    }
    */
}

struct EntryField: View {
    
    let fieldHeight: CGFloat = 0

    @State var color = Color.black.opacity(0.7)

    var placeHolder: String
    var title: String
    var prompt: String
    @Binding var field: String
    var isSecure: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .frame(width: 90, alignment: .leading)

                if isSecure {
                    TextField(placeHolder, text: $field)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $field))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: fieldHeight)
                } else {
                    SecureField(placeHolder, text: $field)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldClearButton(text: $field))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .frame(height: fieldHeight)
                }
            }
            /*
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            */
            Text(prompt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption.bold())
                .foregroundColor(Color.black)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)

        }
        .padding(.horizontal)
        Divider()
        

        Spacer()
    }
}

/*

//MARK: InformationField Creator View
struct InfoFieldView: View {
    
    let fieldHeight: CGFloat = 15
    
    @ObservedObject var InfoType: InfoFieldViewModel
    
    @State var color = Color.black.opacity(0.7)
    @State var visible: Bool = false

    let queryCommand: String

    var body: some View {
        if InfoType.isSensitive {
            
                HStack {
                    Text(InfoType.field)
                        .frame(width: 90, alignment: .leading)

                    if self.visible {
                        TextField(queryCommand, text: $InfoType.userInput)
                            .disableAutocorrection(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .modifier(TextFieldClearButton(text: $InfoType.userInput))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .frame(height: fieldHeight)
                    } else {
                        SecureField(queryCommand, text: $InfoType.userInput)
                            .disableAutocorrection(true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .modifier(TextFieldClearButton(text: $InfoType.userInput))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .frame(height: fieldHeight)
                    }

                    Button(action: {
                        self.visible.toggle()
                    }
                    , label: {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(self.color)
                    })
                }
                
                Divider()
                
                Spacer()

            /*
            HStack(spacing: 15) {
                VStack {
                    if self.visible {
                        TextField(self.queryCommand, text: self.$InfoType.userInput)
                    } else {
                        SecureField(self.queryCommand, text: self.$InfoType.userInput)
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                }
                , label: {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                })
            }
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            */
        } else {
            /*
            TextField(queryCommand, text: $InfoType.userInput)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            */
            HStack {
                Text(InfoType.field)
                    .frame(width: 90, alignment: .leading)
                TextField(queryCommand, text: $InfoType.userInput)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .modifier(TextFieldClearButton(text: $InfoType.userInput))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .frame(height: fieldHeight)
            }
            
            Divider()
            
            Spacer()
        }
    }
    
}
*/

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}

