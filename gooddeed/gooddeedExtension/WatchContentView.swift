import SwiftUI

struct WatchContentView: View {
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
        VStack {
            Text("Good Deeds")
                .font(.headline)
                .padding()

            List {
                ForEach(viewModel.todayDeeds, id: \.id) { deed in
                    HStack {
                        Text(deed.title)
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
        }
    }
}
