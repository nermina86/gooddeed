// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI
import WatchKit

struct WatchContentView: View {
    @ObservedObject var viewModel: GoodDeedViewModel

    var body: some View {
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
                                Label("Snooze", systemImage: "zzz")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            WKInterfaceDevice.current().play(.click)
        }
    }
}
