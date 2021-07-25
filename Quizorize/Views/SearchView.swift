//
//  SearchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 1/6/21.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var deckListViewModel: DeckListViewModel
    @State var filteredItems = [DeckViewModel]()
    @State var isNavBarHidden = false
    
    var body: some View {
        CustomNavigationView(view: AnyView(Search(deckListViewModel: deckListViewModel, filteredItems: $filteredItems, isNavBarHidden: $isNavBarHidden)), title: "Search", isHidden: isNavBarHidden) { text in
            if text != "" {
                self.filteredItems = deckListViewModel.deckViewModels
                    .filter({ deckVM in
                        deckVM.deck.title.lowercased().contains(text.lowercased())
                })
            } else {
                self.filteredItems = [DeckViewModel]()
            }
        } onCancel: {
            self.filteredItems = [DeckViewModel]()
        }
        .ignoresSafeArea()
    }
}

struct Search: View {
    @ObservedObject var deckListViewModel: DeckListViewModel

    @Binding var filteredItems: [DeckViewModel]
    @Binding var isNavBarHidden: Bool

    let layout = [
        GridItem(.adaptive(minimum: 120))
    ]

    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(filteredItems) { deckVM in
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

            }

        }
        .onAppear {
            self.isNavBarHidden = false
        }
        .padding(.horizontal, 12)
    }


}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
