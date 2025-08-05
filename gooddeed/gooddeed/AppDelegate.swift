import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        cancelPendingDeedNotification()
        saveLastOpenTime()
        scheduleDeedReminderForTomorrow()
    }

    private func saveLastOpenTime() {
        UserDefaults.standard.set(Date(), forKey: "lastOpenTime")
    }

    private func scheduleDeedReminderForTomorrow() {
        guard let lastOpen = UserDefaults.standard.object(forKey: "lastOpenTime") as? Date else { return }

        let nextReminderTime = Calendar.current.date(byAdding: .day, value: 1, to: lastOpen)!

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextReminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "Your new good deeds are ready!"
        content.body = "Open the app to start your day with kindness."
        content.sound = .default

        let request = UNNotificationRequest(identifier: "dailyDeedReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelPendingDeedNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyDeedReminder"])
    }
}
