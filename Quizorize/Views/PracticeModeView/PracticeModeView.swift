//
//  PracticeModeView.swift
//  Quizorize
//
//  Created by Remus Kwan on 22/6/21.
//

import SwiftUI

struct PracticeModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    @ObservedObject var examModeVM: ExamModeViewModel
    
    @State private var showOptionsSheet = false
    @State private var dismissOptionsSheet = false
    
    @State private var showingNotice: Bool = false
    @State private var progressValue = 0.0
    @State var prevExamScore: Double
    
    //To update DB
    var didFinishDeck: (_ updatedFlashcards: [Flashcard], _ score: Double) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Button {
                            didFinishDeck(examModeVM.getUpdatedFlashcards(), self.examModeVM.getPercentageScore(prevExamScore: self.prevExamScore))
                            resetCards()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "multiply")
                        }
                        .frame(width: 24, height: 24)
                        .padding()
                        Spacer()
                        Text("\(practiceModeViewModel.counter) / \(examModeVM.cardsAreDue(flashcards: practiceModeViewModel.practiceFlashcards) ? examModeVM.cardsDue : practiceModeViewModel.count)")
                        Spacer()
                        //                        Button(action: {
                        //                            showOptionsSheet.toggle()
                        //                            dismissOptionsSheet.toggle()
                        //                        }, label: {
                        //                            Image(systemName: "questionmark.circle")
                        //                                .frame(width: 24, height: 24)
                        //                                .padding()
                        //                        })
                        Image(systemName: "questionmark.circle")
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                    
                    //if (isExamMode + areAnycardsDue+ counter != count) OR (isNotExamMode && counter != count)
                    if (examModeVM.isExamMode && examModeVM.cardsAreDue(flashcards: practiceModeViewModel.practiceFlashcards) && practiceModeViewModel.counter != examModeVM.cardsDue)
                        ||
                        (!examModeVM.isExamMode && practiceModeViewModel.counter != practiceModeViewModel.count) {
                        ProgressView(value: Double(practiceModeViewModel.counter), total: Double(practiceModeViewModel.count))
                            .frame(width: geometry.size.width * 0.7, alignment: .center)
                        
                        if (examModeVM.isExamMode && examModeVM.cardsAreDue(flashcards: practiceModeViewModel.practiceFlashcards)) {
                            FlashcardListView(practiceModeViewModel: practiceModeViewModel, examModeVM: self.examModeVM, showingNotice: $showingNotice)
                        } else {
                            FlashcardListView(practiceModeViewModel: practiceModeViewModel, showingNotice: $showingNotice)
                        }
                    } else {
                        //Put Exam Summary here.
                        summaryView
                            /*
                            .onAppear {
                                if examModeVM.isExamMode {
                                    didFinishDeck(examModeVM.getUpdatedFlashcards(), examModeVM.getPercentageScore())
                                }
                            }
                            */
                    }
                }
                //                OptionsSheet(showingOptionsSheet: $showOptionsSheet, dismissOptionsSheet: $dismissOptionsSheet, height: geometry.size.height * 0.8) {
                //                    OptionsSheetContent()
                //                        .padding()
                //                }
                
                if showingNotice {
                    ShowHelp(showingNotice: $showingNotice)
                        .animation(.easeInOut(duration: 1))
                        .offset(y: -300) //Not sure how to dynamically adjust this, giving fixed value for now
                }
            }
        }
    }
    
    var summaryView: some View {
        //Took most of this from TestModeSummary
        ZStack {
            if examModeVM.isExamMode {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Text("Previous Exam Mode Score")
                            .font(.title.bold())
                        
                        SummaryProgressBar(progress: $progressValue)
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .padding()
                            .onAppear {
                                self.progressValue = self.examModeVM.getPercentageScore(prevExamScore: self.prevExamScore)
                            }
                        
                        Text("Date of Completion: \(examModeVM.dateOfCompletion(of: practiceModeViewModel.practiceFlashcards))")
                            .padding()
                        
                        Text("Next Study Date: \(examModeVM.nextDate(of: practiceModeViewModel.practiceFlashcards))")
                            .padding()
                        
                        if examModeVM.intervalIsZero() {
                            Text("Looks like you need to study more 🤓")
                                .padding()
                            
                            Button(action: {
                                didFinishDeck(examModeVM.getUpdatedFlashcards(), self.examModeVM.getPercentageScore(prevExamScore: self.prevExamScore))
                                resetCards()
                            }, label: {
                                Text("Study Again Now")
                                    .font(.headline)
                                    .frame(width: geometry.size.width * 0.8, height: 32)
                            })
                        }
                        else {
                            Color.clear
                            /*
                            Button {
                                didFinishDeck(examModeVM.getUpdatedFlashcards(), self.examModeVM.getPercentageScore(prevExamScore: self.prevExamScore))
                                examModeVM.turnOffExamMode()
                                resetCards()
                                print(examModeVM.isExamMode)
                            } label: {
                                Text("I still want to practice now")
                                    .font(.headline)
                                    .frame(width: geometry.size.width * 0.8, height: 32)
                            }

                            Text("(This will NOT affect your next study date)")
                                .padding()
                            */
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            } else {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        Text("Congraluations")
                            .font(.title2.bold())
                        
                        Text("You're done!")
                            .font(.body)
                            .padding()
                        
                        Button("Reset") {
                            resetCards()
                        }
                        .padding()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                
            }
            
        }
        
    }
    
    func resetCards() {
        practiceModeViewModel.counter = 0
        practiceModeViewModel.shuffle()
        practiceModeViewModel.flipStatuses =
            practiceModeViewModel.flipStatuses.mapValues { values in
            }
        examModeVM.reset()
    }
    
}

