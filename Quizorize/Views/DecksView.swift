//
//  DecksView.swift
//  Quizorize
//
//  Created by Remus Kwan on 24/5/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct DecksView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var isPresented = false
    @State private var isBlurred = false
    
    var body: some View {
        if viewModel.signedIn {
            TabView{
                Decks(isPresented: $isPresented, isBlurred: $isBlurred)
                    .tabItem { Label("Decks", systemImage: "square.grid.2x2.fill") }
                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
            }
            .sheet(isPresented: $isPresented) {
                DeckCreationView()
            }
        } else {
            LaunchView()
        }
    }
}

struct Decks: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedSortBy = SortBy.date
    @State private var showSettingsSheet: Bool = false
    
    @Binding var isPresented: Bool
    @Binding var isBlurred: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    
                    Picker("Sort By: ", selection: $selectedSortBy) {
                        ForEach(SortBy.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200, height: 20, alignment: .center)
                    .padding()
                    
                    Button {
                        isBlurred = true
                        isPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                Spacer()
            }
            .navigationTitle("Decks")
        }
    }
}

//MARK: Blurs the background of a fullScreenCover
struct makeViewBlur: ViewModifier {
    
    var toggled: Bool
    
    init(if toggled: Bool) {
        self.toggled = toggled
    }
    
    
    @ViewBuilder func body(content: Content) -> some View {
        if toggled {
            content.blur(radius: 2.0)
        } else {
            content
        }
    }
}

//MARK: Makes fullScreenCover transparent
struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


enum SortBy: String, CaseIterable {
    case date = "Date"
    case name = "Name"
    case type = "Type"
}

struct DecksView_Previews: PreviewProvider {
    @State private var isPresented = false
    @State private var isBlurred = false
    
    static var previews: some View {
        DecksView()
    }
}
