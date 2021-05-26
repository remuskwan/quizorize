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
    @State private var selectedSortBy = SortBy.date
    
//    func logOut() {
//        GIDSignIn.sharedInstance()?.signOut()
//        try! Auth.auth().signOut()
//    }
    
    var body: some View {
        VStack {
            if viewModel.signedIn {
                Button("Log out") {
                    viewModel.signOut()
                }
                Picker("Sort By: ", selection: $selectedSortBy) {
                    ForEach(SortBy.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
            } else {
                LaunchView()
            }
            
        }
        .navigationTitle("Decks")
        
    }
}

struct Deck: View {
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            Image("rectangle.fill.on.rectangle.angled.fill")
                .resizable()
                .scaledToFit()
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
