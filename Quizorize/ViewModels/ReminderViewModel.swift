//
//  ReminderViewModel.swift
//  Quizorize
//
//  Created by Remus Kwan on 14/7/21.
//

import Foundation
import SwiftUI

class ReminderViewModel: ObservableObject {
    func sendReminderNotif(deckTitle: String, reminderTime: TimeInterval) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound],
                    completionHandler: { _, _ in }
                )
            case .authorized, .provisional:
                let content = UNMutableNotificationContent()
                content.title = "Revise soon!"
                content.body = "Revise \(deckTitle) to make the most out of your Quizorize revision!"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderTime, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            default:
                break
            }
        }
    }
    
//    func sendTestReminderNotif(deckTitle: String, reminderTime: TimeInterval) {
//        let content = UNMutableNotificationContent()
//        content.title = "Test Reminder"
//        content.body = "Test yourself on \(deckTitle) to maximise your Quizorize revision."
//        content.sound = UNNotificationSound.default
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderTime, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request)
//    }
//    
//    func togglePushNotifications() {
//        let current = UNUserNotificationCenter.current()
//        current.getNotificationSettings { settings in
//            if settings.authorizationStatus == .authorized {
//                
//            }
//        }
//    }
}
