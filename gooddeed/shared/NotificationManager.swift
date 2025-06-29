// NotificationManager.swift

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    private let usageKey = "usageHours"
    private let smartID = "smartReminder"

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // Request permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("🔔 Permission granted: \(granted), error: \(String(describing: error))")
        }
    }

    // Log app open hour
    func logAppOpen() {
        let hour = Calendar.current.component(.hour, from: Date())
        var hours = UserDefaults.standard.array(forKey: usageKey) as? [Int] ?? []
        hours.append(hour)
        if hours.count > 100 { hours.removeFirst() }
        UserDefaults.standard.set(hours, forKey: usageKey)
    }

    // Compute most frequent hour
    private func mostFrequentHour() -> Int? {
        guard let hours = UserDefaults.standard.array(forKey: usageKey) as? [Int], !hours.isEmpty else { return nil }
        let freq = hours.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        return freq.max { $0.value < $1.value }?.key
    }

    // Schedule smart notification once
    func scheduleSmart(message: String) {
        guard let hour = mostFrequentHour() else { return }

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [smartID])

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = Int.random(in: 0..<60)

        let content = UNMutableNotificationContent()
        content.title = "☀️ Just Checking In"
        content.body = message
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)

        let request = UNNotificationRequest(identifier: smartID, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled at \(comps.hour ?? -1):\(comps.minute ?? -1)")
            }
        }
    }

    // Test notification (fires after 5 seconds)
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🚀 Test Notification"
        content.body = "This is a test to verify that notifications work."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling test notification: \(error.localizedDescription)")
            } else {
                print("✅ Test notification scheduled to fire in 5 seconds.")
            }
        }
    }

    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // Call this when a new deed is added to fire a test notification
    func notifyOnNewDeed() {
        scheduleTestNotification()
    }
}
