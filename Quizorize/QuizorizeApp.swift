//
//  QuizorizeApp.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI
import Firebase

@main
struct QuizorizeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
