//
//  DeckPreviewView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 23/6/21.
//

import SwiftUI

struct DeckPreviewView: View {
    var body: some View {
        NavigationView {
            GeometryReader { fullView in
                VStack {

                    //deckTitle
                    HStack {
                        VStack {
                            Text("DeckTitle")
                                .font(.title)
                            
                            Text("X cards")
                                .font(.caption)
                            
                        }
                        
                        Spacer()
                        
                    }
                    
                    HStack {
                        //Practice
                        Button {
                            
                        } label: {
                            VStack {
                                Text("Practice")
                            }
                        }

                        
                        //Quiz
                        Button {
                            
                        } label: {
                            VStack {
                                Text("Quiz")
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DeckPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        DeckPreviewView()
    }
}
