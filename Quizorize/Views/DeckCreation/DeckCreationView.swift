//
//  DeckCreationView.swift
//  Quizorize
//
//  Created by CHEN JUN HONG on 4/6/21.
//

import SwiftUI

struct DeckCreationView: View {
    
    @Environment(\.presentationMode) var presentationMode


    @State private var deckTitle = ""

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        
                        /*
                        navBar
                        */
                        
                        TextField("Untitled", text: $deckTitle)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width / 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth: 1.5)
                            )
                            .padding()


                        flashcardView()
                    }
                }
            }
            .navigationBarTitle(Text("New deck"), displayMode: .inline)
            .navigationBarItems(leading: Button {
                                    presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
            })
            .navigationBarColor(UIColor(Color.accentColor), textColor: UIColor(Color.white))
        }

    }
    
    private var navBar: some View {
        
        HStack {
            Button {
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
            }
            
            Spacer()
            
            Button {
                //Create flashcard
            } label: {
                Image(systemName: "plus")
                    .font(.title)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func flashcardView() -> some View {
        GeometryReader { fullView in
            ScrollView(.horizontal) {
                LazyHStack {
                    DeckCreationFlashCard()
                        .padding()
                        .foregroundColor(.accentColor)
                        .frame(width: fullView.size.width)
                    DeckCreationFlashCard()
                        .padding()
                        .foregroundColor(.accentColor)
                        .frame(width: fullView.size.width)
                }
            }
        }
    }
}



struct DeckCreationView_Previews: PreviewProvider {
    
    @State private var isBlurred = false
    
    static var previews: some View {
        DeckCreationView()
            .environmentObject(AuthViewModel())
    }
}
