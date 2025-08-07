//
// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationScheduler {

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    static func storeLastActiveTime() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: "lastActiveTime")
        scheduleDailyNotification(from: now)
    }

    private static func scheduleDailyNotification(from date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["deedReminder"])

        let calendar = Calendar.current
        let triggerTime = calendar.dateComponents([.hour, .minute], from: date)

        let content = UNMutableNotificationContent()
        content.title = "🌟 Your new good deeds are waiting!"
        content.body = "Can't wait for you to continue your good deeds today!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "")) // 🔇 silent

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        let request = UNNotificationRequest(identifier: "deedReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Notification scheduling failed: \(error.localizedDescription)")
            }
        }
    }
}
