// WatchIntroView.swift
// GoodDeeds
// © 2025 Nermina Memisevic. All rights reserved.

import SwiftUI

struct WatchIntroView: View {
    @AppStorage("hasSeenIntro", store: .appGroup) var hasSeenIntro: Bool = false
    @AppStorage("preferredDeedCount", store: .appGroup) var preferredDeedCount: Int = 3

    var body: some View {
        VStack(spacing: 12) {
            Text("🌟 The GoodDeeds")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Swipe to snooze deed")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Tap deed to mark it done")
                .font(.caption2)

            Text("How many deeds daily?")
                .font(.caption2)

            Picker("Deeds", selection: $preferredDeedCount) {
                ForEach(1...10, id: \.self) { count in
                    Text("\(count)").tag(count)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 60)
            .clipped()
            .labelsHidden()
            .scaleEffect(0.8)

            Button("Start") {
                hasSeenIntro = true
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
