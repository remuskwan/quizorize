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
    
    @Namespace var bottomID

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
                    
                    EditButton()
                    
                    flashcardView()

                    Button {
                        deckCreationVM.addFlashcard()
                        
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
                        //TODO: Add flashcards to deck
                        let flashcards: [Flashcard] = deckCreationVM.getFinalisedFlashcards()
                        print(flashcards)
                        let deck = Deck(title: self.deckTitle)
                        deckListViewModel.add(deck)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Create")
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            //            .navigationBarColor(UIColor(Color.accentColor), textColor: UIColor(Color.white))
        }
    }
    
    //MARK: Iterate Flashcards
    @ViewBuilder
    private func flashcardView() -> some View {
        /*
         AspectHScroll(items: deckCreationVM.flashcards, aspectRatio: 2/3) { emptyFlashcard in
         DeckCreationFlashCard(deckCreationVM: deckCreationVM, index: deckCreationVM.flashcards.firstIndex(where: {$0 == emptyFlashcard})!)
         }
         */
        
        GeometryReader { fullView in
            ScrollViewReader { scrollReader in
                List {
                    ForEach(deckCreationVM.flashcards) { emptyFlashcard in
                        let index = deckCreationVM.flashcards.firstIndex(where: {$0 == emptyFlashcard})!
                        DeckCreationFlashCard(deckCreationVM: deckCreationVM, index: index)
                            .frame(height: fullView.size.height * 0.25)
                            .background(RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                                            )
                    }
                    .onDelete { indexSet in
                        deckCreationVM.removeFields(at: indexSet)
                    }
                    
                }
                .listSeparatorStyle(style: .none, colorStyle: .clear)

            }
        }

    }
}

struct ListSeparatorStyle: ViewModifier {
    
    let style: UITableViewCell.SeparatorStyle
    let colorStyle: UIColor
    
    func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().separatorStyle = self.style
                UITableView.appearance().separatorColor = self.colorStyle
            }
    }
}

extension View {
    
    func listSeparatorStyle(style: UITableViewCell.SeparatorStyle, colorStyle: UIColor) -> some View {
        ModifiedContent(content: self, modifier: ListSeparatorStyle(style: style, colorStyle: colorStyle))
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
