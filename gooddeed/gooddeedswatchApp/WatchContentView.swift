//
// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI
import WatchKit

struct WatchContentView: View {
    @ObservedObject var viewModel: GoodDeedViewModel
    @State private var showFireworks = false

    var body: some View {
        ZStack {
            VStack {
                Text("Good Deeds")
                    .font(.headline)
                    .padding()

                List {
                    if viewModel.todayDeeds.isEmpty {
                        Text("No deeds available.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.todayDeeds, id: \.id) { deed in
                            Button {
                                viewModel.markAsDone(deed: deed)
                                if viewModel.allDeedsCompleted {
                                    triggerFireworks()
                                }
                            } label: {
                                HStack {
                                    Text(deed.title)
                                        .strikethrough(deed.isCompleted)
                                        .foregroundColor(deed.isCompleted ? .gray : .primary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.snooze(deed: deed)
                                } label: {
                                    Label("Snooze", systemImage: "X")
                                }
                            }
                        }
                    }
                }
            }

            if showFireworks {
                VStack(spacing: 8) {
                    Text("🎆🎉")
                        .font(.system(size: 60))
                    Text("Well Done!")
                        .font(.headline)
                    Text("You completed good deeds for today.")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .transition(.scale)
                .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.loadDeedsIfNeeded()
            }
            WKInterfaceDevice.current().play(.click)

            // 🔔 Schedule silent daily notification on Watch
            WatchNotificationScheduler.requestPermission()
            WatchNotificationScheduler.scheduleDailyNotification(for: Date())
        }
        
    }

    private func triggerFireworks() {
        WKInterfaceDevice.current().play(.success)
        withAnimation {
            showFireworks = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showFireworks = false
            }
        }
    }
}