struct OptionsSheetContent: View {
    var body: some View {
        Text("Options")
    }
}


struct FlashcardListView: View {
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    var examModeVM: ExamModeViewModel?
    
    @Namespace private var animation
    
    //@State private var cardsMovedBacK: [String: Bool] = [String: Bool]()
    @Binding var showingNotice: Bool
    
    @GestureState private var isDragging = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                //if practiceModeViewModel.counter != practiceModeViewModel.count  {
                ForEach(practiceModeViewModel.practiceFlashcards) { flashcardVM in
                    let flashcard = flashcardVM.flashcard
                    
                    if examModeVM?.checkIfFlashcardIsDue(flashcard) ?? true {
                        FlashcardView(flashcardViewModel: flashcardVM,
                                      practiceModeViewModel: practiceModeViewModel,
                                      uuid: flashcardVM.id)
                            .showIndicators(translation: self.examModeVM?.distancesTravelled[flashcardVM.id] ?? 0, isFlipped: practiceModeViewModel.getFlipStatusOf(uuid: flashcardVM.id), isDragging: self.isDragging)
                            .zIndex(self.practiceModeViewModel.zIndex(of: flashcard))
                            .offset(x: self.offset(for: flashcard).width, y: self.offset(for: flashcard).height)
                            .offset(y: self.practiceModeViewModel.deckOffset(of: flashcard))
                            .scaleEffect(x: self.practiceModeViewModel.scale(of: flashcard), y: self.practiceModeViewModel.scale(of: flashcard))
                            .rotationEffect(self.rotation(for: flashcard))
                            .gesture(
                                DragGesture()
                                    .onChanged({ drag in
                                        let didNotFlip = practiceModeViewModel.getFlipStatusOf(uuid: flashcardVM.id) == false
                                        
                                        if self.practiceModeViewModel.activeCard == nil {
                                            self.practiceModeViewModel.activeCard = flashcard
                                        }
                                        guard flashcard == self.practiceModeViewModel.activeCard else { return }
                                        
                                        withAnimation(.default) {
                                            self.practiceModeViewModel.topCardOffset = drag.translation
                                            
                                            if !didNotFlip {
                                                self.examModeVM?.setTranslationWidthOf(id: flashcardVM.id, width: drag.translation.width)
                                            }
                                            
                                            /*
                                             if drag.translation.width > 50 && practiceModeViewModel.getFlipStatusOf(uuid: flashcard.id) {
                                             practiceModeViewModel.togglePass(of: flashcard.id)
                                             } else if drag.translation.width < -50 && practiceModeViewModel.getFlipStatusOf(uuid: flashcard.id) {
                                             practiceModeViewModel.toggleFail(of: flashcard.id)
                                             } else {
                                             practiceModeViewModel.toggleNil(of: flashcard.id)
                                             }
                                             */
                                            /*
                                             let cardMovesBack = drag.translation.width < (-1 * dragThreshold) || drag.translation.width > dragThreshold
                                             || drag.predictedEndTranslation.width > dragThreshold
                                             || drag.predictedEndTranslation.width < (-1 * dragThreshold)
                                             
                                             if (cardMovesBack) {
                                             //drag.translation.height < -300 || drag.translation.height > 30) {
                                             }
                                             else {
                                             }
                                             */
                                        }
                                    })
                                    .updating($isDragging) { drag, state, trans in
                                        state = true
                                        print(self.isDragging)
                                    }
                                    .onEnded({ drag in
                                        let dragThreshold: CGFloat = 250
                                        //drag.predictedEndTranslation predicts the width based on how fast the user drags
                                        let cardMovesBack = drag.translation.width < (-1 * dragThreshold) || drag.translation.width > dragThreshold || drag.predictedEndTranslation.width > dragThreshold || drag.predictedEndTranslation.width < (-1 * dragThreshold)
                                        
                                        let cardFailedMovesBack = drag.translation.width < (-1 * dragThreshold) || drag.predictedEndTranslation.width < (-1 * dragThreshold)
                                        
                                        //let cardPassedMovesBack = drag.translation.width > dragThreshold || drag.predictedEndTranslation.width > dragThreshold
                                        
                                        let allRequirementsMet = cardMovesBack && (practiceModeViewModel.counter < practiceModeViewModel.count) && practiceModeViewModel.getFlipStatusOf(uuid: flashcardVM.id)
                                        
                                        let didNotFlip = practiceModeViewModel.getFlipStatusOf(uuid: flashcardVM.id) == false
                                        
                                        
                                        withAnimation(.default) {
                                            self.practiceModeViewModel.activeCard = nil
                                            self.practiceModeViewModel.topCardOffset = .zero
                                            if allRequirementsMet {
                                                self.practiceModeViewModel.counter += 1
                                                self.practiceModeViewModel.moveToBack(flashcard)
                                                if cardFailedMovesBack {
                                                    self.examModeVM?.addAndUpdateFailed(flashcard)
                                                } else {
                                                    self.examModeVM?.addAndUpdatePassed(flashcard)
                                                }
                                            } else if didNotFlip {
                                                self.practiceModeViewModel.moveToFront(flashcard)
                                                self.showingNotice = true
                                            } else {
                                                self.examModeVM?.setTranslationWidthOf(id: flashcardVM.id, width: 0)
                                                self.practiceModeViewModel.moveToFront(flashcard)
                                            }
                                        }
                                    })
                            )
                    }
                }
                /*
                 } else {
                 VStack {
                 /*
                 */
                 if let _ = self.examModeVM {
                 VStack {
                 Text("Congratulations!")
                 .font(.title2.bold())
                 .padding()
                 Text("You have finished your deck for today")
                 Text("To memorize the cards in this deck better, come back on:")
                 
                 Text(self.examModeVM!.nextDate())
                 .bold()
                 Button("Reset") {
                 resetCards()
                 }
                 .padding()
                 }
                 } else {
                 Text("Congraluations")
                 .font(.title2.bold())
                 
                 Text("You're done!")
                 .padding()
                 Button("Reset") {
                 resetCards()
                 }
                 .padding()
                 
                 }
                 }
                 .font(.body)
                 .frame(width: 300, height: 400, alignment: .center)
                 .background(
                 RoundedRectangle(cornerRadius: 10)
                 .foregroundColor(Color.white)
                 .shadow(radius: 2)
                 .frame(width: 300, height: 400)
                 )
                 }
                 */
            }
            Spacer()
            
            if !(examModeVM?.isExamMode ?? false) {
                Button(action: {
                    withAnimation(.spring()) {
                        resetCards()
                    }
                }, label: {
                    Label(
                        title: { Text("Shuffle") },
                        icon: { Image(systemName: "shuffle") }
                    )
                })
                .padding()
            }

        }
        
    }
    
    func resetCards() {
        practiceModeViewModel.counter = 0
        practiceModeViewModel.shuffle()
        practiceModeViewModel.flipStatuses =
            practiceModeViewModel.flipStatuses.mapValues { values in
                return false
            }
        examModeVM?.reset()
    }
    
    func offset(for flashcard: Flashcard) -> CGSize {
        if flashcard != self.practiceModeViewModel.activeCard { return .zero }
        
        return practiceModeViewModel.topCardOffset
    }
    
    func rotation(for flashcard: Flashcard) -> Angle {
        guard let activeCard = self.practiceModeViewModel.activeCard
        else {return .degrees(0)}
        
        if flashcard != activeCard {return .degrees(0)}
        
        return practiceModeViewModel.rotation(for: activeCard, offset: practiceModeViewModel.topCardOffset)
    }
    
}

