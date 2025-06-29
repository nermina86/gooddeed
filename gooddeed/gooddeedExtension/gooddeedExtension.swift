import SwiftUI

@main
struct GoodDeedExtensionApp: App {
    // Ovo je ViewModel koji dijeliš s WatchContentView
    @StateObject private var viewModel = GoodDeedViewModel()

    var body: some Scene {
        WindowGroup {
            WatchContentView(viewModel: viewModel)
        }
    }
}
