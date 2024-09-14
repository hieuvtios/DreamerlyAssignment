//
//  Utilities.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/10/24.
//

import Foundation
import UserNotifications
import UIKit

class Utilities {
    static let shared = Utilities()
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
     func provideHapticFeedback() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare() // Prepare the feedback generator
        impactFeedbackGenerator.impactOccurred() // Trigger the feedback
    }
    func scheduleLocalNotification(for note: Note) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Reminder for: \(note.notename ?? "Unnamed Task")"
        content.sound = .default
        
        // Create a date trigger based on the 'remindAt' date
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: note.reminddate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for task: \(note.notename ?? "Unnamed Task") due date \(String(describing: note.duedate)) remind at \(String(describing: note.reminddate)) ")
            }
        }
    }
}
