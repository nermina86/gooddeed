import SwiftUI

struct WatchIntroView: View {
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                Text("🌟 Welcome to Good Deeds!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                ForEach(Array(viewModel.todayDeeds.prefix(3)), id: \.id) { deed in
                    Text("• \(deed.title)")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.25))
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
        }
    }
}
