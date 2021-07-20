//
//  TestModeView.swift
//  Quizorize
//
//  Created by Remus Kwan on 5/7/21.
//

import SwiftUI

struct TestModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reminderViewModel: ReminderViewModel
    
    @ObservedObject var testModeViewModel: TestModeViewModel
    @ObservedObject var deckViewModel: DeckViewModel
    
    @State private var showingTest = false
    @State private var showingEndTestAlert = false
    @State private var progressValue = 0.0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        if !self.showingTest {
                            List {
                                if deckViewModel.deck.testModePrevScore != nil {
                                    Section {
                                        HStack {
                                            SummaryProgressBar(progress: $progressValue)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                                .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                                                .padding()
                                                .onAppear {
                                                    self.progressValue = deckViewModel.deck.testModePrevScore ?? 0.0
                                                }
                                        }
                                    }
                                    .listRowBackground(Color.offWhite)
                                }
                                
                                Section {
                                    Button(action: {
                                        testModeViewModel.setQuestionTypes()
                                        testModeViewModel.setCurrentType()
                                        testModeViewModel.setQuestionCount()
                                        self.showingTest.toggle()
                                    }, label: {
                                        Text("Start Test")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                    })
                                    .frame(width: geometry.size.width * 0.8, height: 45)
                                    .listRowBackground(Color.accentColor)
                                }
                                TestModeOptions(testModeViewModel: testModeViewModel)
                            }
                            .listStyle(InsetGroupedListStyle())
                            .toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(systemName: "multiply")
                                    }
                                }
                            })
                        } else {
                            TestView(testModeViewModel: testModeViewModel, deckViewModel: deckViewModel)
                                .toolbar(content: {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button {
                                            if self.testModeViewModel.count != self.testModeViewModel.counter {
                                                self.showingEndTestAlert.toggle()
                                            } else {
                                                self.testModeViewModel.setNextReminderTime()
                                                let reminderTime = testModeViewModel.nextReminderTime
                                                if reminderTime != 0 {
                                                    reminderViewModel.sendReminderNotif(deckTitle: deckViewModel.deck.title, reminderTime: reminderTime)
                                                }
                                                self.testModeViewModel.setLatestScore(deckViewModel.deck)
                                                self.testModeViewModel.reset()
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        } label: {
                                            Image(systemName: "multiply")
                                        }
                                    }
                                })
                                .alert(isPresented: $showingEndTestAlert, content: {
                                    Alert(title: Text("Are you sure you want to end this test?"),
                                          message: Text("Test progress will not be saved."),
                                          primaryButton: .cancel(),
                                          secondaryButton: .default(Text("End Test")) {
                                            self.testModeViewModel.reset()
                                            presentationMode.wrappedValue.dismiss()
                                          })
                                })
                        }
                    }
                }
            }
        }
    }
}

struct TestModeOptions: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    @State private var isInstEvalOn = false
    @State private var isSpacedRepetitionOn = true
    @State private var showAlert = false
    
    var body: some View {
//        Section(header: Text("General")) {
//            Picker("Question Count", selection: $testModeViewModel.questionCount) {
//                ForEach(1 ..< testModeViewModel.count + 1, id: \.self) {
//                    Text("\($0)")
//                }
//            }
//            Toggle(isOn: $isInstEvalOn, label: {
//                Text("Instant Evaluation")
//            })
//            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))
//        }
        Section(header: Text("Question types")) {
            Toggle(isOn: $testModeViewModel.isTrueFalse, label: {
                Text("True or false")
            })
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))
            
            Toggle(isOn: $testModeViewModel.isMCQ, label: {
                Text("Multiple choice")
            })
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))
            
            Toggle(isOn: $testModeViewModel.isWritten, label: {
                Text("Written")
            })
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))
        }
        
        Section(header: Text("Reminders"), footer: Text("Let Quizorize remind you when its time to take the test again")) {
//            Toggle(isOn: $isSpacedRepetitionOn, label: {
//                Text("Spaced Repetition")
//            })
//            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "15CDA8")))
//
//            if !isSpacedRepetitionOn {
                Picker("Remind Me", selection: $testModeViewModel.reminderType) {
                    ForEach(ReminderType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
//            }
            
        }
//        .alert(isPresented: testModeViewModel.isTrueFalse && testModeViewModel.isMCQ && testModeViewModel.isTrueFalse, content: {
//            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Alert(title: Text("Alert"))/*@END_MENU_TOKEN@*/
//        })
    }
}

enum ReminderType: String, CaseIterable {
    case never = "Never"
    case oneDay = "Tommorow"
    case threeDays = "In 3 days"
    case fiveDays = "In 5 days"
    case oneWeek = "Next week"
    case twoWeeks = "In 2 weeks"
    case oneMonth = "Next month"
}

