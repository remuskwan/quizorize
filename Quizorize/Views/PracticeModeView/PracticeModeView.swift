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
    
    @State private var showOptionsSheet = false
    @State private var dismissOptionsSheet = false
    
    @State private var showingNotice: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "multiply")
                        }
                        .frame(width: 24, height: 24)
                        .padding()
                        Spacer()
                        Text("\(practiceModeViewModel.counter) / \(practiceModeViewModel.count)")
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
                    
                    ProgressView(value: Double(practiceModeViewModel.counter), total: Double(practiceModeViewModel.count))
                        .frame(width: geometry.size.width * 0.7, alignment: .center)
                    
                    FlashcardListView(practiceModeViewModel: practiceModeViewModel, showingNotice: $showingNotice)
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
}

struct OptionsSheetContent: View {
    var body: some View {
        Text("Options")
    }
}


struct FlashcardListView: View {
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    
    @Namespace private var animation
    
    @State private var distanceTravelled: CGFloat = 0
    @Binding var showingNotice: Bool
    
    var flashcardGrader = FlashcardGrader()

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if practiceModeViewModel.counter != practiceModeViewModel.count  {
                    ForEach(practiceModeViewModel.practiceFlashcards) { flashcardVM in
                        let flashcard = flashcardVM.flashcard
                        FlashcardView(flashcardViewModel: flashcardVM,
                                      practiceModeViewModel: practiceModeViewModel,
                                      uuid: flashcardVM.id)
                            .zIndex(self.practiceModeViewModel.zIndex(of: flashcard))
                            .offset(x: self.offset(for: flashcard).width, y: self.offset(for: flashcard).height)
                            .offset(y: self.practiceModeViewModel.deckOffset(of: flashcard))
                            .scaleEffect(x: self.practiceModeViewModel.scale(of: flashcard), y: self.practiceModeViewModel.scale(of: flashcard))
                            .rotationEffect(self.rotation(for: flashcard))
                            .gesture(
                                DragGesture()
                                    .onChanged({ drag in
                                        
                                        if self.practiceModeViewModel.activeCard == nil {
                                            self.practiceModeViewModel.activeCard = flashcard
                                        }
                                        guard flashcard == self.practiceModeViewModel.activeCard else { return }
                                        
                                        withAnimation(.spring()) {
                                            self.practiceModeViewModel.topCardOffset = drag.translation
                                            
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
                                    .onEnded({ drag in
                                        let dragThreshold: CGFloat = 250
                                        //drag.predictedEndTranslation predicts the width based on how fast the user drags
                                        let cardMovesBack = drag.translation.width < (-1 * dragThreshold) || drag.translation.width > dragThreshold || drag.predictedEndTranslation.width > dragThreshold || drag.predictedEndTranslation.width < (-1 * dragThreshold)
                                        
                                        let cardFailedMovesBack = drag.translation.width < (-1 * dragThreshold) || drag.predictedEndTranslation.width < (-1 * dragThreshold)
                                        
                                        let cardPassedMovesBack = drag.translation.width > dragThreshold || drag.predictedEndTranslation.width > dragThreshold
                                        
                                        let allRequirementsMet = cardMovesBack && (practiceModeViewModel.counter < practiceModeViewModel.count) && practiceModeViewModel.getFlipStatusOf(uuid: flashcardVM.id)
                                        
                                        let didNotFlip = practiceModeViewModel.getFlipStatusOf(uuid: flashcardVM.id) == false
                                        
                                        
                                        withAnimation(.spring()) {
                                            self.practiceModeViewModel.activeCard = nil
                                            self.practiceModeViewModel.topCardOffset = .zero
                                            if allRequirementsMet {
                                                self.practiceModeViewModel.counter += 1
                                                self.practiceModeViewModel.moveToBack(flashcard)
                                            } else if didNotFlip {
                                                self.practiceModeViewModel.moveToFront(flashcard)
                                                self.showingNotice = true
                                            } else {
                                                self.practiceModeViewModel.moveToFront(flashcard)
                                            }
                                        }
                                    })
                                
                            )
                    }
                } else {
                    VStack {
                        Text("You're done!")
                            .padding()
                        Button("Reset") {
                            resetCards()
                        }
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(radius: 2)
                            .frame(width: 300, height: 400)
                    )
                }
            }
            Spacer()
            
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
    
    func resetCards() {
        practiceModeViewModel.counter = 0
        practiceModeViewModel.shuffle()
        practiceModeViewModel.flipStatuses =
            practiceModeViewModel.flipStatuses.mapValues { values in
                return false
            }
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

//struct PracticeModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeModeView()
//    }
//}
