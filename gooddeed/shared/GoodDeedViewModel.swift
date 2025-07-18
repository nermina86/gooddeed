import SwiftUI
import Combine
import WatchConnectivity

final class GoodDeedViewModel: ObservableObject {
    @Published var todayDeeds: [GoodDeed] = []
    @Published var preferredDeedCount: Int = 3

    init() {
        loadInitialDeeds()

        NotificationCenter.default.addObserver(
            forName: .didReceiveDeed,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let deed = notification.object as? GoodDeed {
                self?.receive(deed: deed)
            }
        }
    }

    private func loadInitialDeeds() {
        let allDeeds = [
            "Help someone", "Recycle trash", "Call a loved one", "Pick up litter", "Compliment a stranger",
            "Smile at someone", "Donate old clothes", "Let someone go ahead of you", "Say thank you", "Text a friend"
        ]

        let selected = allDeeds.shuffled().prefix(preferredDeedCount)
        self.todayDeeds = selected.map {
            GoodDeed(id: UUID(), title: $0, isCompleted: false)
        }
    }

    func refreshDeeds() {
        loadInitialDeeds()
    }

    func markAsDone(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(of: deed) {
            todayDeeds[index].isCompleted = true
            ConnectivityManager.shared.send(deed: todayDeeds[index])
        }
    }

    func snooze(deed: GoodDeed) {
        guard let index = todayDeeds.firstIndex(of: deed) else { return }

        todayDeeds.remove(at: index)

        let suggestions = [
            "Write a kind note", "Give someone a hug", "Hold the door", "Pick flowers", "Send a positive text"
        ].filter { suggestion in
            !todayDeeds.contains(where: { $0.title == suggestion })
        }

        if let newTitle = suggestions.randomElement() {
            let newDeed = GoodDeed(id: UUID(), title: newTitle, isCompleted: false)
            todayDeeds.insert(newDeed, at: index)
        }
    }

    func addDeed(title: String) {
        let deed = GoodDeed(id: UUID(), title: title, isCompleted: false)
        todayDeeds.append(deed)
    }

    private func receive(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(where: { $0.id == deed.id }) {
            todayDeeds[index] = deed
        } else {
            todayDeeds.append(deed)
        }
    }
}

