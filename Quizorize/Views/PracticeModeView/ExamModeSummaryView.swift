//
//  ExamModeSummaryView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 12/7/21.
//

import SwiftUI

struct ExamModeSummaryView: View {
    @ObservedObject var examModeVM: ExamModeViewModel
    @State private var progressValue = 0.0
    
    var body: some View {
        //Took most of this from TestModeSummary
        if self.examModeVM.intervalIsZero() {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Spacer()
                        SummaryProgressBar(progress: $progressValue)
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .padding()
                            .onAppear {
                                self.progressValue = self.examModeVM.getPercentageScore()
                            }
                        
                            Text("Get those questions right!")
                                .font(.title)
                                .padding()
                        
                            Text("Date of Completion: \(examModeVM.dateOfCompletion())")
                                .padding()
                            
                            Text("Next Study Date: \(examModeVM.nextDate())")
                                .padding()

                        Button(action: {
                        }, label: {
                            Text("Study Again Now")
                                .font(.headline)
                                .frame(width: geometry.size.width * 0.8, height: 32)
                        })
                        
                        Text("(This will NOT affect your next study date)")
                            .padding()
                        
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            }
        } else {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Spacer()
                        SummaryProgressBar(progress: $progressValue)
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .padding()
                            .onAppear {
                                self.progressValue = self.examModeVM.getPercentageScore()
                            }
                        
                            Text("Congratulations!")
                                .font(.title)
                                .padding()
                        
                            Text("Date of Completion: \(examModeVM.dateOfCompletion())")
                                .padding()
                            
                            Text("Next Study Date: \(examModeVM.nextDate())")
                                .padding()

                        Button(action: {
                        }, label: {
                            Text("Study Again Now")
                                .font(.headline)
                                .frame(width: geometry.size.width * 0.8, height: 32)
                        })
                        
                        Text("(This will NOT affect your next study date)")
                            .padding()
                        
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            }
            
        }
    }
}

