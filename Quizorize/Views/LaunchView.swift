//
//  LaunchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

struct LaunchView: View {
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Image("flashcard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .topLeading)
                    
                    Text("Quizorize")
                        .font(.title3)
                }
                
                Text("Study Hard, Study Smart.")
                    .font(.title3)
                
                Spacer()
//                Button("Get Started.") {
//                    isPresented.toggle()
//                }
//                .fullScreenCover(isPresented: $isPresented, content: Login.init)
                NavigationLink(
                    destination: LoginView()
                        .environmentObject(AuthViewModel()),
                    label: {
                        Text("Get Started.")
                    })
                    .cornerRadius(5)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(Color.purple)
                    //.addBorder(Color.purple, width: 1, cornerRadius: 20)
                    .padding()
            }
        }
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Dismiss Modal") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
