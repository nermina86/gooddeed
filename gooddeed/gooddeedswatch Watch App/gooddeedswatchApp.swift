// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI

@main
struct gooddeedswatchApp: App {
    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false
    @StateObject private var viewModel = GoodDeedViewModel()

    init() {
        let _ = WatchConnectivityManager.shared
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenIntro {
                WatchContentView(viewModel: viewModel)
            } else {
                WatchIntroView()
            }
        }
    }
}
