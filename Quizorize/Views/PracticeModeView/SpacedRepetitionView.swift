//
//  SpacedRepetitionView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 22/7/21.
//

import SwiftUI

struct SpacedRepetitionView: View {
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: . center) {
                grayRectangleTopView
                    .frame(width: geometry.size.width * DrawingConstants.pullerWidth, height: geometry.size.height * DrawingConstants.pullerHeight)
                    .padding()
                
                Text("What is Spaced Repetition?")
                    .font(geometry.size.width > 420 ? .title.bold() : .title2.bold())
                
//                Spacer()
//                    .frame(height: geometry.size.height * 0.1)

                //Insert the two views here
                CarouselTemplateView(width: geometry.size.width, itemHeight: geometry.size.height, heightRatio: 0.7, views: [
                    AnyView(LottieStatisticsView(width: geometry.size.width, height: geometry.size.height)),
                    AnyView(LottieCalendarView(width: geometry.size.width, height: geometry.size.height))
                ])

                Spacer()
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("OK got it!")
                        .foregroundColor(DrawingConstants.buttonTextColor)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                                        .fill(Color.accentColor))
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var grayRectangleTopView: some View  {
        RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            .fill(Color.gray)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 5
        
        static let pullerHeight: CGFloat = 0.007
        static let pullerWidth: CGFloat = 0.4
        
        static let buttonTextColor: Color = .white
    }
}

//MARK: Calendar Lottie View
struct LottieCalendarView: View {
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "calendar")
                .frame(width: self.width, height: self.height * 0.5)

            HStack(alignment: .center, spacing: 0) {
                Text("Using an algorithm based on 'Ebbinghaus curve of forgetting', Quizorize will analyse how often you need to study") +

                Text(" each flashcard")
                    .font(.body.bold()) +
                    
                Text(" and remind you to study when it's time.")
            }
            .font(.body)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
        }
    }
}

struct LottieStatisticsView: View {
    var width: CGFloat
    
    var height: CGFloat
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "statistics")
                .frame(width: self.width, height: self.height * 0.5)

            HStack(alignment: .center, spacing: 0) {
                Text("Finish quizzing all the flashcards in one round before leaving to save your progress.")
            }
            .font(.body)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct SpacedRepetitionView_Previews: PreviewProvider {
    static var previews: some View {
        SpacedRepetitionView()
    }
}
