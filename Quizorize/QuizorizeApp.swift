//
//  QuizorizeApp.swift
//  Quizorize
//
//  Created by Remus Kwan on 21/5/21.
//

import SwiftUI
import Firebase
import GoogleSignIn
import UIKit

@main
struct QuizorizeApp: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    let persistenceController = PersistenceController.shared

    init() {
        setupAuthentication()
//        setupFirestore()
    }
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            LaunchView()
                .environmentObject(AuthViewModel())
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        return true
//    }
//}

extension QuizorizeApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
//    private func setupFirestore() {
//        let db = Firestore.firestore()
//    }
}
