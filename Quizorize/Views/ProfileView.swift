//
//  ProfileView.swift
//  Quizorize
//
//  Created by Remus Kwan on 28/5/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
//                let userProfile = viewModel.getUserProfile()
//                if let userProfile = userProfile {
//                    let displayName = userProfile.displayName
//                    Text("Welcome \(displayName)")
//                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //                Button(action: {
                    //                    showSettingsSheet.toggle()
                    //                }, label: {
                    //                    Image(systemName: "gearshape.fill")
                    //                        .foregroundColor(.purple)
                    //                })
                    //                .sheet(isPresented: $showSettingsSheet) {
                    //                    SettingsView()
                    //                }
                    NavigationLink(
                        destination: SettingsView(),
                        label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(.purple)
                        })
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