struct TestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var testModeViewModel: TestModeViewModel
    @ObservedObject var deckViewModel: DeckViewModel
    
    @State private var answer = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    if self.testModeViewModel.count != self.testModeViewModel.counter {
                        ProgressView(value: Double(testModeViewModel.counter), total: Double(testModeViewModel.count))
                            .frame(width: geometry.size.width * 0.7, alignment: .center)
                        Spacer()
                        TestModeSnapCarousel(testModeViewModel: testModeViewModel)
                        Spacer()
                        if testModeViewModel.currentType == "Written" {
                            Written(testModeViewModel: testModeViewModel)
                        } else if testModeViewModel.currentType == "TF" {
                            TrueFalse(testModeViewModel: testModeViewModel)
//                                .frame(height: geometry.size.height * 0.4)
                        } else if testModeViewModel.currentType == "MCQ" {
                            MultipleChoice(testModeViewModel: testModeViewModel)
                                .frame(height: geometry.size.height * 0.4)
                                .padding(24)
                        }
                    } else {
                        TestModeSummaryView(testModeViewModel: testModeViewModel, deckViewModel: deckViewModel)
                    }
                }
            }
        }
    }
}

//Source: https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670
struct TestModeSnapCarousel: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    var body: some View {
        let spacing: CGFloat = 16
        let widthOfHiddenCards: CGFloat = 32 /// UIScreen.main.bounds.width - 10
        let cardHeight: CGFloat = 279
        let flashcards = testModeViewModel.testFlashcards
        
        return Canvas {
            /// TODO: find a way to avoid passing same arguments to Carousel and Item
            TestModeCarousel(
                numberOfItems: CGFloat(testModeViewModel.count),
                spacing: spacing,
                widthOfHiddenCards: widthOfHiddenCards,
                testModeViewModel: testModeViewModel
            ) {
                ForEach(0 ..< testModeViewModel.questionCount, id: \.self) { i in
                    Item(
                        _id: Int(i),
                        spacing: spacing,
                        widthOfHiddenCards: widthOfHiddenCards,
                        cardHeight: cardHeight,
                        testModeViewModel: testModeViewModel
                    ) {
                        VStack {
                            Text("\(flashcards[i].flashcard.prompt)")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding()
                            if testModeViewModel.currentType == "TF" {
                                Text("\(testModeViewModel.tfOption)")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .onAppear {
                                        self.testModeViewModel.setTrueFalseOption()
                                    }
                            }
                        }
                    }
                    .foregroundColor(.primary)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .transition(AnyTransition.slide)
                    .animation(.spring())
                }
            }
        }
    }
}

struct TestModeCarousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @ObservedObject var testModeViewModel: TestModeViewModel
        
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        testModeViewModel: TestModeViewModel,
        @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.testModeViewModel = testModeViewModel
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
    }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
                
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(testModeViewModel.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(testModeViewModel.activeCard) + 1)

        var calcOffset = Float(activeOffset)
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Item<Content: View>: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    let cardWidth: CGFloat
    let cardHeight: CGFloat

    var _id: Int
    var content: Content

    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        testModeViewModel: TestModeViewModel,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        self.cardHeight = cardHeight
        self.testModeViewModel = testModeViewModel
        self._id = _id
    }

    var body: some View {
        content
            .frame(width: cardWidth, height: _id == testModeViewModel.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
    }
}

//struct AdvancedOptions: View {
//    var body: some View {
//        Text("Advanced Options")
//    }
//}

struct Written: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    @State private var answerEntered = ""
    
    var body: some View {
        HStack {
//            FirstResponderTextField(text: $answerEntered, placeholder: "Type your answer...")
            TextField("Type your answer...", text: $answerEntered)
            Spacer()
            if self.answerEntered == "" {
                Button(action: {
                    self.testModeViewModel.nextCard()
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                }, label: {
                    Text("Don't know")
                        .font(.headline)
                })
            } else {
                Button(action: {
                    self.testModeViewModel.submitAnswer(answerEntered)
                    self.answerEntered = ""
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    
                }, label: {
                    Text("Submit")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .foregroundColor(.white)
                        .font(.subheadline.bold())
                        .background(Color.accentColor)
                        .cornerRadius(5)
                })
                .frame(width: 90)
            }
        }
        .frame(height: 30)
        .padding()
    }
}

struct TrueFalse: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button("True") {
                        testModeViewModel.submitTFAnswer(true)
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                    }
                    .buttonStyle(TestModeButtonStyle())
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.2)
                    
                    Spacer()
                    
                    Button("False") {
                        testModeViewModel.submitTFAnswer(false)
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                    }
                    .buttonStyle(TestModeButtonStyle())
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.2)
                    
                    Spacer()
                }
                .frame(height: geometry.size.height * 0.2)
                Spacer()
            }
        }
    }
}

struct TestModeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .font(.headline)
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 5)
                            .fill(configuration.isPressed ? Color(hex: "15CDA8") : Color.accentColor))
            .padding()
    }
}

struct MultipleChoice: View {
    @ObservedObject var testModeViewModel: TestModeViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ForEach(testModeViewModel.mcqOptions, id: \.self) { option in
                    Button(action: {
                        self.testModeViewModel.submitAnswer(option)
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                    }, label: {
                        Text("\(option)")
                            .padding()
                    })
                    .buttonStyle(MultipleChoiceButtonStyle())
                    .padding(.vertical, 4)
                    .frame(height: geometry.size.height * 0.2)
                }
                
            }
            .onAppear {
                self.testModeViewModel.setMCQOptions()
            }
        }
        
    }
}

struct MultipleChoiceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .foregroundColor(.primary)
            .background(RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(configuration.isPressed ? Color(hex: "15CDA8") : Color.accentColor, lineWidth: 2))
    }
}

//struct TestModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestModeView()
//    }
//}
