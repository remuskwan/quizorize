//
//  QuizorizeApp.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI

@main
struct QuizorizeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
