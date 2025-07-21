// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GoodDeedViewModel()
    @State private var showIntro = true
    @State private var showAddDeed = false
    @State private var newDeedText = ""
    @State private var showCongrats = false
    @State private var isDoneForToday = false
    @State private var showShareSheet = false

    var body: some View {
        ZStack {
            if !showIntro {
                NavigationView {
                    VStack(spacing: 20) {
                        Text("Today's Good Deeds you will do")
                            .font(.headline)
                            .padding(.top, 20)

                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(viewModel.todayDeeds.indices, id: \.self) { index in
                                    let deed = viewModel.todayDeeds[index]
                                    HStack {
                                        Text("\(index+1). \(deed.title)")
                                            .strikethrough(deed.isCompleted)
                                            .foregroundColor(deed.isCompleted ? .red : .primary)
                                        Spacer()
                                        Button(action: {
                                            withAnimation { viewModel.markAsDone(deed: deed) }
                                        }) {
                                            Image(systemName: deed.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                                                .font(.title2)
                                                .foregroundColor(.green)
                                        }
                                        .disabled(isDoneForToday)

                                        Button(action: {
                                            withAnimation { viewModel.snooze(deed: deed) }
                                        }) {
                                            Image(systemName: "xmark.circle")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                        }
                                        .disabled(isDoneForToday)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                }
                            }
                            .padding(.horizontal)
                        }

                        Button(action: { showAddDeed = true }) {
                            Text("➕ Add a Good Deed")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(isDoneForToday)
                        .padding([.horizontal, .bottom], 20)
                    }
                    .navigationBarHidden(true)
                    .sheet(isPresented: $showAddDeed) { addDeedSheet }
                    .onAppear {
                        NotificationManager.shared.requestPermission()
                        NotificationManager.shared.logAppOpen()
                        NotificationManager.shared.scheduleSmart(message: "How about one small good deed today?")
                    }
                }
            }

            if viewModel.todayDeeds.allSatisfy({ $0.isCompleted }) && !viewModel.todayDeeds.isEmpty && !isDoneForToday {
                congratsOverlay
            }

            if showIntro {
                introOverlay
            }

            ShareView(isPresented: $showShareSheet)
        }
    }

    private var addDeedSheet: some View {
        VStack(spacing: 20) {
            Text("Add a Custom Good Deed")
                .font(.title2)
                .padding(.top)
            TextField("Enter a good deed", text: $newDeedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Button("Add") {
                if !newDeedText.trimmingCharacters(in: .whitespaces).isEmpty {
                    viewModel.addDeed(title: newDeedText)
                    newDeedText = ""
                    showAddDeed = false
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            Spacer()
        }
        .padding()
    }

    private var congratsOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("🎆")
                    .font(.system(size: 120))
                Text("Congratulations! You did all deeds today. 🎉")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Button("Done for Today") {
                    withAnimation {
                        isDoneForToday = true
                        NotificationManager.shared.scheduleSmart(message: "Ready for more kindness tomorrow?")
                    }
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(10)
                .padding(.horizontal)

                Button(action: {
                    showShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Your Good Deeds")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
    }

    private var introOverlay: some View {
        NavigationView {
            IntroView(
                showIntro: $showIntro,
                preferredDeedCount: $viewModel.preferredDeedCount,
                onStart: {
                    viewModel.refreshDeeds()
                    showIntro = false
                }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