struct FlashcardView: View {
    @ObservedObject var flashcardViewModel: FlashcardViewModel
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    
    var uuid: String
    
    var body: some View {
        VStack {
            Spacer()
            if !practiceModeViewModel.getFlipStatusOf(uuid: uuid) /* flashcardViewModel.flipped */ {
                Text(flashcardViewModel.flashcard.prompt)
                    .font(.title)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text(flashcardViewModel.flashcard.answer)
                    .font(.title)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .rotation3DEffect(
                        Angle(degrees: 180),
                        axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0))
                    )
            }
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .shadow(radius: 2)
        )
        .rotation3DEffect(/*flashcardViewModel.flipped*/practiceModeViewModel.getFlipStatusOf(uuid: uuid) ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
        .onTapGesture {
            withAnimation(.spring()) {
                //flashcardViewModel.flipped.toggle()
                practiceModeViewModel.toggleFlipStatusOf(uuid: uuid)
            }
        }
        
    }
}

struct SummaryCardView: View {
    var body: some View {
        Text("You're done!")
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.white)
                    .shadow(radius: 2))
    }
}

struct OptionsSheet<Content: View>: View {
    let content: Content
    @Binding var showingOptionsSheet: Bool
    @Binding var dismissOptionsSheet: Bool
    let height: CGFloat
    
