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

    @State private var selectedSortBy = SortBy.date
    @State private var showActivitySheet = false
//    @State private var showingActionSheet = false
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
//                    HStack {
//                        Spacer()
//                        Picker("Sort By: ", selection: $selectedSortBy) {
//                            ForEach(SortBy.allCases, id: \.self) {
//                                Text($0.rawValue)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                        .frame(width: 200, height: 20, alignment: .center)
//                        Spacer()
//                        Button(action: {
//                            self.showListView.toggle()
//                        }, label: {
//                            Image(systemName: "list.dash")
//                        })
//                    }
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 12)
                    
                    if !self.showListView {
                        GeometryReader { geometry in
                            LazyVGrid(
                                columns: layout,
                                spacing: 20
                            ) {
                                Button(action: {
                                    showingCreateDeck.toggle()
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
                                        }
                                        .frame(width: geometry.size.width * 0.25
                                               , height: geometry.size.width * 0.3)
                                        Text("New")
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    
                                })
//                                .actionSheet(isPresented: $showingActionSheet) {
//                                    ActionSheet(title: Text(""), message: Text(""), buttons: [
//                                        .default(Text("Deck")) {self.showingCreateDeck = true},
//                                        .cancel()
//                                    ])
//                                }
                                .sheet(isPresented: $showingCreateDeck, content: {
                                    DeckCreationView(deckListViewModel: deckListViewModel) { deck, flashcards in
                                        deckListViewModel.add(deck: deck, flashcards: flashcards)
                                    }
                                    
                                })
                                    
                                ForEach(deckListViewModel.sortDeckVMs(SortBy.date)) { deckVM in
                                    let deck = deckVM.deck
                                    let flashcardListViewModel = FlashcardListViewModel(deck)
                                    let testModeViewModel = TestModeViewModel(deck)
                                    
                                    DeckIconView(
                                        deckVM: deckVM,
                                        deckListViewModel: deckListViewModel,
                                        flashcardListViewModel: flashcardListViewModel,
                                        testModeViewModel: testModeViewModel, deck: deck,
                                        width: geometry.size.width * 0.3,
                                        height: geometry.size.width * 0.3
                                    )
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

struct DeckIconView: View {
    @ObservedObject var deckVM: DeckViewModel
    @ObservedObject var deckListViewModel: DeckListViewModel
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    @State private var showDeckOptions = false
    @State private var deleteDeckConfirm = false
    @State private var showingEditDeck = false
    
    let deck: Deck
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        VStack {
            NavigationLink(
                destination:
                    DeckView(deckListViewModel: deckListViewModel, deckViewModel: deckVM, flashcardListViewModel: flashcardListViewModel, testModeViewModel: testModeViewModel),
                label: {
                    Image("deck1")
                        .resizable()
                })
                .frame(width: width, height: height)
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
                EditDeckView(deckViewModel: deckVM, deckListViewModel: deckListViewModel, flashcardListViewModel: flashcardListViewModel)
            }
            Text(deckVM.getDateCreated())
                .font(.caption2.weight(.light))
            Spacer()
        }
    }
}

enum SortBy: String, CaseIterable {
    case date = "Date"
    case name = "Name"
    case type = "Type"
}

struct EditDeckView: View {
    @ObservedObject var deckViewModel: DeckViewModel
    @ObservedObject var deckListViewModel: DeckListViewModel
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    
    @State private var carouselLocation = 0
    
    var body: some View {
        DeckCreationView(deckListViewModel: self.deckListViewModel, deckVM: self.deckViewModel, flashcardListVM: self.flashcardListViewModel) { deck, flashcards in
           
            //Add the new flashcards
            let newFlashcards = flashcards.filter { flashcard in
                let existingFlashcards = flashcardListViewModel
                    .flashcardViewModels
                    .map { flashcardVM in
                        return flashcardVM.flashcard
                    }
                
                return !existingFlashcards.contains(flashcard)
                }

            print("\(newFlashcards.count) created")
            deckViewModel.addFlashcards(newFlashcards)
            
            //Edit the existing flashcards
            let editedFlashcards = flashcards
                .filter { flashcard in
                    flashcardListViewModel.flashcardViewModels
                        .map { flashcardVM in
                            flashcardVM.flashcard
                        }
                        .contains(where: {$0.id == flashcard.id
                                    && $0.dateAdded == flashcard.dateAdded
                                    && ($0.prompt != flashcard.prompt || $0.answer != flashcard.answer)})
                }
            
            print("\(editedFlashcards.count) updated")
            deckViewModel.updateFlashcards(editedFlashcards)

            //Remove flashcards
            let deletedFlashcards = flashcardListViewModel.flashcardViewModels
                .map { flashcardVM in
                    flashcardVM.flashcard
                }
                .filter { currentFlashcard in
                    !flashcards
                        .contains(currentFlashcard)
                }
            
            print("\(deletedFlashcards.count) deleted")
            deckViewModel.deleteFlashcards(deletedFlashcards)
            
            self.carouselLocation = 0
            print("Carousel location is now\(carouselLocation)")
        }
    }
}

//struct DeckListDeckView: View {
//
//    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .bottomLeading) {
//                Image("deck1")
//                    .resizable()
//                    .frame(width: 110, height: 110)
//
//                ZStack {
//                    Circle()
//                        .foregroundColor(.red)
//
//                    Text("\(flashcardListViewModel.badgeNumber)")
//                        .foregroundColor(.white)
//                        .font(Font.system(size: 12))
//                }
//                .frame(width: 20, height: 20)
//                .offset(x: (( 2 * 1) - 1) * (geometry.size.width / (2 * 1) ), y: -30)
//                .opacity(flashcardListViewModel.hasCardsDue ? 1 : 0)
//            }
//        }
//    }
//}

//struct DecksView_Previews: PreviewProvider {
//    @State private var isPresented = false
//    @State private var isBlurred = false
//
//    static var previews: some View {
//        HomeView()
//    }
//}
