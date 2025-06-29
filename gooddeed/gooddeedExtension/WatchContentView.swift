import SwiftUI

struct WatchContentView: View {
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
        VStack {
            Text("Good Deeds on Apple Watch")
                .font(.headline)
                .padding()
            
            List(viewModel.todayDeeds) { deed in
                HStack {
                    Text(deed.text)
                        .strikethrough(deed.isCompleted)
                        .foregroundColor(deed.isCompleted ? .green : .primary)
                    Spacer()
                    Button(action: {
                        viewModel.markAsDone(deed: deed)
                    }) {
                        Image(systemName: deed.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                }
            }
        }
        .onAppear {
            // Refresh deeds on watch appear
            viewModel.refreshDeeds()
        }
    }
}
