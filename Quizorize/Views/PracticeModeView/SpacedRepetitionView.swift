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
            VStack(alignment: .center) {
                grayRectangleTopView
                    .frame(width: geometry.size.width * DrawingConstants.pullerWidth, height: geometry.size.height * DrawingConstants.pullerHeight)
                    .padding()
                
                Text("What is Spaced Repetition?")
                    .font(geometry.size.width > 420 ? .title.bold() : .title2.bold())
                
//                Spacer()
//                    .frame(height: geometry.size.height * 0.1)

                //Insert the two views here
//                CarouselTemplateView(width: geometry.size.width, itemHeight: geometry.size.height, heightRatio: 0.7, views: [
//                    AnyView(LottieStatisticsView(width: geometry.size.width, height: geometry.size.height)),
//                    AnyView(LottieCalendarView(width: geometry.size.width, height: geometry.size.height))
//                ])

                TabView {
                    LottieStatisticsView(width: geometry.size.width, height: geometry.size.height)
                    LottieCalendarView(width: geometry.size.width, height: geometry.size.height)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
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
                        .padding(.vertical)
                }
            }
            .padding(.horizontal, 20)
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
    @State private var isPlaying = false
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "calendar", isPlaying: isPlaying)
                .frame(width: self.width, height: self.height * 0.4)
            HStack(alignment: .center, spacing: 0) {
                Text("Using an algorithm based on 'Ebbinghaus curve of forgetting', Quizorize will analyse how often you need to study") +

                Text(" each flashcard")
                    .font(.title3.bold()) +
                    
                Text(" and remind you to study when it's time.")
            }
            .font(.title3)
            .multilineTextAlignment(.center)
//            .lineLimit(nil)
//            .fixedSize(horizontal: false, vertical: true)
//            .padding(.horizontal)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
    }
}

struct LottieStatisticsView: View {
    @State private var isPlaying = false
    var width: CGFloat
    
    var height: CGFloat
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "statistics", isPlaying: isPlaying)
                .frame(width: self.width * 0.9, height: self.height * 0.4)
//            HStack(alignment: .center, spacing: 0) {
//
//            }
            Text("Finish quizzing all the flashcards in one round before leaving to save your progress.")
            .font(.title2)
            .multilineTextAlignment(.center)
//            .lineLimit(nil)
//            .fixedSize(horizontal: false, vertical: true)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
    }
}

struct SpacedRepetitionView_Previews: PreviewProvider {
    static var previews: some View {
        SpacedRepetitionView()
    }
}
