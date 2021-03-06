//
//  TestModeSummaryView.swift
//  Quizorize
//
//  Created by Remus Kwan on 7/7/21.
//

import SwiftUI

struct TestModeSummaryView: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    @ObservedObject var deckViewModel: DeckViewModel
    
    @State private var progressValue = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    SummaryProgressBar(progress: $progressValue)
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                        .padding()
                        .onAppear {
                            self.progressValue = testModeViewModel.calculateScore()
                        }
                        
                    if testModeViewModel.correct != testModeViewModel.count {
                        Text("Keep studying!")
                            .font(.title)
                            .padding()
                        Text("You misssed \(testModeViewModel.count - testModeViewModel.correct) out of \(testModeViewModel.count) questions")
                            .padding()
                    } else {
                        Text("Excellent work!")
                            .font(.title)
                            .padding()
                        Text("You aced the test!")
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        testModeViewModel.reset()
                    }, label: {
                        Text("Retake")
                            .font(.headline)
                    })
                    .buttonStyle(TestModeButtonStyle())
                    .frame(width: geometry.size.width - 40)
                    .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
        }
        
    }
}


struct SummaryProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(.accentColor)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1)))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 0.7))
            VStack {
                Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                .font(.largeTitle.bold())
                Text("LAST SCORE")
                    .font(.footnote)
            }
        }
    }
}
