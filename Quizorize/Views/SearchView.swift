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

    var body: some View {
        CustomNavigationView(view: AnyView(Search(deckListViewModel: deckListViewModel, filteredItems: $filteredItems)), title: "Search") { text in
            if text != "" {
                self.filteredItems = deckListViewModel.deckViewModels.filter({ deckVM in
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
    @State private var showActivitySheet = false
    @State private var showDeckOptions = false
    
    let layout = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(filteredItems) { deckVM in
                    //TODO: Drag and drop into folders using onLongPressGesture
                    VStack {
                        NavigationLink(
                            //TODO: Pass down TMVM and FLVM from home
                            destination: DeckView(deckListViewModel: deckListViewModel, deckViewModel: deckVM, flashcardListViewModel: FlashcardListViewModel(deckVM.deck), testModeViewModel: TestModeViewModel(deckVM.deck)),
                            label: {
                            Image("deck1")
                                .resizable()
                                .frame(width: 100, height: 100)
                        })

                        Button {
                            showDeckOptions.toggle()
                        } label: {
                            HStack {
                                Text(deckVM.deck.title)
                                    .font(.caption)
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                            }
                        }
                        .actionSheet(isPresented: $showDeckOptions, content: {
                            ActionSheet(title: Text(""), message: Text(""), buttons: [
                                .default(Text("Edit deck")) { deckListViewModel.update(deckVM.deck) },
                                .destructive(Text("Delete deck").foregroundColor(Color.red)) { deckListViewModel.remove(deckVM.deck) },
                                .cancel()
                            ])
                        })
                    }
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
