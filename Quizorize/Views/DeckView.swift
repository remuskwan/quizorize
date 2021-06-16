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
    
    @State var showDeckOptions = false
    var body: some View {
        ZStack {
            VStack {
                
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
                .default(Text("Edit deck")) { deckListViewModel.update(deckViewModel.deck) },
                .destructive(Text("Delete deck").foregroundColor(Color.red)) { deckListViewModel.remove(deckViewModel.deck) },
                .cancel()
            ])
        })
    }
}

//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView()
//    }
//}
