//
//  PracticeModeView.swift
//  Quizorize
//
//  Created by Remus Kwan on 22/6/21.
//

import SwiftUI

struct PracticeModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reminderVM: ReminderViewModel
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel

    @State private var showOptionsSheet = false
    @State private var dismissOptionsSheet = false
    
    @State private var showingNotice: Bool = false
    @State private var progressValue = 0.0
    @State private var correctCount = 0.0
    @State private var totalQuestionsAnswered = 0.0
    @State var prevExamScore: Double
    
    
    @State private var showingTest = false
    @State private var showingEndTestAlert = false
    @State private var showHint = false
    
    

    //To update DB
    var didFinishDeck: (_ updatedFlashcards: [Flashcard], _ score: Double, _ reminderTime: TimeInterval) -> Void
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        /*
                         HStack {
                         Button {
                         /*
                         if self.examModeVM.isExamMode && examModeVM.cardsAreDue(flashcards: practiceModeViewModel.practiceFlashcards) {
                         didFinishDeck(examModeVM.getUpdatedFlashcards(), correctCount / totalQuestionsAnswered)
                         }
                         */
                         presentationMode.wrappedValue.dismiss()
                         resetCards()
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
                         */

                        if !self.showingTest {
                            List {
                                Section {
                                    Button {
                                        self.showingTest = true
                                    } label: {
                                        Text("Start Practice")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: geometry.size.width * 0.8, height: 45)
                                    .listRowBackground(Color.accentColor)
                                }
                                

                                Section(header:
                                            Text("Reminders"),
                                        footer:
                                            VStack(alignment: .center) {
                                              Text("Let Quizorize plan your next studying date!").font(.footnote)
                                            })
                                             {
                                    Toggle(isOn: $practiceModeViewModel.isSpacedRepetitionOn, label: {
                                        Text("Spaced Repetition")
                                    })
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))
                                }
                                
                            }
                            .listStyle(InsetGroupedListStyle())
                            .toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(systemName: "multiply")
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        self.showHint = true
                                    } label: {
                                        Image(systemName: "questionmark.circle")
                                            .frame(width: 24, height: 24)
                                    }
                                }
                            })
                        } else {
                            practiceModeView
                        }
                    }
                    /*
                    //                OptionsSheet(showingOptionsSheet: $showOptionsSheet, dismissOptionsSheet: $dismissOptionsSheet, height: geometry.size.height * 0.8) {
                    //                    OptionsSheetContent()
                    //                        .padding()
                    //                }
                    */
                    
                    if showingNotice {
                        ShowHelp(showingNotice: $showingNotice)
                            .animation(.easeInOut(duration: 1))
                            .offset(y: -300) //Not sure how to dynamically adjust this, giving fixed value for now
                    }
                }
                .sheet(isPresented: self.$showHint) {
                    PracticeHintView()
                }
                
            }
        }
    }
    
    var practiceModeView: some View {
        VStack {
            if practiceModeViewModel.isTesting {
                Text("\(practiceModeViewModel.counter) / \(practiceModeViewModel.count)")

                //testView
                testView
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                if self.practiceModeViewModel.isSpacedRepetitionOn {
                                    self.showingEndTestAlert = true
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Image(systemName: "multiply")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.showHint = true
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .frame(width: 24, height: 24)
                            }
                        }
                    })
                    .alert(isPresented: $showingEndTestAlert, content: {
                        Alert(title: Text("Are you sure you want to end this practice?"),
                              message: Text("Spaced Repetition results from this round of flashcards will NOT be saved."),
                              primaryButton: .cancel(),
                              secondaryButton: .default(Text("End Test")) {
                                presentationMode.wrappedValue.dismiss()
                                if self.practiceModeViewModel.isSpacedRepetitionOn && !self.practiceModeViewModel.changedFinalisedFlashcards.isEmpty {
                                    print("Current score is \(correctCount / totalQuestionsAnswered)")
                                    
                                    didFinishDeck(self.practiceModeViewModel.finalisedFlashcards, correctCount / totalQuestionsAnswered, self.practiceModeViewModel.getNotificationTimeInterval())
                                    
                                    print("Deck and flashcards successfully updated")
                                    
                                }
                                self.practiceModeViewModel.reset()
                              })
                    })
            }
            else {
                //Put Exam Summary here.
                summaryView
                    .onAppear {
                        self.practiceModeViewModel.pushToFinalisedFlashcards()
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                self.practiceModeViewModel.reset()
                                if self.practiceModeViewModel.isSpacedRepetitionOn && !self.practiceModeViewModel.changedFinalisedFlashcards.isEmpty {
                                    print("Current score is \(correctCount / totalQuestionsAnswered)")
                                    
                                    didFinishDeck(self.practiceModeViewModel.finalisedFlashcards, correctCount / totalQuestionsAnswered, self.practiceModeViewModel.getNotificationTimeInterval())
                                    
                                }
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "multiply")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.showHint = true
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .frame(width: 24, height: 24)
                            }
                        }
                    })
            }
        }
    }
    
    var testView: some View {
        GeometryReader { geometry in
            VStack {
                ProgressView(value: Double(practiceModeViewModel.counter), total: Double(practiceModeViewModel.count))
                    .frame(width: geometry.size.width * 0.7, alignment: .center)
                
                FlashcardListView(practiceModeViewModel: practiceModeViewModel, showingNotice: $showingNotice, correctCount: $correctCount, totalQuestionsAnswered: $totalQuestionsAnswered)
                
                /*
                 if (examModeVM.isExamMode && examModeVM.cardsAreDue(flashcards: practiceModeViewModel.practiceFlashcards)) {
                 } else {
                 FlashcardListView(practiceModeViewModel: practiceModeViewModel, showingNotice: $showingNotice, correctCount: $correctCount, totalQuestionsAnswered: $totalQuestionsAnswered)
                 }
                 */
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var summaryView: some View {
        //Took most of this from TestModeSummary
        ZStack {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Text(practiceModeViewModel.isSpacedRepetitionOn ? "Your aggregate score for all rounds" : "Your Latest Score")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)

                        SummaryProgressBar(progress: $progressValue)
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .padding()
                            .onAppear {
                                print("previous practice score is \(prevExamScore)")
                                self.progressValue = (correctCount / totalQuestionsAnswered).isNaN ? self.prevExamScore : (correctCount / totalQuestionsAnswered)
                            }
                        
                        if practiceModeViewModel.isSpacedRepetitionOn {
                            Text("Date of Completion: \(practiceModeViewModel.dateOfCompletionInString())")
                                .padding()
                            
                            Text("Next Study Date: \(practiceModeViewModel.earliestDateInString())")
                                .padding()
                        }


                        if practiceModeViewModel.isSpacedRepetitionOn && practiceModeViewModel.intervalIsZero() {
                                Text("Looks like you need to study more 🤓")
                                    .padding()
                                
                                Button(action: {
                                    //didFinishDeck(examModeVM.getUpdatedFlashcards(), self.examModeVM.getPercentageScore())
                                    self.practiceModeViewModel.reset()
                                }, label: {
                                    Text("Study Again Now")
                                        .font(.headline)
                                        .frame(width: geometry.size.width * 0.8, height: 32)
                                })
                        }
                        else {
                            
                            Text("You have finished the deck!")
                                .padding()
                            
                            if !practiceModeViewModel.isSpacedRepetitionOn {
                                Button {
                                   self.practiceModeViewModel.reset()
                                    if practiceModeViewModel.isSpacedRepetitionOn {
                                        self.correctCount = 0
                                        self.totalQuestionsAnswered = 0
                                    }
                                } label: {
                                Text("Reset")
                                .font(.headline)
                                .frame(width: geometry.size.width * 0.8, height: 32)
                                }
                            }
                            
                            if practiceModeViewModel.isSpacedRepetitionOn {
                                Text("(Flashcards will be shown on the study date at 4PM)")
                                    
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
        }
        
    }
    
}

struct OptionsSheetContent: View {
    var body: some View {
        Text("Options")
    }
}

struct FlashcardListView: View {
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel

    @Namespace private var animation
    
    //@State private var cardsMovedBacK: [String: Bool] = [String: Bool]()
    @Binding var showingNotice: Bool
    @Binding var correctCount: Double
    @Binding var totalQuestionsAnswered: Double
    
    @GestureState private var isDragging = false
    
    var body: some View {
        
        VStack {
            Spacer()
            ZStack {
                //if practiceModeViewModel.counter != practiceModeViewModel.count  {
                ForEach(practiceModeViewModel.actualPracticeFlashcards) { flashcard in
                    FlashcardView(flashcard: flashcard,
                                  practiceModeViewModel: practiceModeViewModel,
                                  uuid: flashcard.id!)
                        .showIndicators(translation: self.practiceModeViewModel.distancesTravelled[flashcard.id!] ?? 0, isFlipped: practiceModeViewModel.getFlipStatusOf(uuid: flashcard.id!), isDragging: self.isDragging)
                        .zIndex(self.practiceModeViewModel.zIndex(of: flashcard))
                        .offset(x: self.offset(for: flashcard).width, y: self.offset(for: flashcard).height)
                        .offset(y: self.practiceModeViewModel.deckOffset(of: flashcard))
                        .scaleEffect(x: self.practiceModeViewModel.scale(of: flashcard), y: self.practiceModeViewModel.scale(of: flashcard))
                        .rotationEffect(self.rotation(for: flashcard))
                        .gesture(
                            DragGesture()
                                .onChanged({ drag in
                                    let didNotFlip = practiceModeViewModel.getFlipStatusOf(uuid: flashcard.id!) == false
                                    
                                    if self.practiceModeViewModel.activeCard == nil {
                                        self.practiceModeViewModel.activeCard = flashcard
                                    }
                                    guard flashcard == self.practiceModeViewModel.activeCard else { return }
                                    
                                    withAnimation(.default) {
                                        self.practiceModeViewModel.topCardOffset = drag.translation
                                        
                                        if !didNotFlip {
                                            self.practiceModeViewModel.setTranslationWidthOf(id: flashcard.id!, width: drag.translation.width)
                                        }
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
                                    
                                    let allRequirementsMet = cardMovesBack && (practiceModeViewModel.counter < practiceModeViewModel.count) && practiceModeViewModel.getFlipStatusOf(uuid: flashcard.id!)
                                    
                                    let didNotFlip = practiceModeViewModel.getFlipStatusOf(uuid: flashcard.id!) == false
                                    
                                    
                                    withAnimation(.default) {
                                        self.practiceModeViewModel.activeCard = nil
                                        self.practiceModeViewModel.topCardOffset = .zero
                                        if allRequirementsMet {
                                            self.practiceModeViewModel.counter += 1
                                            self.practiceModeViewModel.moveToBack(flashcard)
                                            if cardFailedMovesBack {
                                                self.practiceModeViewModel.addAndUpdateFailed(flashcard)
                                            } else {
                                                self.practiceModeViewModel.addAndUpdatePassed(flashcard)
                                                self.correctCount += 1
                                            }
                                            self.totalQuestionsAnswered += 1
                                        } else if didNotFlip {
                                            self.practiceModeViewModel.moveToFront(flashcard)
                                            self.showingNotice = true
                                        } else {
                                            self.practiceModeViewModel.setTranslationWidthOf(id: flashcard.id!, width: 0)
                                            self.practiceModeViewModel.moveToFront(flashcard)
                                        }
                                    }
                                })
                        )
                }
            }
            Spacer()
            
            if !practiceModeViewModel.isSpacedRepetitionOn {
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
        
        //examModeVM.reset()
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
    //@ObservedObject var flashcardViewModel: FlashcardViewModel
    var flashcard: Flashcard
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    
    var uuid: String
    
    var body: some View {
        VStack {
            Spacer()
            if !practiceModeViewModel.getFlipStatusOf(uuid: uuid) /* flashcardViewModel.flipped */ {
                Text(/*flashcardViewModel.*/flashcard.prompt)
                    .font(.title)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text(/*flashcardViewModel.*/flashcard.answer)
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

//struct OptionsSheet<Content: View>: View {
//    let content: Content
//    @Binding var showingOptionsSheet: Bool
//    @Binding var dismissOptionsSheet: Bool
//    let height: CGFloat
//
//    init(showingOptionsSheet: Binding<Bool>, dismissOptionsSheet: Binding<Bool>, height: CGFloat, @ViewBuilder content: () -> Content) {
//        self.height = height
//        _showingOptionsSheet = showingOptionsSheet
//        _dismissOptionsSheet = dismissOptionsSheet
//        self.content = content()
//    }
//
//    var body: some View {
//        ZStack {
//            GeometryReader { _ in
//                EmptyView()
//
//            }
//            .background(Color.red.opacity(0.3))
//            .opacity(showingOptionsSheet ? 1 : 0)
//            .animation(.easeIn)
//            .onTapGesture {
//                dismissOptionsSheet.toggle()
//            }
//            VStack {
//                Spacer()
//                VStack {
//                    content
//                    Button("Dismiss") {
//                        dismissOptionsSheet.toggle()
//                    }
//                }
//            }
//            .background(Color.white)
//            .frame(height: self.height)
//            .offset(y: dismissOptionsSheet && showingOptionsSheet ? 0 : 300)
//            .animation(.default.delay(0.2))
//        }
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct BlurView: UIViewRepresentable {
//    var style: UIBlurEffect.Style
//
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
//        return view
//    }
//
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//    }
//}

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
