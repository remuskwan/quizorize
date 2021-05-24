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
    @State private var selectedSortBy = SortBy.date
    
    func logOut() {
        GIDSignIn.sharedInstance()?.signOut()
        
        try! Auth.auth().signOut()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Log out") {
                    logOut()
                }
                Picker("Sort By: ", selection: $selectedSortBy) {
                    ForEach(SortBy.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                
            }
            .navigationTitle("Decks")
        }
        
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
