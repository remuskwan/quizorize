//
//  DeckCreationView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 4/6/21.
//

import SwiftUI

struct DeckCreationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var deckCreationVM: DeckCreationViewModel = DeckCreationViewModel()
    @ObservedObject var deckListViewModel: DeckListViewModel
    
    
    @State private var deckTitle = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    TextField("Untitled deck", text: $deckTitle)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width / 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.accentColor, lineWidth: 1.5)
                        )
                        .padding()
                    
                    Divider()
                    
                    
                    flashcardView()
                    
                    Spacer()
                    
                    Button {
                        deckCreationVM.addField()
                        
                    } label: {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(height: geometry.size.height / 15)
                            .overlay(Image(systemName:
                                            "plus").foregroundColor(.white))
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
            }
            .navigationBarTitle(Text("New deck"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let deck = Deck(title: self.deckTitle)
                        deckListViewModel.add(deck)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Create")
                    }
                }
            }
//            .navigationBarColor(UIColor(Color.accentColor), textColor: UIColor(Color.white))
        }
        
    }
    
    //MARK: Iterate Flashcards
    @ViewBuilder
    private func flashcardView() -> some View {
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(deckCreationVM.EmptyFlashcards) { emptyFlashcard in
                        DeckCreationFlashCard(deckCreationVM: deckCreationVM, index: self.deckCreationVM.EmptyFlashcards.firstIndex(where: { $0 == emptyFlashcard})!)
                            .frame(width: fullView.size.width * 0.925, height: fullView.size.height)
                            .padding()
                    }
                }
            }
            .background(Color.white)
        }
    }
}



//struct DeckCreationView_Previews: PreviewProvider {
//    
//    @State private var isBlurred = false
//    
//    static var previews: some View {
//        DeckCreationView()
//            .environmentObject(AuthViewModel())
//    }
//}
