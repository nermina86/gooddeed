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
