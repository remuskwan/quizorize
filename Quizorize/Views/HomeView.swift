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
    @State private var showingCreateDeck = false
    @State private var showListView = false
    @State var isNavBarHidden = false
    
    let layout = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Divider()
                        .padding(.horizontal)
                    
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
                                        testModeViewModel: testModeViewModel,
                                        isNavBarHidden: self.$isNavBarHidden,
                                        deck: deck,
                                        width: geometry.size.width * 0.3,
                                        height: geometry.size.width * 0.3
                                    )
                                }
                            }
                            .padding(12)
                        }
                    }
                }
                
            }
            .navigationTitle("Decks")
            .navigationBarBackButtonHidden(true)
            .onAppear {
                self.isNavBarHidden = false
            }
        }
    }
}

struct DeckIconView: View {
    @ObservedObject var deckVM: DeckViewModel
    @ObservedObject var deckListViewModel: DeckListViewModel
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    @State private var showDeckOptions = false
    @State private var deleteDeckConfirm = false
    @State private var showingEditDeck = false
    
    @Binding var isNavBarHidden: Bool
    
    let deck: Deck
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        VStack {
            NavigationLink(
                destination:
                    DeckView(deckListViewModel: deckListViewModel, deckViewModel: deckVM, flashcardListViewModel: flashcardListViewModel, testModeViewModel: testModeViewModel, isNavBarHidden: self.$isNavBarHidden),
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

struct DecksView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
