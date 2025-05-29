import SwiftUI
import UserNotifications

@main
struct GoodDeedsApp: App {
    init() {
        NotificationManager.shared.requestPermission()
        NotificationManager.shared.logAppOpen()
        NotificationManager.shared.scheduleSmart(message: "How about one small good deed today?")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NotificationManager.shared.logAppOpen()
                }
        }
    }
}
