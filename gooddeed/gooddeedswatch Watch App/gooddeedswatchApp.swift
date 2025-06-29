import SwiftUI

@main
struct gooddeedswatchApp: App {
    @StateObject var viewModel = GoodDeedViewModel()

    var body: some Scene {
        WindowGroup {
            GoodDeedWatchView()
                .environmentObject(viewModel)
        }
    }
}
