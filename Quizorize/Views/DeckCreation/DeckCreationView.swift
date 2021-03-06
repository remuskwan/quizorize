//
//  DeckCreationView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 4/6/21.
//

import SwiftUI

//MARK: types of alerts for DeckCreation
enum DeckCreationAlert {
    case deckTitleEmpty, lessThanTwo, hasAnyFieldsEmpty, cancel
}

struct DeckCreationView: View {
    
    init(deckListViewModel: DeckListViewModel, didCreateDeck: @escaping (_ deck: Deck, _ flashcards: [Flashcard]) -> Void) {
        self.deckListViewModel = deckListViewModel
        self.deckCreationVM = DeckCreationViewModel()
        self.didCreateDeck = didCreateDeck
        
        self.createOrEdit = "Create"
        self.pageTitle = "New Deck"
    }
    
    init(deckListViewModel: DeckListViewModel, deckVM: DeckViewModel, flashcardListVM: FlashcardListViewModel, didCreateDeck: @escaping (_ deck: Deck, _ flashcards: [Flashcard]) -> Void) {
        self.deckListViewModel = deckListViewModel
        self.deckCreationVM = DeckCreationViewModel(flashcardListVM: flashcardListVM, deckVM: deckVM)
        self.didCreateDeck = didCreateDeck
        
        self.createOrEdit = "Finish"
        self.pageTitle = "Edit Deck"
    }

    @ObservedObject var deckCreationVM: DeckCreationViewModel
    @ObservedObject var deckListViewModel: DeckListViewModel

    @Environment(\.presentationMode) var presentationMode
    
    @State private var deckTitle = ""
    @State private var isDeckTitleTapped = false

    @State private var showAlert = false
    @State private var activeAlert: DeckCreationAlert = .cancel
    
    var createOrEdit: String
    var pageTitle: String
    var didCreateDeck: (_ deck: Deck, _ flashcards: [Flashcard]) -> Void
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {

                    deckTitleView
                        .padding()
                    

                    Divider()
                    
                    EditButton()
                    
                    flashcardView()
                        .frame(minHeight: geometry.size.height * DimensionConstants.flashcardViewRatio)
                    
                    Spacer()

                    addCards
                        .frame(height: geometry.size.height / DimensionConstants.addCardsDimensionDivisor)

                }
            }
            .navigationBarTitle(Text(self.pageTitle), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.activeAlert = .cancel
                        self.showAlert = true
                        //presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if deckCreationVM.hasDeckTitleEmpty() {
                            self.activeAlert = .deckTitleEmpty
                            self.showAlert = true
                            return
                        } else if deckCreationVM.hasAnyFieldsEmpty() {
                            self.activeAlert = .hasAnyFieldsEmpty
                            self.showAlert = true
                        } else if deckCreationVM.hasLessThanTwoCards() {
                            self.activeAlert = .lessThanTwo
                            self.showAlert = true
                        }
                        let flashcards: [Flashcard] = deckCreationVM.getFinalisedFlashcards()
                        let deck = Deck(title: deckCreationVM.deckTitle)
                        didCreateDeck(deck, flashcards)
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(createOrEdit)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                switch self.activeAlert {
                case .deckTitleEmpty:
                    return Alert(title: Text(StringConstants.reqNotMetAlertTitle),
                                 message: Text(StringConstants.alertDeckTitleNotFound)
                                    ,
                                 dismissButton: .cancel(Text("Ok"))
                                 )
                case .hasAnyFieldsEmpty:
                    return Alert(title: Text(StringConstants.reqNotMetAlertTitle),
                                 message: Text(StringConstants.alertMissingField),
                                 dismissButton: .cancel(Text("Ok"))
                    )
                
                case .lessThanTwo:
                    return Alert(title: Text(StringConstants.reqNotMetAlertTitle),
                                 message: Text(StringConstants.alertLessThanTwoCard),
                                 dismissButton: .cancel(Text("Ok"))
                    )
                    
                case .cancel:
                    return Alert(title: Text(StringConstants.cancelAlertTitle),
                                 message: Text(StringConstants.cancelAlertMessage),
                                 primaryButton: .cancel(Text("Stay")),
                                 secondaryButton: .default(Text("Leave")) {
                                    self.presentationMode.wrappedValue.dismiss()
                                 })
                }
                
            }
        }
    }
    
    var deckTitleView: some View {
        TextField(StringConstants.titlePlaceholder, text: $deckCreationVM.deckTitle,
                  onEditingChanged: { edit in
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
                        
                        DeckCreationFlashCard(deckCreationVM: deckCreationVM, question: emptyFlashcard.prompt, answer: emptyFlashcard.answer, index: index)
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
                .listSeparatorStyle(style: .none, colorStyle: .white)
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
        
        static let cancelAlertTitle = "Note"
        static let cancelAlertMessage = "You will lose all edits made to this deck"
        
        static let reqNotMetAlertTitle = "Error"
        static let alertTitle = "Error!"
        static let alertMissingField = "You must fill up all fields in your deck"
        static let alertLessThanTwoCard = "You must create a minimum of two flashcards."
        static let alertDeckTitleNotFound = "You must have a deck title."
        static let alertDismissMessage = "Got it!"
    }
}

//MARK: CustomTextField (with a rect line and a caption at the bottom)
struct CustomTextFieldStyle: TextFieldStyle {
    
    @Binding var isFieldTapped: Bool
    
    var captionTitle: String
    
    var imageName: String
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            HStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: DrawingConstants.fieldImageHeight)
                
                configuration
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
            }
            .font(.body)

            Rectangle().frame(height: DrawingConstants.rectWidth)
                        .foregroundColor(isFieldTapped ? DrawingConstants.rectLineColorAfterTap : DrawingConstants.rectLineColorBeforeTap)
            
            HStack {
                Text(captionTitle)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .font(.caption.bold())
        }
    }
    
    private struct DrawingConstants {
        static let rectWidth: CGFloat = 3
        static let rectLineColorBeforeTap = Color.black
        static let rectLineColorAfterTap =  Color(hex: "15CDA8")
        
        static let easeInDuration: Double = 0.1
        
        static let fieldImageHeight: CGFloat = 21
        
    }
    
}


//MARK: To remove line between lists. (does not work)
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
