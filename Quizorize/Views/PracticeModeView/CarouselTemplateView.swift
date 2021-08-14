//
//  CarouselView.swift
//  codeTutorial_carousel
//
//  Created by Christopher Guirguis on 3/17/20.
//  Copyright © 2020 Christopher Guirguis. All rights reserved.
//

import SwiftUI

struct CarouselTemplateView: View {
    
    @GestureState private var dragState = DragState.inactive
    @State var carouselLocation = 0
    
    var width: CGFloat // width of each view
    var itemHeight: CGFloat //Height of the entire screen
    var heightRatio: CGFloat //quick fix for drawing PageControl correctly for both PracticeHint and SR Hint
    
    var views: [AnyView]

    private struct Dimensions {
        static let heightOffset: CGFloat = 50 //For the adjacent view
    }
    
    
    private func onDragEnded(drag: DragGesture.Value) {
        print("drag ended")
        let dragThreshold:CGFloat = 200
        if (drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold) && carouselLocation != 0{
            carouselLocation =  carouselLocation - 1
            print(carouselLocation)
        } else if ((drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)) && carouselLocation != views.count - 1
        {
            carouselLocation =  carouselLocation + 1
            print(carouselLocation)
        }
    }
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack{
                
                ZStack{
                    ForEach(0..<views.count) { i in
                        VStack{
                            views[i]
                                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                .offset(x: self.getOffset(i))
                                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
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
                Spacer().frame(height:itemHeight * self.heightRatio)
                Fancy3DotsIndexTemplateView(numberOfPages: views.count,
                                    currentIndex: carouselLocation)
                    .animation(.default)
                    .scaleEffect(0.7)
                Spacer()
            }
        }
    }
    
    func relativeLoc() -> Int{
        return (carouselLocation) % views.count
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
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) + views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) + views.count == relativeLoc()
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
struct Fancy3DotsIndexTemplateView: View {
    
    // MARK: - Public Properties
    
    let numberOfPages: Int
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
        ForEach(0..<numberOfPages) { index in // 1
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
      ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    }
}

