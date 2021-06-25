//
//  PracticeModeView.swift
//  Quizorize
//
//  Created by Remus Kwan on 22/6/21.
//

import SwiftUI

struct PracticeModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel
    
    var body: some View {
        NavigationView {
            FlashcardListView(flashcardListViewModel: flashcardListViewModel)
                .navigationTitle("Practice")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "multiply")
                        }
                    }
                }
        }
    }
}

struct FlashcardListView: View {
    @ObservedObject var flashcardListViewModel: FlashcardListViewModel

    var body: some View {
        ZStack {
            ForEach(flashcardListViewModel.flashcardViewModels) { flashcardVM in
                let flashcard = flashcardVM.flashcard
                FlashcardView(flashcardViewModel: flashcardVM)
                    .zIndex(self.flashcardListViewModel.zIndex(of: flashcard))
                    .offset(x: self.offset(for: flashcard).width, y: self.offset(for: flashcard).height)
                    .offset(y: self.flashcardListViewModel.deckOffset(of: flashcard))
                    .scaleEffect(x: self.flashcardListViewModel.scale(of: flashcard), y: self.flashcardListViewModel.scale(of: flashcard))
                    .rotationEffect(self.rotation(for: flashcard))
                    .gesture(
                        DragGesture()
                            .onChanged({ drag in
                                if self.flashcardListViewModel.activeCard == nil {
                                    self.flashcardListViewModel.activeCard = flashcard
                                }
                                guard flashcard == self.flashcardListViewModel.activeCard else { return }
                            
                                withAnimation(.spring()) {
                                    self.flashcardListViewModel.topCardOffset = drag.translation
                                    if
                                        drag.translation.width < -200 ||
                                        drag.translation.width > 200 ||
                                        drag.translation.height < -250 ||
                                        drag.translation.height > 250 {
                                          
                                        self.flashcardListViewModel.moveToBack(flashcard)
                                    } else {
                                        self.flashcardListViewModel.moveToFront(flashcard)
                                    }
                                }
                            })
                            .onEnded({ (drag) in
                                withAnimation(.spring()) {
                                    self.flashcardListViewModel.activeCard = nil
                                    self.flashcardListViewModel.topCardOffset = .zero
                                }
                            })
                    )
            }
        }
        
    }
    
    func offset(for flashcard: Flashcard) -> CGSize {
        if flashcard != self.flashcardListViewModel.activeCard { return .zero }
        
        return flashcardListViewModel.topCardOffset
    }
    
    func rotation(for flashcard: Flashcard) -> Angle {
        guard let activeCard = self.flashcardListViewModel.activeCard
            else {return .degrees(0)}
        
        if flashcard != activeCard {return .degrees(0)}
        
        return flashcardListViewModel.rotation(for: activeCard, offset: flashcardListViewModel.topCardOffset)
    }
}

struct FlashcardView: View {
    @ObservedObject var flashcardViewModel: FlashcardViewModel

    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text(flashcardViewModel.display)
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .shadow(radius: 2)
                .rotation3DEffect(flashcardViewModel.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                .animation(.default)
        )
        
        .onTapGesture {
            flashcardViewModel.flipped.toggle()
        }
        
    }
}


//struct PracticeModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeModeView()
//    }
//}
