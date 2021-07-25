//
//  LaunchView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            if authViewModel.signedIn {
                HomeView()
            } else {
                Launch()	
            }
        }
        .onAppear {
            authViewModel.signedIn = authViewModel.isSignedIn
        }
    }
}

struct Launch: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Text("Quizorize")
                        .font(.custom("GlacialIndifference-Bold", size: 52))
                        .padding()
        
//                    Text("Study Hard, Study Smart.")
//                        .font(.custom("GlacialIndifference-Regular", size: 24))
//
//                    Spacer()
                    
                    TabView {
                        LottieStudyView(width: geometry.size.width, height: geometry.size.height)
                        LottiePracticeView(width: geometry.size.width, height: geometry.size.height)
                        LottieTargetView(width: geometry.size.width, height: geometry.size.height)
                        LottieReminderView(width: geometry.size.width, height: geometry.size.height)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

                    
                    NavigationLink(
                        destination: LoginView(),
                        label: {
                            Text("Get Started.")
                        })
                        .buttonStyle(AuthButtonStyle())
                        .padding(.vertical)
                        
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

struct LottieTargetView: View {
    @State private var isPlaying = false
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "target", isPlaying: isPlaying)
                .frame(width: self.width * 0.9, height: self.height * 0.4)
                

            Text("Test yourself on the flashcards you create in Test Mode.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
    }
}

struct LottieMemoryView: View {
    @State private var isPlaying = false
    
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "target", isPlaying: isPlaying)
                .frame(width: self.width * 0.9, height: self.height * 0.4)

            Text("Test yourself on the flashcards you create in Test Mode.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
    }
}

struct LottieReminderView: View {
    @State private var isPlaying = false
    
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "calendar-success", isPlaying: isPlaying)
                .frame(width: self.width * 0.9, height: self.height * 0.4)

            Text("Schedule your own study reminders or let Quizorize plan your next study date using Spaced Repetition.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
        
    }
}

struct LottieStudyView: View {
    @State private var isPlaying = false
    
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "study", isPlaying: isPlaying)
                .frame(width: self.width * 0.9, height: self.height * 0.4)

            Text("Create your own decks and flashcards to improve your memory and revision.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
    }
}

struct LottiePracticeView: View {
    @State private var isPlaying = false
    
    var width: CGFloat //should be width of the whole screen
    
    var height: CGFloat //should be height of the whole screen
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(filename: "practice", isPlaying: isPlaying)
                .frame(width: self.width * 0.9, height: self.height * 0.4)

            Text("Hone your memory skills in Practice mode.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            isPlaying = true
        }
        .onDisappear {
            isPlaying = false
        }
    }
}
