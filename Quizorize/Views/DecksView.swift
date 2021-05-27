//
//  DecksView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct DecksView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        if viewModel.signedIn {
            Decks()
        } else {
            LaunchView()
        }
    }
}

struct Decks: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedSortBy = SortBy.date
    @State private var showSettingsSheet: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                Picker("Sort By: ", selection: $selectedSortBy) {
                    ForEach(SortBy.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200, height: 20, alignment: .center)
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Decks")
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
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.purple)
                    })
            }
        }
    }
}

enum SortBy: String, CaseIterable {
    case date = "Date"
    case name = "Name"
    case type = "Type"
}

struct DecksView_Previews: PreviewProvider {
    static var previews: some View {
        DecksView()
    }
}
