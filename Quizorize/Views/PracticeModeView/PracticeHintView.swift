//
//  PracticeHintView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 20/7/21.
//

import SwiftUI

struct PracticeHintView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let generalPracticeHints: [AnyView] = [AnyView(HintRowView(textTitle: "Tap the card", textContent: "View reverse side", image: "arrow.2.squarepath", imageColor: .accentColor)), AnyView(HintRowView(textTitle: "Swipe left", textContent: "Mark card as incorrect", image: "arrowshape.turn.up.left.fill", imageColor: .orange)), AnyView(HintRowView(textTitle: "Swipe Right", textContent: "Mark card as correct", image: "arrowshape.turn.up.right.fill", imageColor: .green))]

    let spacedRepetitionHints: [AnyView] = [AnyView(HintRowView(textTitle: "Complete each round", textContent: "Reach the end before stopping to save your progress", image: "externaldrive.fill.badge.timemachine", imageColor: Color(hex: "15CDA8"))), AnyView(HintRowView(textTitle: "Open Quizorize on the next study date", textContent: "Study on Quizorize's next planned date!", image: "deskclock.fill", imageColor: .accentColor))]
    
    @AppStorage("showTip") var showTip: Bool = true

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                grayRectangleTopView
                    .frame(width: geometry.size.width * DrawingConstants.pullerWidth, height: geometry.size.height * DrawingConstants.pullerHeight)
                    .padding()

                
                Text("Practice Tips")
                    .font(.title.bold())
                
                Spacer()

                //HintRowViews
                VStack(alignment: .leading) {

                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    //Paste HintPageViews inside Carousel here
                    CarouselTemplateView(width: geometry.size.width, itemHeight: geometry.size.height, heightRatio: 0.62, views: [
                        AnyView(HintPageView(height: geometry.size.height, width: geometry.size.width, views: generalPracticeHints)),
                        AnyView(HintPageView(height: geometry.size.height, width: geometry.size.width, views: spacedRepetitionHints))
                    ])
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                
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
    
    var grayRectangleTopView: some View {
        RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            .fill(Color.gray)
    }
    
    private struct DrawingConstants {
        
        static let buttonTextColor: Color = .white
        static let cornerRadius: CGFloat = 5
        
        static let hintRowHeight: CGFloat = 0.1
        static let hintRowWidth: CGFloat = 0.8
        
        static let pullerHeight: CGFloat = 0.007
        static let pullerWidth: CGFloat = 0.4
    }
}

struct HintPageView: View {
    var height: CGFloat //Should be the height of the parent view (geometry.size.height)
    var width: CGFloat
    let views: [AnyView]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<views.count) { i in
                views[i]
                    .padding(.vertical)
                    .frame(width: self.width * DrawingConstants.hintRowWidth, height: self.height * DrawingConstants.hintRowHeight)
                
                Spacer()
                    .frame(height: self.height * 0.1)
            }
        }
    }
    
    private struct DrawingConstants {
        static let hintRowHeight: CGFloat = 0.1
        static let hintRowWidth: CGFloat = 0.8
    }
}

struct HintRowView: View {
    var textTitle: String
    var textContent: String
    var image: String? //Must be SF Symbols
    
    var imageColor: Color?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top) {
                if let image = image {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(imageColor ?? .black)
                        .frame(width: geometry.size.width * 0.3)
                }
                
                VStack(alignment: .leading) {
                    Text(textTitle)
                        .font(.title2.bold())
                        .lineLimit(nil)
                    Spacer()
                    Text(textContent)
                        .font(.body)
                        .lineLimit(nil)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            
        }
    }
}

struct PracticeHintView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeHintView()
    }
}
