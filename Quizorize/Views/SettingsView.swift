////
////  SettingsView.swift
////  Quizorize
////
////  Created by Remus Kwan on 27/5/21.
////
//
//import SwiftUI
//
//struct SettingsView: View {
//    @EnvironmentObject var viewModel: AuthViewModel
//
//    var body: some View {
//        if viewModel.signedIn {
//            Settings()
//        } else {
//            LaunchView()
//        }
//    }
//}
//
//struct Settings: View {
//    //    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var viewModel: AuthViewModel
//
//    @State private var showSignOutConfirm = false
//
//    var body: some View {
//        Form {
//            Section{
//                Button("Sign Out") {
//                    //                        presentationMode.wrappedValue.dismiss()
//                    showSignOutConfirm = true
//                }
//                .foregroundColor(.primary)
//                .actionSheet(isPresented: $showSignOutConfirm, content: {
//                    ActionSheet(title: Text(""), message: Text("Are you sure you want to sign out?"), buttons: [
//                        .default(Text("Sign Out").foregroundColor(.red)) {
//                            viewModel.signOut()
//                        },
//                        .cancel() {
//                            showSignOutConfirm = false
//                        }
//                    ])
//                })
//
//            }
//        }
//        .navigationTitle("Settings")
//        //            .toolbar{
//        //                ToolbarItem(placement: .primaryAction) {
//        //                    Button("Cancel") {
//        //                        presentationMode.wrappedValue.dismiss()
//        //                    }
//        //                }
//        //            }
//    }
//
//}
//
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
