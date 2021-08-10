//
//  CarouselView.swift
//  codeTutorial_carousel
//
//  Created by Christopher Guirguis on 3/17/20.
//  Copyright © 2020 Christopher Guirguis. All rights reserved.
//

import SwiftUI

struct CarouselView: View {
    
    @GestureState private var dragState = DragState.inactive
    @Binding var carouselLocation: Int
    
    var width: CGFloat // width of each view
    
    var itemHeight:CGFloat
    @ObservedObject var flashcardListVM: FlashcardListViewModel
    
    private struct Dimensions {
        static let heightOffset: CGFloat = 50 //For the adjacent view
    }
    
    
    private func onDragEnded(drag: DragGesture.Value) {
        print("drag ended")
        let dragThreshold:CGFloat = 200
        if (drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold) && carouselLocation != 0{
            carouselLocation =  carouselLocation - 1
            print(carouselLocation)
        } else if ((drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)) && carouselLocation != flashcardListVM.flashcardViewModels.count - 1
        {
            carouselLocation =  carouselLocation + 1
            print(carouselLocation)
        }
    }
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack{
                
                ZStack{
                    ForEach(flashcardListVM.flashcardViewModels){flashcard in
                        let i = flashcardListVM.flashcardViewModels.firstIndex(where: {$0.id == flashcard.id})!
                        
                        VStack{
                            PreviewFlashcard(index: i, width: self.width, height: self.getHeight(i), flashcardVM: flashcard)
                                .opacity(self.getOpacity(i))
                                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .offset(x: self.getOffset(i))
                                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .padding(.vertical)
                        }
                    }
                    
                }.gesture(
                    
                    DragGesture()
                        .updating($dragState) { drag, state, transaction in
                            state = .dragging(translation: drag.translation)
                        }
                        .onEnded(onDragEnded)
                    
                )
            }
            VStack{
                Spacer().frame(height:itemHeight + 30)
                Fancy3DotsIndexView(flashcardListVM: flashcardListVM,
                                    currentIndex: carouselLocation)
                    .animation(.default)
                    .scaleEffect(0.7)
                Spacer()
            }
        }
    }
    
    func relativeLoc() -> Int{
        return (carouselLocation) % flashcardListVM.flashcardViewModels.count
    }
    
    func getHeight(_ i:Int) -> CGFloat{
        if i == relativeLoc(){
            return itemHeight
        } else {
            return itemHeight - Dimensions.heightOffset
        }
    }
    
    
    func getOpacity(_ i:Int) -> Double{
        
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - flashcardListVM.flashcardViewModels.count == relativeLoc()
            || (i - 1) + flashcardListVM.flashcardViewModels.count == relativeLoc()
            || (i + 2) - flashcardListVM.flashcardViewModels.count == relativeLoc()
            || (i - 2) + flashcardListVM.flashcardViewModels.count == relativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    func getOffset(_ i:Int) -> CGFloat{
        
        let indexInCGFloat = CGFloat(i - relativeLoc())
        
        if i == relativeLoc() {
            return self.dragState.translation.width
        } else {
            return self.dragState.translation.width + (indexInCGFloat * (self.width + 20))
        }
    }
    
    
}

//MARK: Custom PageControl
struct Fancy3DotsIndexView: View {
    
    @ObservedObject var flashcardListVM: FlashcardListViewModel
    // MARK: - Public Properties
    let currentIndex: Int
    
    
    // MARK: - Drawing Constants
    
    private let circleSize: CGFloat = 16
    private let circleSpacing: CGFloat = 12
    
    private let primaryColor = Color.accentColor
    private let secondaryColor = Color.gray.opacity(0.6)
    
    private let smallScale: CGFloat = 0.6
    
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(flashcardListVM.flashcardViewModels) { flashcard in // 1
                let index = flashcardListVM.flashcardViewModels.firstIndex(where: {$0.id == flashcard.id})!

                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? primaryColor : secondaryColor) // 2
                        .scaleEffect(currentIndex == index ? 1 : smallScale)
                        
                        .frame(width: circleSize, height: circleSize)
                        
                        .transition(AnyTransition.opacity.combined(with: .scale)) // 3
                        
                        .id(index) // 4
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - 2)...(currentIndex + 2)).contains(index)
    }
}





enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
