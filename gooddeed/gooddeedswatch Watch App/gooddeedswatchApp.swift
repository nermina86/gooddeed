import SwiftUI

@main
struct gooddeedswatchApp: App {
    @StateObject private var viewModel = GoodDeedViewModel()

    init() {
        // Pokretanje WatchConnectivity managera
        let _ = WatchConnectivityManager.shared
    }

    var body: some Scene {
        WindowGroup {
            WatchContentView(viewModel: viewModel)
                .environmentObject(viewModel)
        }
    }
}
