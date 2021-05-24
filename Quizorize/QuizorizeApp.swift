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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            LaunchView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
      
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        Auth.auth().signIn(with: credential) { result, error in
            //Sign In failure
            guard result != nil, error == nil else {
                print((error?.localizedDescription)!)
                return
            }
            //Send Notification to UI
            NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
            
            //print(result?.user.email)
        }
    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        <#code#>
//    }
}
