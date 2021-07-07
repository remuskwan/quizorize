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
                    FlashcardListView(practiceModeViewModel: practiceModeViewModel)
                }
//                OptionsSheet(showingOptionsSheet: $showOptionsSheet, dismissOptionsSheet: $dismissOptionsSheet, height: geometry.size.height * 0.8) {
//                    OptionsSheetContent()
//                        .padding()
//                }
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
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if practiceModeViewModel.counter != practiceModeViewModel.count  {
                    ForEach(practiceModeViewModel.practiceFlashcards) { flashcardVM in
                        let flashcard = flashcardVM.flashcard
                        FlashcardView(flashcardViewModel: flashcardVM)
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
                                            if drag.translation.width < -200 || drag.translation.width > 200 || drag.translation.height < -300 || drag.translation.height > 300 {
                                                self.practiceModeViewModel.moveToBack(flashcard)
                                            }
                                            else {
                                                self.practiceModeViewModel.moveToFront(flashcard)
                                            }
                                        }
                                    })
                                    .onEnded({ drag in
                                        withAnimation(.spring()) {
                                            self.practiceModeViewModel.activeCard = nil
                                            self.practiceModeViewModel.topCardOffset = .zero
                                            if practiceModeViewModel.counter < practiceModeViewModel.count {
                                                self.practiceModeViewModel.counter += 1
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
                            self.practiceModeViewModel.counter = 0
                            self.practiceModeViewModel.practiceFlashcards.forEach { flashcardVM in
                                flashcardVM.flipped = false
                            }
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
                practiceModeViewModel.shuffle()
            }, label: {
                Label(
                    title: { Text("Shuffle") },
                    icon: { Image(systemName: "shuffle") }
                )
            })
            .padding()
            
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

    var body: some View {
        VStack {
            Spacer()
            if !flashcardViewModel.flipped {
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
        .rotation3DEffect(flashcardViewModel.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
        .onTapGesture {
            withAnimation(.spring()) {
                flashcardViewModel.flipped.toggle()
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


//struct PracticeModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeModeView()
//    }
//}
