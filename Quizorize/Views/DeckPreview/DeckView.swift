//
//  DeckPreviewView.swift
//  Quizorize
//
//  Created by Remus Kwan on 16/6/21.
//

import SwiftUI

struct DeckView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var deckListViewModel: DeckListViewModel
    @ObservedObject var deckViewModel: DeckViewModel
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    @ObservedObject var testModeViewModel: TestModeViewModel

    @State private var page = 0
    @State private var action: Int? = 0
    
    @State private var showingEditDeck = false
    @State private var showPracticeModeView = false
    @State private var showTestModeView = false
    @State private var showDeckOptions = false
    @State private var deleteDeckConfirm = false
    
    //Temp, delete after
    @State private var isExamMode = false
    
    @State private var carouselLocation = 0
    
    var body: some View {
        GeometryReader { geoProxy in
            VStack(spacing: 0) {
                
                CarouselView(carouselLocation: self.$carouselLocation, itemHeight: UIScreen.main.bounds.height * 0.30, flashcardListVM: flashcardListViewModel)

                Spacer()
                
                generalInfo
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                
                buttons
                    .frame(height: UIScreen.main.bounds.height * 0.20)

                Spacer()
                
            }
            .navigationBarTitle(deckViewModel.deck.title, displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showDeckOptions.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .fullScreenCover(isPresented: $showPracticeModeView, content: practiceContent)
            .fullScreenCover(isPresented: $showTestModeView, content: testContent)
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
                   
                    //Add the new flashcards
                    let newFlashcards = flashcards.filter { flashcard in
                        let existingFlashcards = flashcardListViewModel
                            .flashcardViewModels
                            .map { flashcardVM in
                                return flashcardVM.flashcard
                            }
                        
                        return !existingFlashcards.contains(flashcard)
                        }

                    print("\(newFlashcards.count) created")
                    deckViewModel.addFlashcards(newFlashcards)
                    
                    //Edit the existing flashcards
                    let editedFlashcards = flashcards
                        .filter { flashcard in
                            flashcardListViewModel.flashcardViewModels
                                .map { flashcardVM in
                                    flashcardVM.flashcard
                                }
                                .contains(where: {$0.id == flashcard.id
                                            && $0.dateAdded == flashcard.dateAdded
                                            && ($0.prompt != flashcard.prompt || $0.answer != flashcard.answer)})
                        }
                    
                    print("\(editedFlashcards.count) updated")
                    deckViewModel.updateFlashcards(editedFlashcards)

                    //Remove flashcards
                    let deletedFlashcards = flashcardListViewModel.flashcardViewModels
                        .map { flashcardVM in
                            flashcardVM.flashcard
                        }
                        .filter { currentFlashcard in
                            !flashcards
                                .contains(currentFlashcard)
                        }
                    
                    print("\(deletedFlashcards.count) deleted")
                    deckViewModel.deleteFlashcards(deletedFlashcards)
                    
                    self.carouselLocation = 0
                    print("Carousel location is now\(carouselLocation)")
                }
            }

        }
        .onDisappear {
            //self.deckViewModel.toggleExamMode()
        }
    }
    
    var generalInfo: some View {
        GeometryReader { geo in
            VStack {
                /*
                HStack {
                    Text(deckViewModel.deck.title)
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                }
                */
                HStack {
                    Text("Username")
                        .font(.title2.bold())
                    
                    Divider()

                    Text("\(flashcardListViewModel.flashcardViewModels.count) flashcards")
                        .font(.title2.bold())
                    
                    Spacer()
                }
                
                /*
                HStack(spacing: 0) {
                    Toggle(isOn: self.$isExamMode, label: {
                        Text("Exam Mode")
                            .font(.body.bold())
                    })
                    /*
                    .onChange(of: deckViewModel.deck.isExamMode) { value in
                        deckViewModel.toggleExamMode()
                        print(value)
                    }
                    */
                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))

                    Spacer()
                        .frame(minWidth: geo.size.width * 0.55)
                }
                */

            }
            .padding()
        }
    }
    
    var buttons: some View {
        GeometryReader { buttonGProxy in
            
            HStack(spacing: 0) {
                //Spacer()
                
                Button {
                    self.showPracticeModeView.toggle()
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
                .buttonStyle(PreviewButtonStyle())
                .padding(.horizontal)
                .frame(width: buttonGProxy.size.width / ButtonConstants.buttonCount, height: buttonGProxy.size.height / ButtonConstants.buttonCount , alignment: .center)

                Button {
                    self.showTestModeView.toggle()
                } label: {
                    VStack {
                        Spacer()
                        
                        Image("testmode")
                            .resizable()
                            .scaledToFit()
                        Text("Test")
                            .font(.body.bold())
                        
                        Spacer()
                    }
                }
                .buttonStyle(PreviewButtonStyle())
                .padding(.horizontal)
                .frame(width: buttonGProxy.size.width / ButtonConstants.buttonCount, height: buttonGProxy.size.height / ButtonConstants.buttonCount , alignment: .center)

                //Spacer()
            }
            
        }
    }
    
    private struct ButtonConstants {
        static let buttonCount: CGFloat = 2 //MARK: Change this with more buttons
    }
    
    func practiceContent() -> some View {
        var practiceFlashcards = [FlashcardViewModel]()

        practiceFlashcards.append(contentsOf: flashcardListViewModel.flashcardViewModels)

        /*
        practiceFlashcards.append(contentsOf: flashcardListViewModel.flashcardViewModels)
        practiceFlashcards.map { flashcardVM in
            flashcardVM.flipped = false
        }
        */
        
        
        
        return PracticeModeView(practiceModeViewModel: PracticeModeViewModel(practiceFlashcards), prevExamScore: deckViewModel.deck.examModePrevScore) { updatedFlashcards, score in
            
            let sortedUpdatedFlashcards = updatedFlashcards.sorted {
                $0.nextDate! < $1.nextDate!
            }
            
            self.deckViewModel.updateFlashcards(sortedUpdatedFlashcards)
            self.deckViewModel.updatePrevExamScore(score)
        }
    }
    
    func testContent() -> some View {
        TestModeView(testModeViewModel: testModeViewModel, deckTitle: deckViewModel.deck.title)
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
                        .shadow(color: DrawingConstants.shadowColor, radius: DrawingConstants.shadowRadius, x: DrawingConstants.shadowX, y: DrawingConstants.flippedShadowY)
                    Text(flashcardVM.flashcard.answer).rotation3DEffect(Angle.degrees(180), axis: (1, 0, 0))
                        .font(.body.bold())
                        .opacity(flipDegrees < 90 ? 0 : 1)
                        .padding()
                }
            }
            .lineLimit(nil)
            .rotation3DEffect(Angle.degrees(flipDegrees), axis: (1, 0, 0))
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
        
        static let flippedShadowY: CGFloat = -3
    }
}



