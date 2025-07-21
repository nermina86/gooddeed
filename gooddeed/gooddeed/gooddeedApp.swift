// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI
import Firebase

@main
struct gooddeedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
