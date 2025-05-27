import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Spacer().frame(height: 40)  // Space before header

                Text("🌟 Welcome to Good Deeds APP!")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Text("Each day, you'll get simple but meaningful actions to make this world brighter place. You can skip deeds that doesn’t fit in or add your own ones ")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    Text("How many deeds per day you want to show?")
                        .font(.headline)
                        .foregroundColor(.white)

                    Stepper(value: $viewModel.preferredDeedCount, in: 1...10) {
                        Text("\(viewModel.preferredDeedCount) deeds")
                            .foregroundColor(.white)
                            .font(.body)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }

                Button(action: {
                    showIntro = false
                    viewModel.refreshDeeds()
                }) {
                    Text("Get Started 😇")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}

#if DEBUG
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(showIntro: .constant(true), viewModel: GoodDeedViewModel())
    }
}
#endif
