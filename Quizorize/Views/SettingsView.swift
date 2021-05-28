//
//  SettingsView.swift
//  Quizorize
//
//  Created by Remus Kwan on 27/5/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.signedIn {
            Settings()
        } else {
            LaunchView()
        }
    }
}

struct Settings: View {
//    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Form {
            Section{
                Button("Sign out") {
                    viewModel.signOut()
//                        presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Settings")
//            .toolbar{
//                ToolbarItem(placement: .primaryAction) {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
