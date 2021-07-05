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
    
    @State private var page = 0
    @State private var action: Int? = 0
    
    @State private var showingEditDeck = false
    @State private var showPracticeModeView = false
    @State private var showDeckOptions = false
    @State private var deleteDeckConfirm = false
    
    var randomAnyViews = [AnyView(Text("Hi")), AnyView(Text("Bye")), AnyView(Text("baba")), AnyView(Text("Mama"))]

    var body: some View {
        GeometryReader { geoProxy in
            VStack(spacing: 0) {
                
                /*
                GeometryReader { carouselGProxy in
                    Carousel(width: UIScreen.main.bounds.width, page: $page, height: carouselGProxy.frame(in: .global).height, flashcardListViewModel: flashcardListViewModel)

                }
                .frame(height: geoProxy.size.height * 0.7)
                */
                
                CarouselView(itemHeight: geoProxy.size.height * 0.5, flashcardListVM: flashcardListViewModel)

                Spacer()
                
                generalInfo
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                
                buttons
                    .frame(height: UIScreen.main.bounds.height * 0.15)

                Spacer()
                
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
            .fullScreenCover(isPresented: $showPracticeModeView, content: coverContent)
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
                    deckListViewModel.remove(deckViewModel.deck)
                }))
            })
            .sheet(isPresented: $showingEditDeck) {
                DeckCreationView(deckListViewModel: self.deckListViewModel, deckVM: self.deckViewModel, flashcardListVM: self.flashcardListViewModel) { deck, flashcards in
                    
                    //Update the new flashcards
                    flashcards
                        .filter { flashcard in
                            flashcardListViewModel.flashcardViewModels
                                .map { flashcardVM in
                                    flashcardVM.flashcard
                                }
                                .contains(where: {$0 != flashcard})
                        }
                        .forEach { flashcard in
                            flashcardListViewModel.add(flashcard)
                        }
                    
                    //Edit the existing flashcards
                    flashcards
                        .filter { flashcard in
                            flashcardListViewModel.flashcardViewModels
                                .map { flashcardVM in
                                    flashcardVM.flashcard
                                }
                                .contains(where: {$0 == flashcard && $0.prompt != flashcard.prompt && $0.answer != flashcard.answer})
                        }
                        .forEach { flashcard in
                            flashcardListViewModel.update(flashcard)
                        }
                    
                    //Remove flashcards
                    flashcardListViewModel.flashcardViewModels
                        .map { flashcardVM in
                            flashcardVM.flashcard
                        }
                        .filter { currentFlashcard in
                            flashcards
                                .contains(where: {$0 != currentFlashcard})
                        }
                        .forEach { deletedFlashcard in
                            flashcardListViewModel.remove(deletedFlashcard)
                        }
                    
                    print(flashcardListViewModel.flashcardViewModels.count)
                    
                }
            }
            
        }
    }
    
    var generalInfo: some View {
        VStack {
            HStack {
                Text(deckViewModel.deck.title)
                    .font(.title)
                
                Spacer()
                
            }
            
            HStack {
                Text("Username")
                    .font(.body)
                
                Divider()
                
                Text("\(flashcardListViewModel.flashcardViewModels.count) flashcards")
                
                Spacer()
            }
        }
        .padding()
    }
    
    var buttons: some View {
        GeometryReader { buttonGProxy in
            HStack {
                Spacer()
                
                Button {
                    showPracticeModeView.toggle()
                } label: {
                    VStack {
                        Spacer()
                        
                        Image("testmode")
                            .resizable()
                            .scaledToFit()
                        Text("Practice")
                            .font(.body.bold())
                        
                        Spacer()
                    }
                }
                .frame(width: buttonGProxy.size.width * ButtonConstants.buttonRatio)
                .buttonStyle(PreviewButtonStyle())
                
                
                Spacer()
            }
            
        }
    }
    
    private struct ButtonConstants {
        static let buttonRatio: CGFloat = 0.45
    }
    
    func coverContent() -> some View {
        var practiceFlashcards = [FlashcardViewModel]()
        
        practiceFlashcards.append(contentsOf: flashcardListViewModel.flashcardViewModels)
        print(practiceFlashcards)
        practiceFlashcards.map { flashcardVM in
            flashcardVM.flipped = false
        }
        return PracticeModeView(practiceModeViewModel: PracticeModeViewModel(practiceFlashcards))
    }
}

struct Carousel: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Carousel.Coordinator(parent1: self)
    }
    var width: CGFloat
    @Binding var page: Int
    var height: CGFloat
    
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let total = width * CGFloat(flashcardListViewModel.flashcardViewModels.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator
        
        //Embedding swiftUI View into UIView
        
        let view1 = UIHostingController(rootView: PreviewList(flashcardListViewModel: flashcardListViewModel, page: $page))
        view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
        
        view1.view.backgroundColor = .clear
        
        view.addSubview(view1.view)
        
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        DispatchQueue.main.async {
            uiView.contentSize = CGSize(width: width * CGFloat(flashcardListViewModel.flashcardViewModels.count), height: 1.0)
        }
        
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: Carousel
        
        init(parent1: Carousel) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            
            print(page)
            
            self.parent.page = page
        }
    }
}

struct PreviewList: View {
    
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    @Binding var page: Int
    
