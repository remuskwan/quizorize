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
    @State private var isDeckTitleTapped = false
    
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
            //            .navigationBarColor(UIColor(Color.accentColor), textColor: UIColor(Color.white))
        }
    }
    
    var deckTitleView: some View {
        
        
        TextField(StringConstants.titlePlaceholder, text: $deckTitle,
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
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
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


//MARK: To remove line between lists.
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


//MARK: Keyboard responder


//struct DeckCreationView_Previews: PreviewProvider {
//    
//    @State private var isBlurred = false
//    
//    static var previews: some View {
//        DeckCreationView()
//            .environmentObject(AuthViewModel())
//    }
//}
