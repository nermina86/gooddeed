//
// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import Foundation
import UserNotifications

struct WatchNotificationScheduler {

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Watch notification permission error: \(error.localizedDescription)")
            }
        }
    }

    static func scheduleDailyNotification(for date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["watchDeedReminder"])

        let triggerTime = Calendar.current.dateComponents([.hour, .minute], from: date)

        let content = UNMutableNotificationContent()
        content.title = "✨ Your next good deed awaits!"
        content.body = "Let’s keep the kindness going today!"
        content.sound = nil


        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        let request = UNNotificationRequest(identifier: "watchDeedReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Watch notification scheduling failed: \(error.localizedDescription)")
            }
        }
    }
}