    var body: some View {
        GeometryReader { fullView in
            //Replace with HStack(spacing: 0) for reverting to original
            HStack(spacing: 0) {
                
                ForEach(flashcardListViewModel.flashcardViewModels) { flashcard in
                    PreviewFlashcard(
                                     index: flashcardListViewModel.flashcardViewModels.firstIndex(where: {$0.id == flashcard.id})!,
                        width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,
                                     flashcardVM: flashcard
                    )
                    .aspectRatio(3/2, contentMode: .fit)
                    .frame(height: fullView.size.height * Dimensions.cardFrameRatio)


                }
            }
        }
    }
    
    private struct Dimensions {
        static let stackHPadding: CGFloat = 20
        static let cardWidthRatio: CGFloat = 0.6
        
        static let cardFrameRatio: CGFloat = 0.75
    }
}

struct PreviewFlashcard: View, Animatable {
    var index: Int

    
    var width: CGFloat
    var height: CGFloat
    var flashcardVM: FlashcardViewModel
    @State var isFlipped = false
    
    var body: some View {
        let flipDegrees = isFlipped ? 180.0 : 0.0
        
        VStack(spacing: 0) {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.bgCornerRadius)
                
                if flipDegrees < 90 {
                    shape.fill().foregroundColor(.accentColor)
                        .shadow(color: DrawingConstants.shadowColor, radius: DrawingConstants.shadowRadius, x: DrawingConstants.shadowX, y: DrawingConstants.shadowY)
                    Text(flashcardVM.flashcard.prompt)
                        .foregroundColor(DrawingConstants.notFlippedTextColor)
                        .font(.body.bold())
                        .opacity(flipDegrees < 90 ? 1 : 0)
                        .padding()
                    
                } else {
                    shape.fill().foregroundColor(.white)
                        .shadow(color: DrawingConstants.shadowColor, radius: DrawingConstants.shadowRadius, x: DrawingConstants.shadowX, y: DrawingConstants.shadowY)
                    Text(flashcardVM.flashcard.answer).rotation3DEffect(Angle.degrees(180), axis: (0, 1, 0))
                        .font(.body.bold())
                        .opacity(flipDegrees < 90 ? 0 : 1)
                        .padding()
                }
            }
            .lineLimit(nil)
            .rotation3DEffect(Angle.degrees(flipDegrees), axis: (0, 1, 0))
            .onTapGesture {
                withAnimation(.spring()) {
                    isFlipped.toggle()
                }
            }
            .animation(.spring())
        }
        .frame(width: self.width, height: self.height)
        .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        
    }
    
    private struct DrawingConstants {
        static let notFlippedTextColor: Color = .white
        static let flippedTextColor: Color = .black
        static let backgroundColor: Color = .white
        static let bgCornerRadius: CGFloat = 10
        
        static let shadowColor: Color = Color.black.opacity(0.2)
        static let shadowRadius: CGFloat = 3
        static let shadowX: CGFloat = 0
        static let shadowY: CGFloat = 3
    }
}


//MARK: PageControl functionality (doesn't seem to be working)
struct PageControl: UIViewRepresentable {
    
    @ObservedObject var flashcardListVM: FlashcardListViewModel
    
    @Binding var page: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        view.numberOfPages = flashcardListVM.flashcardViewModels.count
        
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        //Updating PageControl here whenever page changes
        DispatchQueue.main.async {
            uiView.currentPage = self.page
        }
    }
}




//MARK: ButtonStyle for Preview
struct PreviewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        GeometryReader { geoProxy in
            ZStack(alignment: .leading) {
                configuration.label
                    .foregroundColor(configuration.isPressed ? DrawingConstants.tappedColor : DrawingConstants.notTappedColor)
                    .frame(width: geoProxy.size.width, height: geoProxy.size.height)
            }
            .background(RoundedRectangle(cornerRadius: DrawingConstants.rectCornerRadius)
                            .fill(Color.white)
                            .frame(height: geoProxy.size.height * 0.95)
                            .offset(x: 0, y: -2)
            )
            .background(RoundedRectangle(cornerRadius: DrawingConstants.rectCornerRadius)
                            .fill(configuration.isPressed ? DrawingConstants.tappedColor : DrawingConstants.notTappedBgColor)
                            .shadow(color: configuration.isPressed ? DrawingConstants.bgShadowColorAfterTap : DrawingConstants.bgShadowColorBeforeTap, radius: DrawingConstants.bgShadowRadius, x: DrawingConstants.bgShadowX, y: DrawingConstants.bgShadowY)
                            .frame(height: geoProxy.size.height)
            )
            
        }
        
    }
    
    private struct DrawingConstants {
        static let notTappedColor: Color = .black
        static let notTappedBgColor: Color = Color(hex: "FF7BBF")
        static let tappedColor: Color = Color(hex: "15CDA8")
        
        static let rectCornerRadius: CGFloat = 10
        static let offsetX: CGFloat = 0
        static let offsetY: CGFloat = 3
        
        static let bgShadowColorBeforeTap: Color = .black.opacity(0.4)
        static let bgShadowColorAfterTap: Color = .black.opacity(0.7)
        
        static let bgShadowRadius: CGFloat = 3
        static let bgShadowX: CGFloat = 0
        static let bgShadowY: CGFloat = 3
        
    }
}


//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView()
//    }
//}
