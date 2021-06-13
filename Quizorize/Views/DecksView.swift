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
        TabView {
            DeckList(deckListViewModel: DeckListViewModel())
                .tabItem { Label("Decks", systemImage: "square.grid.2x2.fill") }
            SearchView()
                .tabItem {Label("Search", systemImage: "magnifyingglass")}
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}

struct DeckList: View {
    @ObservedObject var deckListViewModel: DeckListViewModel
    @State private var selectedSortBy = SortBy.date

    let layout = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Picker("Sort By: ", selection: $selectedSortBy) {
                        ForEach(SortBy.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200, height: 20, alignment: .center)
                    .padding()
                    
                    LazyVGrid(columns: layout, spacing: 20) {
                        NewButton()
                        ForEach(deckListViewModel.decks) { deck in
                            VStack {
                                Image(systemName: "folder.fill")
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                                Text(deck.title)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .navigationTitle("Decks")
            .navigationBarBackButtonHidden(true)
        }
    }
}

enum SortBy: String, CaseIterable {
    case date = "Date"
    case name = "Name"
    case type = "Type"
}

struct NewButton: View {
    @State private var showingActionSheet = false
    @State private var showingCreateDeck = false
    var body: some View {
        VStack {
            Button(action: {
                showingActionSheet.toggle()
            }, label: {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: [5]
                        )
                    )
                    .frame(width: 80, height: 100)
            })
            Text("New")
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), message: Text(""), buttons: [
                .default(Text("Deck")) {self.showingCreateDeck = true},
                .cancel()
            ])
        }
        .sheet(isPresented: $showingCreateDeck, content: {
            CreateDeck(deckListViewModel: DeckListViewModel())
        })
    }
}

struct CreateDeck: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var deckListViewModel: DeckListViewModel
    
    var body: some View {
        Button("Add deck") {
            let deck = Deck(title: "Math")
            deckListViewModel.add(deck)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct DecksView_Previews: PreviewProvider {
    static var previews: some View {
        DecksView()
    }
}
