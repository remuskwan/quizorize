//
//  RegisterView.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI



struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var color = Color.black.opacity(0.7)
    @State var visible: Bool = false
    

    var body: some View {
        NavigationView {
            Form {
                Spacer()
                    .listRowBackground(Color.clear)
                
                Section(header: Text("NAME")) {
                    InfoFieldView(isSensitive: false, queryCommand: "Enter your name")
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("EMAIL")) {
                    InfoFieldView(isSensitive: false, queryCommand: "Enter your email")
                }
                .listRowBackground(Color.clear)
                .alignmentGuide(.top) { dimension in
                    dimension[.top]
                }
                
                Section(header: Text("PASSWORD")) {
                    InfoFieldView(isSensitive: true, queryCommand: "Enter your password")
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("CONFIRM PASSWORD")) {
                    InfoFieldView(isSensitive: true, queryCommand: "Confirm your password")
                }
                .listRowBackground(Color.clear)
                
                Spacer()
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
            .onAppear {
                UITableViewCell.appearance().backgroundColor = UIColor.clear
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .background(Color.white)
            
        }
        .navigationTitle("Create Your Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Create") {
                print("Hello World")
            }
        }
        
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