    init(showingOptionsSheet: Binding<Bool>, dismissOptionsSheet: Binding<Bool>, height: CGFloat, @ViewBuilder content: () -> Content) {
        self.height = height
        _showingOptionsSheet = showingOptionsSheet
        _dismissOptionsSheet = dismissOptionsSheet
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
                
            }
            .background(Color.red.opacity(0.3))
            .opacity(showingOptionsSheet ? 1 : 0)
            .animation(.easeIn)
            .onTapGesture {
                dismissOptionsSheet.toggle()
            }
            VStack {
                Spacer()
                VStack {
                    content
                    Button("Dismiss") {
                        dismissOptionsSheet.toggle()
                    }
                }
            }
            .background(Color.white)
            .frame(height: self.height)
            .offset(y: dismissOptionsSheet && showingOptionsSheet ? 0 : 300)
            .animation(.default.delay(0.2))
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}

//MARK: Fading view
struct ShowHelp: View {
    @Binding var showingNotice: Bool
    
    
    var body: some View {
        VStack (alignment: .center, spacing: 8) {
            Text("Tap to flip before swiping!")
                .foregroundColor(.black)
                .font(.callout.bold())
        }
        .transition(.scale)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingNotice = false
            })
        })
    }
}

//MARK: Fading indicator
struct ShowIndicator: AnimatableModifier {
    var translation: CGFloat
    var isDragging: Bool
    var isFlipped: Bool
    
    //var cardIsMovedBack: Bool
    
    var animatableData: CGFloat {
        get { translation }
        set { translation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if (translation < 0 && isFlipped /*&& isDragging*/) /*|| cardIsMovedBack*/ {
                Text("I have to work on this... 🥲")
                    .font(.body.bold())
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(DrawingConstants.failColor)
                    .cornerRadius(DrawingConstants.cornerRadius, corners: [.topRight, .topLeft])
                    .opacity(translation <= -30 ? 1 : 0)
                    .offset(y: -175)
                    .animation(.easeInOut)
            }
            else if (translation > 0 && isFlipped /*&& isDragging*/) /*|| cardIsMovedBack*/  {
                Text("Got it! 😋")
                    .font(.body.bold())
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(DrawingConstants.passColor)
                    .cornerRadius(DrawingConstants.cornerRadius, corners: [.topRight, .topLeft])
                    .opacity(translation >= 30 ? 1 : 0)
                    .offset(y: -175)
                    .animation(.easeInOut)
            }
            else {
                
            }
        }
    }
    
    private struct DrawingConstants {
        static let failColor = Color.orange
        static let passColor = Color(hex: "15CDA8")
        
        static let cornerRadius: CGFloat = 10
    }
}

extension View {
    func showIndicators(translation: CGFloat, isFlipped: Bool, isDragging: Bool/*, cardIsMovedBack: Bool*/) -> some View {
        self.modifier(ShowIndicator(translation: translation, isDragging: isDragging, isFlipped: isFlipped/*, cardIsMovedBack: cardIsMovedBack*/))
    }
}

//MARK: Helps to break animating subviews
struct HelperView<Content: View>: UIViewRepresentable {
    let content: () -> Content
    func makeUIView(context: Context) -> UIView {
        let controller = UIHostingController(rootView: content())
        return controller.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

//struct PracticeModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeModeView()
//    }
//}
