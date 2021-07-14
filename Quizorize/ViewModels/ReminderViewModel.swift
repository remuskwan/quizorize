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
        let content = UNMutableNotificationContent()
        content.title = "Revise soon!"
        content.body = "Revise DeckName to make the most out of your Quizorize revision!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderTime, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
