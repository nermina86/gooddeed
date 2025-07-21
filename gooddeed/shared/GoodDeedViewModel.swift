
import SwiftUI
import Combine
import WatchConnectivity

final class GoodDeedViewModel: ObservableObject {
    @Published var todayDeeds: [GoodDeed] = []
    @Published var preferredDeedCount: Int = 3

    private let sharedDefaults = UserDefaults(suiteName: "group.com.gooddeed.gooddeedsapp")

    private func saveDeedsToSharedDefaults() {
        let encoded = todayDeeds.map { ["id": $0.id.uuidString, "title": $0.title, "isCompleted": $0.isCompleted] }
        sharedDefaults?.set(encoded, forKey: "todayDeeds")
    }

    private func loadDeedsFromSharedDefaults() {
        guard let array = sharedDefaults?.array(forKey: "todayDeeds") as? [[String: Any]] else { return }
        self.todayDeeds = array.compactMap {
            guard let idStr = $0["id"] as? String,
                  let id = UUID(uuidString: idStr),
                  let title = $0["title"] as? String,
                  let isCompleted = $0["isCompleted"] as? Bool else { return nil }
            return GoodDeed(id: id, title: title, isCompleted: isCompleted)
        }
    }

    init() {
        loadDeedsFromSharedDefaults()
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
            "Smile at someone", "Donate old clothes", "Let someone go ahead of you", "Say thank you", "Text a friend",
            "Help someone1", "Recycle trash1", "Call a loved one1", "Pick up litter1", "Compliment a stranger1",
            "Smile at someone1", "Donate old clothes1", "Let someone go ahead of you1", "Say thank you1", "Text a friend1",
        ]

        let selected = allDeeds.shuffled().prefix(preferredDeedCount)
        self.todayDeeds = selected.map {
            saveDeedsToSharedDefaults()
            return GoodDeed(id: UUID(), title: $0, isCompleted: false)
        }
    }

    func refreshDeeds() {
        loadInitialDeeds()
    }

    func markAsDone(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(of: deed) {
            todayDeeds[index].isCompleted = true
            saveDeedsToSharedDefaults()
            ConnectivityManager.shared.send(deed: todayDeeds[index])
        }
    }

    func snooze(deed: GoodDeed) {
        guard let index = todayDeeds.firstIndex(of: deed) else { return }

        todayDeeds.remove(at: index)

        let suggestions = [
            "Write a kind note2", "Give someone a hug2", "Hold the door2", "Pick flowers2", "Send a positive text2"
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

