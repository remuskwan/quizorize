//
//  DecksView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var deckListViewModel = DeckListViewModel()

    var body: some View {
        TabView {
            DeckListView(deckListViewModel: deckListViewModel)
                .tabItem { Label("Decks", systemImage: "square.grid.2x2.fill") }
            SearchView(deckListViewModel: deckListViewModel)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            ProfileView(profileViewModel: ProfileViewModel())
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}

struct DeckListView: View {
    @ObservedObject var deckListViewModel: DeckListViewModel

    @State private var showingEditDeck = false
    @State private var selectedSortBy = SortBy.date
    @State private var showActivitySheet = false
    @State private var showDeckOptions = false
    @State private var deleteDeckConfirm = false
    @State private var showingActionSheet = false
    @State private var showingCreateDeck = false
    @State private var showListView = false

    let layout = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Divider()
                        .padding(.horizontal)
                    HStack {
                        Spacer()
                        Picker("Sort By: ", selection: $selectedSortBy) {
                            ForEach(SortBy.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200, height: 20, alignment: .center)
                        Spacer()
                        //                        Button(action: {
                        //                            self.showListView.toggle()
                        //                        }, label: {
                        //                            Image(systemName: "list.dash")
                        //                        })
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    
                    if !self.showListView {
                        GeometryReader { geometry in
                            LazyVGrid(
                                columns: layout,
                                spacing: 20
                            ) {
                                Button(action: {
                                    showingActionSheet.toggle()
                                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                                    impactLight.impactOccurred()
                                }, label: {
                                    VStack {
                                        ZStack {
                                            Image(systemName: "plus")
                                            RoundedRectangle(cornerRadius: 5)
                                                .strokeBorder(
                                                    style: StrokeStyle(
                                                        lineWidth: 2,
                                                        dash: [3]
                                                    )
                                                )
                                            //                                                            .frame(width: 90, height: 110)
                                            //                                                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                        }
                                        .frame(width: geometry.size.width * 0.25
                                               , height: geometry.size.width * 0.3)
                                        Text("New")
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    
                                })
                                .actionSheet(isPresented: $showingActionSheet) {
                                    ActionSheet(title: Text(""), message: Text(""), buttons: [
                                        .default(Text("Deck")) {self.showingCreateDeck = true},
                                        .cancel()
                                    ])
                                }
                                .sheet(isPresented: $showingCreateDeck, content: {
                                    DeckCreationView(deckListViewModel: deckListViewModel) { deck, flashcards in
                                        deckListViewModel.add(deck: deck, flashcards: flashcards)
                                    }
                                    
                                })
                                    
                                ForEach(deckListViewModel.sortDeckVMs(self.selectedSortBy)) { deckVM in
                                    let deck = deckVM.deck
                                    let flashcardListViewModel = FlashcardListViewModel(deck)
                                    let testModeViewModel = TestModeViewModel(deck)
                                    
                                    VStack {
                                        NavigationLink(
                                            destination:
                                                DeckView(deckListViewModel: deckListViewModel, deckViewModel: deckVM, flashcardListViewModel: flashcardListViewModel, testModeViewModel: testModeViewModel),
                                            label: {
                                                Image("deck1")
                                                    .resizable()
                                            })
                                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
//                                            .frame(minWidth: 80, idealWidth: 110)
//                                            .frame(minHeight: 80, idealHeight: 110)
                                        Button {
                                            showDeckOptions.toggle()
                                        } label: {
                                            HStack(spacing: 2) {
                                                Text(deck.title)
                                                    .font(.footnote)
                                                Image(systemName: "chevron.down")
                                                    .font(.system(size: 8))
                                            }
                                        }
                                        .actionSheet(isPresented: $showDeckOptions, content: {
                                            ActionSheet(title: Text(""), message: Text(""), buttons: [
                                                .default(Text("Edit Deck")) { self.showingEditDeck = true },
                                                .destructive(Text("Delete Deck").foregroundColor(Color.red)) {
                                                    self.deleteDeckConfirm.toggle()
                                                },
                                                .cancel()
                                            ])
                                        })
                                        .alert(isPresented: $deleteDeckConfirm, content: {
                                            Alert(title: Text("Are you sure you want to delete this deck?"), message: nil, primaryButton: .cancel(), secondaryButton:.destructive(Text("Delete"), action: {
                                                deckListViewModel.remove(deck)
                                            }))
                                        })
                                        .sheet(isPresented: $showingEditDeck) {
                                            DeckCreationView(deckListViewModel: self.deckListViewModel, deckVM: deckVM, flashcardListVM: flashcardListViewModel) { deck, flashcards in
                                                
                                                //Update the new flashcards
                                                flashcards
                                                    .filter { flashcard in
                                                        flashcardListViewModel.flashcardViewModels
                                                            .map { flashcardVM in
                                                                flashcardVM.flashcard
                                                            }
                                                            .contains(where: {$0 != flashcard})
                                                    }
                                                    .forEach { flashcard in
                                                        flashcardListViewModel.add(flashcard)
                                                    }
                                                
                                                //Edit the existing flashcards
                                                flashcards
                                                    .filter { flashcard in
                                                        flashcardListViewModel.flashcardViewModels
                                                            .map { flashcardVM in
                                                                flashcardVM.flashcard
                                                            }
                                                            .contains(where: {$0 == flashcard && $0.prompt != flashcard.prompt && $0.answer != flashcard.answer})
                                                    }
                                                    .forEach { flashcard in
                                                        flashcardListViewModel.update(flashcard)
                                                    }
                                                
                                                //Remove flashcards
                                                flashcardListViewModel.flashcardViewModels
                                                    .map { flashcardVM in
                                                        flashcardVM.flashcard
                                                    }
                                                    .filter { currentFlashcard in
                                                        flashcards
                                                            .contains(where: {$0 != currentFlashcard})
                                                    }
                                                    .forEach { deletedFlashcard in
                                                        flashcardListViewModel.remove(deletedFlashcard)
                                                    }
                                                
                                            }
                                        }
                                        Text(deckVM.getDateCreated())
                                            .font(.caption2.weight(.light))
//                                            .padding(2)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(12)
                        }
                    }
//                    else {
//                        List {
//                            NewButton(deckListViewModel: deckListViewModel)
//                            ForEach(deckListViewModel.sortDeckVMs(self.selectedSortBy)) { deckVM in
//                                let deck = deckVM.deck
//                                let flashcardListViewModel = FlashcardListViewModel(deck)
//                                let testModeViewModel = TestModeViewModel(deck)
//
//                                NavigationLink(
//                                    destination:
//                                        DeckView(deckListViewModel: deckListViewModel, deckViewModel: deckVM, flashcardListViewModel: flashcardListViewModel, testModeViewModel: testModeViewModel),
//                                    label: {
//                                        HStack {
//                                            Image("deck1")
//                                                .resizable()
//                                                .frame(width: 110, height: 110)
//                                                .padding()
//                                            VStack {
//                                                Text(deck.title)
//                                            }
//                                            Spacer()
//
//                                            Button {
//                                                showDeckOptions.toggle()
//                                            } label: {
//                                                HStack {
//                                                    Image(systemName: "chevron.down")
//                                                }
//                                            }
//
//                                        }
//                                    })
//
//                            }
//                        }
//                    }
                    
                }
                
            }
            .navigationTitle("Decks")
            .navigationBarBackButtonHidden(true)
//            .toolbar {
//                ToolbarItem {
//                    Button {
//                        showActivitySheet.toggle()
//                    } label: {
//                        Image(systemName: "bell")
//                    }
//                }
//            }
//            .sheet(isPresented: $showActivitySheet) {
//                ActivityView()
//            }
            
            
            /*
            .textFieldAlert(isPresented: $userDoesNotHaveDisplayName) { () -> TextFieldAlert in
                TextFieldAlert(title: "Create Display Name", message: "Welcome to Quizorize! Please enter your display name below", text: $displayName)
            }
            */
        }
    }
}

//struct ActivityView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//            }
//                .navigationTitle("Activity")
//                .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}

enum SortBy: String, CaseIterable {
    case date = "Date"
    case name = "Name"
    case type = "Type"
}

//struct NewButton: View {
//    @ObservedObject var deckListViewModel: DeckListViewModel
//    @State private var showingActionSheet = false
//    @State private var showingCreateDeck = false
//    var body: some View {
//        VStack {
//            Button(action: {
//                showingActionSheet.toggle()
//                let impactLight = UIImpactFeedbackGenerator(style: .light)
//                impactLight.impactOccurred()
//            }, label: {
//                GeometryReader { geometry in
//                    VStack {
//                        ZStack {
//                            Image(systemName: "plus")
//                                .background(RoundedRectangle(cornerRadius: 5)
//                                                .strokeBorder(
//                                                    style: StrokeStyle(
//                                                        lineWidth: 2,
//                                                        dash: [3]
//                                                    )
//                                                )
//                                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
//                                )
//    //                        RoundedRectangle(cornerRadius: 5)
//    //                            .strokeBorder(
//    //                                style: StrokeStyle(
//    //                                    lineWidth: 2,
//    //                                    dash: [3]
//    //                                )
//    //                            )
//    //                            .frame(width: 90, height: 110)
//                        }
//                        Text("New")
//                            .font(.footnote)
//                    }
//                }
//
//            })
//
//        }
//        .actionSheet(isPresented: $showingActionSheet) {
//            ActionSheet(title: Text(""), message: Text(""), buttons: [
//                .default(Text("Deck")) {self.showingCreateDeck = true},
//                .cancel()
//            ])
//        }
//        .sheet(isPresented: $showingCreateDeck, content: {
//            DeckCreationView(deckListViewModel: deckListViewModel) { deck, flashcards in
//                deckListViewModel.add(deck: deck, flashcards: flashcards)
//            }
////            CreateDeck(deckListViewModel: DeckListViewModel(), flashcardViewModel: FlashcardViewModel())
//        })
//    }
//}

struct DeckListDeckView: View {
    
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                Image("deck1")
                    .resizable()
                    .frame(width: 110, height: 110)
                
                ZStack {
                    Circle()
                        .foregroundColor(.red)
                    
                    Text("\(flashcardListViewModel.badgeNumber)")
                        .foregroundColor(.white)
                        .font(Font.system(size: 12))
                }
                .frame(width: 20, height: 20)
                .offset(x: (( 2 * 1) - 1) * (geometry.size.width / (2 * 1) ), y: -30)
                .opacity(flashcardListViewModel.hasCardsDue ? 1 : 0)
            }
        }
        
    }
}

//struct DecksView_Previews: PreviewProvider {
//    @State private var isPresented = false
//    @State private var isBlurred = false
//
//    static var previews: some View {
//        HomeView()
//    }
//}
