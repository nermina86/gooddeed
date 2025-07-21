// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import SwiftUI
import UIKit

struct ShareView: View {
    @Binding var isPresented: Bool

    var body: some View {
        EmptyView()
            .sheet(isPresented: $isPresented) {
                let message = """
                I just completed all my good deeds for today using the GoodDeeds app! 🌟

                Download the app and make your gooddeeds: https://example.com/app
                """
                ActivityView(activityItems: [message])
            }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
