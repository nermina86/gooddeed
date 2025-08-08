//
// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI

@main
struct gooddeedswatchApp: App {
    @AppStorage("hasSeenIntro", store: .appGroup) var hasSeenIntro: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasSeenIntro {
                // ✅ Fresh ViewModel that reads updated preferredDeedCount
                WatchContentView(viewModel: GoodDeedViewModel())
            } else {
                WatchIntroView()
            }
        }
    }
}
