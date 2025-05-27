import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GoodDeedViewModel()
    @State private var showIntro = true  // Always true on launch
    @State private var showAddDeed = false
    @State private var newDeedText = ""
    @State private var showCongrats = true
    @State private var isDoneForToday = false



    // Computed property to check if all deeds are done
    var allCompleted: Bool {
        !viewModel.todayDeeds.isEmpty && viewModel.todayDeeds.allSatisfy { $0.isCompleted }
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Today's Good Deeds")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.top, 20)

                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(zip(viewModel.todayDeeds.indices, viewModel.todayDeeds)), id: \.1.id) { index, deed in
                                HStack {
                                    Text("\(index + 1). \(deed.text)")
                                        .font(.body)
                                        .foregroundColor(deed.isCompleted ? .red : .primary)
                                        .strikethrough(deed.isCompleted)
                                    Spacer()

                                    Button(action: {
                                        withAnimation {
                                            viewModel.markAsDone(deed: deed)
                                        }
                                    }) {
                                        Image(systemName: deed.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                                            .font(.title2)
                                            .foregroundColor(.green)
                                    }
                                    .disabled(isDoneForToday) // ✅ DISABLE CHECKMARK
                                    
                                    Button(action: {
                                        withAnimation {
                                            viewModel.snooze(deed: deed)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                    .disabled(isDoneForToday) // DISABLE SNOOZE FOR TODAY
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button(action: {
                        showAddDeed = true
                    }) {
                        Text("➕ Add a Good Deed")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(isDoneForToday) // disable add new deed if done for today
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showAddDeed) {
                    VStack(spacing: 20) {
                        Text("Add a Custom Good Deed")
                            .font(.title2)
                            .padding(.top)

                        TextField("Enter a good deed", text: $newDeedText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button("Add") {
                            if !newDeedText.trimmingCharacters(in: .whitespaces).isEmpty {
                                viewModel.addDeed(newDeed: newDeedText)
                                newDeedText = ""
                                showAddDeed = false
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                    
                    
        
                    
                    
                }
            }

            // Show fireworks emoji if all completed
            if allCompleted && showCongrats {
                Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("🎆")
                        .font(.system(size: 150))

                    Text("Congratulations!\nYou did good 🎉")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("You're done for today.\nCome back tomorrow for more good deeds!")
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    Button(action: {
                        withAnimation {
                            showCongrats = false
                            isDoneForToday = true // This disables future interaction
                        }
                    }) {
                        Text("Done for Today")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .transition(.scale)
            }
            
            
          // beging of intro window
            if showIntro {
                IntroView(showIntro: $showIntro, viewModel: viewModel)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
            // end of intro window

        }
    }
}

// ViewModel extension to mark deed done
extension GoodDeedViewModel {
    func markAsDone(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(where: { $0.id == deed.id }) {
            todayDeeds[index].isCompleted.toggle()
            saveTodayDeeds()  // save updated state
        }
        
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .light) // Try .dark for dark mode
    }
}
#endif
