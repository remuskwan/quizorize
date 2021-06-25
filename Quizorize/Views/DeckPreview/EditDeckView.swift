//
//  EditDeckView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 25/6/21.
//

import SwiftUI

/*
struct EditDeckView: View {
    @Environment(\.presentationMode) var presentationMode
    

    @State private var deckTitle = ""
    @State private var isDeckTitleTapped = false
    @State private var isNotValid = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    deckTitleView
                        .padding()

                    Divider()
                    
                    flashcardView()
                        .frame(minHeight: geometry.size.height * DimensionConstants.flashcardViewRatio)
                    
                    Spacer()

                    addCards
                        .frame(height: geometry.size.height / DimensionConstants.addCardsDimensionDivisor)

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
                        isNotValid = deckCreationVM.hasAnyFieldsEmpty() || deckCreationVM.hasDeckTitleEmpty() || deckCreationVM.hasLessThanTwoCards()
                        if isNotValid {
                            return
                        }
                        let flashcards: [Flashcard] = deckCreationVM.getFinalisedFlashcards()
                        let deck = Deck(title: self.deckTitle)
                        deckListViewModel.add(deck: deck, flashcards: flashcards)
//                        guard let deckId = deck.id else { return }
//                        flashcards.forEach { flashcard in
//                            flashcardListViewModel.add(flashcard, deckId: deckId)
//                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Create")
                    }
                }
            }
            .alert(isPresented: $isNotValid) {
                if (deckCreationVM.hasDeckTitleEmpty()) {
                    return Alert(title: Text(StringConstants.alertTitle), message: Text(StringConstants.alertDeckTitleNotFound), dismissButton: .default(Text(StringConstants.alertDismissMessage)))
                } else if (deckCreationVM.hasLessThanTwoCards()) {
                    return Alert(title: Text(StringConstants.alertTitle), message: Text(StringConstants.alertLessThanTwoCard), dismissButton: .default(Text(StringConstants.alertDismissMessage)))
                } else {
                    return Alert(title: Text(StringConstants.alertTitle), message: Text(StringConstants.alertMissingField), dismissButton: .default(Text(StringConstants.alertDismissMessage)))
                }
            }
            //            .navigationBarColor(UIColor(Color.accentColor), textColor: UIColor(Color.white))
        }
    }
    
    var deckTitleView: some View {
        
        
        TextField(StringConstants.titlePlaceholder, text: $deckTitle,
                  onEditingChanged: { edit in
                    deckCreationVM.deckTitle = deckTitle
                    withAnimation(.easeIn(duration: DrawingConstants.easeInDuration)) {
                        isDeckTitleTapped = edit
                    }
                  })
            .textFieldStyle(CustomTextFieldStyle(isFieldTapped: $isDeckTitleTapped, captionTitle: StringConstants.title, imageName: "title"))

    }
    
    var addCards: some View {
        Button {
            deckCreationVM.addFlashcard()

        } label: {
            Circle()
                .fill(Color.accentColor)
                .overlay(Image(systemName:
                                "plus").foregroundColor(.white))
        }
        .shadow(color: DrawingConstants.deckCreationShadowColor, radius: DrawingConstants.deckCreationShadowRadius, x: DrawingConstants.deckCreationShadowX, y: DrawingConstants.deckCreationShadowY)
    }
    

    //MARK: Iterate Flashcards
    @ViewBuilder //should be used if there are conditions inside this view.
    private func flashcardView() -> some View {
        GeometryReader { fullView in
            ScrollViewReader { scrollReader in
                List {
                    ForEach(deckCreationVM.flashcards) { emptyFlashcard in
                        let index = deckCreationVM.flashcards.firstIndex(where: {$0 == emptyFlashcard})!
                        DeckCreationFlashCard(deckCreationVM: deckCreationVM, index: index)
                            .background(RoundedRectangle(cornerRadius: DrawingConstants.deckCreationFlashcardCornerRadius)
                                            .fill(Color.white)
                                            .shadow(color: DrawingConstants.deckCreationShadowColor, radius: DrawingConstants.deckCreationShadowRadius, x: DrawingConstants.deckCreationShadowX, y: DrawingConstants.deckCreationShadowY)
                                            )
                            .frame(height: DimensionConstants.deckCreationFlashcardHeight)
                            .id(emptyFlashcard.id)

                    }
                    .onDelete { indexSet in
                        deckCreationVM.removeFields(at: indexSet)
                    }
                    .onChange(of: deckCreationVM.flashcards.count) { _ in
                        withAnimation(.default) {
                            scrollReader.scrollTo(deckCreationVM.flashcards.last?.id, anchor: .center)
                        }
                    }
                }
                .listSeparatorStyle(style: .none, colorStyle: .clear)
                .environment(\.defaultMinListRowHeight, fullView.size.height * DimensionConstants.ScrollViewRatio)
            }
        }
        

    }
    
    private struct DrawingConstants {
        static let easeInDuration: Double = 0.1
        
        static let deckCreationShadowColor = Color.black.opacity(0.2)
        static let deckCreationShadowRadius: CGFloat = 3
        static let deckCreationShadowX: CGFloat = 0
        static let deckCreationShadowY: CGFloat = 3
        
        static let deckCreationFlashcardCornerRadius: CGFloat = 6
    }
    
    private struct DimensionConstants {
        static let flashcardViewRatio: CGFloat = 0.5
        static let addCardsDimensionDivisor: CGFloat = 15
        
        static let deckCreationFlashcardHeight: CGFloat = 155
        
        static let ScrollViewRatio: CGFloat = 0.35
        
    }
    
    private struct AnimationConstants {
        static let deckCreationDelay = 1.0
    }
    
    private struct StringConstants {
        static let title = "TITLE"
        
        static let titlePlaceholder = "Subject, chapter, unit"
        
        static let alertTitle = "Important!"
        static let alertMissingField = "You must fill up all fields in your deck"
        static let alertLessThanTwoCard = "You must create a minimum of two flashcards."
        static let alertDeckTitleNotFound = "You must have a deck title."
        static let alertDismissMessage = "Got it!"
        
    }
}

struct EditDeckView_Previews: PreviewProvider {
    static var previews: some View {
        EditDeckView()
    }
}
 */
