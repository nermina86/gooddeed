//IntroView.swift
import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
        ZStack {
            // Fully opaque background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Spacer().frame(height: 40)

                Text("🌟 Welcome to Good Deeds APP!")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Text("Each day, you'll get simple but meaningful actions to make this world a brighter place. You can skip deeds that don’t fit or add your own.")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                
                VStack(spacing: 16) {
                    Text("How many deeds per day do you want to be displayed?")
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

                
                
                // ✅ Privacy Policy Button
                        NavigationLink(destination: PrivacyPolicyView()) {
                            Text("Privacy Policy")
                                .font(.footnote)
                                .underline()
                                .foregroundColor(.gray)
                        }
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

