import SwiftUI

struct WatchIntroView: View {
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.todayDeeds.prefix(3), id: \.id) { deed in
                VStack(spacing: 10) {
                    Text(deed.text)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding()

                    Button(action: {
                        viewModel.markAsDone(deed: deed)
                    }) {
                        Text(deed.isCompleted ? "✅ Done" : "Mark as done")
                            .font(.headline)
                            .foregroundColor(deed.isCompleted ? .green : .blue)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(deed.isCompleted ? Color.green : Color.blue, lineWidth: 2)
                            )
                    }
                }
                .id(deed.id) // 🔁 Forsira re-render kad se stanje promijeni
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

