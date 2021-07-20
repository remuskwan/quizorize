//
//  PracticeHintView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 20/7/21.
//

import SwiftUI

struct PracticeHintView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .fill(Color.gray)
                    .frame(width: geometry.size.width * DrawingConstants.pullerWidth, height: geometry.size.height * DrawingConstants.pullerHeight)
                    .padding()
                
                Text("Practice Tips")
                    .font(.title.bold())
                
                Spacer()
                
                //3 HintRowViews
                VStack(alignment: .leading) {
                    HintRowView(textTitle: "Tap the card", textContent: "View the reverse side", image: "arrow.2.squarepath", imageColor: .accentColor)
                        .padding()
                        .frame(width: geometry.size.width * DrawingConstants.hintRowWidth, height: geometry.size.height * DrawingConstants.hintRowHeight)
                        //.border(Color.green)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    
                    HintRowView(textTitle: "Swipe left", textContent: "Mark the card as incorrect", image: "arrowshape.turn.up.left.fill", imageColor: .orange)
                        .padding()
                        .frame(width: geometry.size.width * DrawingConstants.hintRowWidth, height: geometry.size.height * DrawingConstants.hintRowHeight)
                        //.border(Color.green)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    HintRowView(textTitle: "Swipe Right", textContent: "Mark the card as correct", image: "arrowshape.turn.up.right.fill", imageColor: .green)
                        .padding()
                        .frame(width: geometry.size.width * DrawingConstants.hintRowWidth, height: geometry.size.height * DrawingConstants.hintRowHeight)
                        //.border(Color.green)
                    
                }
                
                Spacer()
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Ok got it!")
                        .foregroundColor(DrawingConstants.buttonTextColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                                        .fill(Color.accentColor))
                        .padding()
                        //.border(Color.green)
                }
            }
            /*
             .toolbar(content: {
             ToolbarItem {
             Button {
             presentationMode.wrappedValue.dismiss()
             } label: {
             Image(systemName: "multiply")
             }
             }
             })
             */
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        
    }
    
    private struct DrawingConstants {
        
        static let buttonTextColor: Color = .white
        static let cornerRadius: CGFloat = 10
        
        static let hintRowHeight: CGFloat = 0.1
        static let hintRowWidth: CGFloat = 0.8
        
        static let pullerHeight: CGFloat = 0.007
        static let pullerWidth: CGFloat = 0.4
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
                    
                    Text(textContent)
                        .font(.body)
                }
            }
            
        }
    }
}

struct PracticeHintView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeHintView()
    }
}
