//
//  DeckPreviewView.swift
//  Quizorize
//
//  Created by Remus Kwan on 16/6/21.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject var deckListViewModel: DeckListViewModel
    @ObservedObject var deckViewModel: DeckViewModel
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    
    @State private var showPracticeModeView = false
    
    @State var showDeckOptions = false
    var body: some View {
        ZStack {
            Button("Begin Practice") {
                showPracticeModeView.toggle()
            }
        }
        .navigationTitle(deckViewModel.deck.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showDeckOptions.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .actionSheet(isPresented: $showDeckOptions, content: {
            ActionSheet(title: Text(""), message: Text(""), buttons: [
                .default(Text("Add flashcard")) { flashcardListViewModel.add(Flashcard(prompt: "hello", answer: "world")) },
                .destructive(Text("Delete deck").foregroundColor(Color.red)) { deckListViewModel.remove(deckViewModel.deck) },
                .cancel()
            ])
        })
        .fullScreenCover(isPresented: $showPracticeModeView, content: coverContent)
    }
    
    func coverContent() -> some View {
        PracticeModeView(flashcardListViewModel: flashcardListViewModel)
    }
}

//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView()
//    }
//}
