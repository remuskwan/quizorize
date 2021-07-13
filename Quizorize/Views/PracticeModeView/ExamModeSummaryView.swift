//
//  ExamModeSummaryView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 12/7/21.
//

/*
import SwiftUI

struct ExamModeSummaryView: View {
    @ObservedObject var practiceModeViewModel: PracticeModeViewModel
    var examModeVM: ExamModeViewModel?
    @State private var progressValue = 0.0
    
    var body: some View {
       //Took most of this from TestModeSummary
        ZStack {
            if let _ = examModeVM {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        SummaryProgressBar(progress: $progressValue)
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .padding()
                            .onAppear {
                                self.progressValue = self.examModeVM!.getPercentageScore()
                            }
                        
                        Text("Date of Completion: \(examModeVM!.dateOfCompletion())")
                            .padding()
                        
                        Text("Next Study Date: \(examModeVM!.nextDate())")
                            .padding()
                       
                        if examModeVM!.isExamMode {
                            Button(action: {
                                resetCards()
                            }, label: {
                                Text("Study Again Now")
                                    .font(.headline)
                                    .frame(width: geometry.size.width * 0.8, height: 32)
                            })
                        } else {
                            Button {
                                resetCards()
                                examModeVM!.turnOffExamMode()
                            } label: {
                                Text("I still want to practice now")
                                    .font(.headline)
                                    .frame(width: geometry.size.width * 0.8, height: 32)
                            }
                            .padding()
                            
                            Text("(This will NOT affect your next study date)")
                                .padding()
                        }
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            } else {
                GeometryReader { geometry in
                    VStack {
                        Text("Congraluations")
                            .font(.title2.bold())
                        
                        Text("You're done!")
                            .font(.body)
                            .padding()
                        
                        Button("Reset") {
                            resetCards()
                        }
                        .padding()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                
            }
            
        }
    }
    
    func resetCards() {
        practiceModeViewModel.counter = 0
        practiceModeViewModel.shuffle()
        practiceModeViewModel.flipStatuses =
            practiceModeViewModel.flipStatuses.mapValues { values in
                return false
            }
        examModeVM?.reset()
    }
}
 */