//MARK: ButtonStyle for Preview
struct PreviewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        GeometryReader { geoProxy in
            ZStack(alignment: .center) {
                configuration.label
                    .foregroundColor(configuration.isPressed ? DrawingConstants.tappedColor : DrawingConstants.notTappedColor)
            }
            /*
            .background(RoundedRectangle(cornerRadius: DrawingConstants.rectCornerRadius)
                            .fill(Color.white)
                            .frame(height: geoProxy.size.height * 0.95)
                            .offset(x: 0, y: -2)
            )
            */
            .padding(5)
            .frame(width: geoProxy.size.width, height: geoProxy.size.height, alignment: .center)
            .background(RoundedRectangle(cornerRadius: DrawingConstants.rectCornerRadius)
                            .fill(Color.white)
                            .shadow(color: configuration.isPressed ? DrawingConstants.bgShadowColorAfterTap : DrawingConstants.bgShadowColorBeforeTap, radius: DrawingConstants.bgShadowRadius, x: DrawingConstants.bgShadowX, y: DrawingConstants.bgShadowY)
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
        
        static let bgShadowColorBeforeTap: Color = .accentColor.opacity(0.4)
        static let bgShadowColorAfterTap: Color = Color(hex: "15CDA8").opacity(0.7)
        
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

/*
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
*/

/*
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
 */
