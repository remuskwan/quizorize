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
    
    var itemHeight:CGFloat
    @ObservedObject var flashcardListVM: FlashcardListViewModel
    
    private struct Dimensions {
        static let width: CGFloat = 350
        
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
            //            VStack{
            //                Text("\(dragState.translation.width)")
            //                Text("Carousel Location = \(carouselLocation)")
            //                Text("Relative Location = \(relativeLoc())")
            //                Text("\(relativeLoc()) / \(flashcardListVM.flashcardViewModels.count-1)")
            //                Spacer()
            //            }
            VStack{
                
                ZStack{
                    ForEach(flashcardListVM.flashcardViewModels){flashcard in
                        let i = flashcardListVM.flashcardViewModels.firstIndex(where: {$0.id == flashcard.id})!
                        
                        VStack{
                            //Spacer()
                            
                            PreviewFlashcard(index: i, width: Dimensions.width, height: self.getHeight(i), flashcardVM: flashcard)
                                //Text("\(i)")
                                /*
                                 .animation(.interpolatingSpring(stiffness: Dimensions.width.0, damping: 30.0, initialVelocity: 10.0))
                                 .background(Color.white)
                                 .cornerRadius(10)
                                 .shadow(radius: 3)
                                 */
                                
                                
                                .opacity(self.getOpacity(i))
                                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .offset(x: self.getOffset(i))
                                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .padding(.vertical)
                            //Spacer()
                        }
                    }
                    
                }.gesture(
                    
                    DragGesture()
                        .updating($dragState) { drag, state, transaction in
                            state = .dragging(translation: drag.translation)
                        }
                        .onEnded(onDragEnded)
                    
                )
                
                //Spacer()
            }
            VStack{
                Spacer().frame(height:itemHeight + 30)
                Fancy3DotsIndexView(flashcardListVM: flashcardListVM,
                                    currentIndex: carouselLocation)
                    .animation(.default)
                    .scaleEffect(0.7)
                /*
                 Text("\(relativeLoc() + 1)/\(flashcardListVM.flashcardViewModels.count)").padding()
                 */
                
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
            return self.dragState.translation.width + (indexInCGFloat * (Dimensions.width + 20))
        }
        
        //This sets up the central offset
        /*
         if (i) == relativeLoc()
         {
         //Set offset of cental
         return self.dragState.translation.width
         }
         //These set up the offset +/- 1
         else if
         (i) == relativeLoc() + 1
         ||
         (relativeLoc() == flashcardListVM.flashcardViewModels.count - 1 && i == 0)
         {
         //Set offset +1
         return self.dragState.translation.width + (300 + 20)
         }
         else if
         (i) == relativeLoc() - 1
         ||
         (relativeLoc() == 0 && (i) == flashcardListVM.flashcardViewModels.count - 1)
         {
         //Set offset -1
         return self.dragState.translation.width - (300 + 20)
         }
         //These set up the offset +/- 2
         else if
         (i) == relativeLoc() + 2
         ||
         (relativeLoc() == flashcardListVM.flashcardViewModels.count-1 && i == 1)
         ||
         (relativeLoc() == flashcardListVM.flashcardViewModels.count-2 && i == 0)
         {
         return self.dragState.translation.width + (2*(300 + 20))
         }
         else if
         (i) == relativeLoc() - 2
         ||
         (relativeLoc() == 1 && i == flashcardListVM.flashcardViewModels.count-1)
         ||
         (relativeLoc() == 0 && i == flashcardListVM.flashcardViewModels.count-2)
         {
         //Set offset -2
         return self.dragState.translation.width - (2*(300 + 20))
         }
         //These set up the offset +/- 3
         else if
         (i) == relativeLoc() + 3
         ||
         (relativeLoc() == flashcardListVM.flashcardViewModels.count-1 && i == 2)
         ||
         (relativeLoc() == flashcardListVM.flashcardViewModels.count-2 && i == 1)
         ||
         (relativeLoc() == flashcardListVM.flashcardViewModels.count-3 && i == 0)
         {
         return self.dragState.translation.width + (3*(300 + 20))
         }
         else if
         (i) == relativeLoc() - 3
         ||
         (relativeLoc() == 2 && i == flashcardListVM.flashcardViewModels.count-1)
         ||
         (relativeLoc() == 1 && i == flashcardListVM.flashcardViewModels.count-2)
         ||
         (relativeLoc() == 0 && i == flashcardListVM.flashcardViewModels.count-3)
         {
         //Set offset -2
         return self.dragState.translation.width - (3*(300 + 20))
         }
         //This is the remainder
         else {
         return 10000
         }
         */
    }
    
    
}

//MARK: Custom PageControl
struct Fancy3DotsIndexView: View {
    
    @ObservedObject var flashcardListVM: FlashcardListViewModel
    // MARK: - Public Properties
    //let numberOfPages: Int
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