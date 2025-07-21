//
// IntroView.swift
// GoodDeeds
//
// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//

import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool
    @Binding var preferredDeedCount: Int
    var onStart: () -> Void

    var body: some View {
        ZStack {
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
                    .padding(.horizontal)

                Text("How many deeds per day do you want to do?")
                    .foregroundColor(.white)
                    .font(.headline)

                Stepper(value: $preferredDeedCount, in: 1...10) {
                    Text("\(preferredDeedCount) deeds")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)

                Button(action: onStart) {
                    Text("Start")
                        .font(.title2.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy")
                        .font(.footnote)
                        .underline()
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
        }
    }
}import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool
    @Binding var preferredDeedCount: Int
    var onStart: () -> Void

    var body: some View {
        ZStack {
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
                    .padding(.horizontal)

                Text("How many deeds per day do you want to do?")
                    .foregroundColor(.white)
                    .font(.headline)

                Stepper(value: $preferredDeedCount, in: 1...10) {
                    Text("\(preferredDeedCount) deeds")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)

                Button(action: onStart) {
                    Text("Start")
                        .font(.title2.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy")
                        .font(.footnote)
                        .underline()
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
        }
    }
}
