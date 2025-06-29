import SwiftUI

struct GoodDeedWatchView: View {
    @EnvironmentObject var viewModel: GoodDeedViewModel

    var body: some View {
        VStack(spacing: 10) {
            if let todayDeed = viewModel.todayDeeds.first {
                Text(todayDeed.text)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Button(action: {
                    viewModel.markAsDone(deed: todayDeed)
                }) {
                    Text(todayDeed.isCompleted ? "✅ Completed" : "Mark as Done")
                }
            } else {
                Text("No deeds for today.")
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
