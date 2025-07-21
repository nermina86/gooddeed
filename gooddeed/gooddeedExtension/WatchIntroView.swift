// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//

import SwiftUI

struct WatchIntroView: View {
    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false
    @AppStorage("preferredDeedCount") var preferredDeedCount: Int = 3

    var body: some View {
        VStack(spacing: 12) {
            Text("🌟 The GoodDeedsApp")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Swipe to snooze deed")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("How many deeds daily?")
                .font(.caption2)

            Picker("Deeds", selection: $preferredDeedCount) {
                ForEach(1...10, id: \.self) { count in
                    Text("\(count)").tag(count)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 60) // Reduce height
            .clipped()
            .labelsHidden()
            .scaleEffect(0.8) // Scale down visually

            Button("Start") {
                hasSeenIntro = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
