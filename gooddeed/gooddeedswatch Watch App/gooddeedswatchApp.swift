import SwiftUI

@main
struct gooddeedswatchApp: App {
    @StateObject private var viewModel = GoodDeedViewModel()

    var body: some Scene {
        WindowGroup {
            WatchContentView(viewModel: viewModel)
                .environmentObject(viewModel)
        }
    }
}
