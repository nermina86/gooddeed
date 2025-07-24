import SwiftUI
import Combine
import WatchConnectivity

final class GoodDeedViewModel: ObservableObject {
    @Published var todayDeeds: [GoodDeed] = []
    @Published var preferredDeedCount: Int

    private let sharedDefaults = UserDefaults(suiteName: "group.com.gooddeed.gooddeedsapp")

    private func saveDeedsToSharedDefaults() {
        let encoded = todayDeeds.map { ["id": $0.id.uuidString, "title": $0.title, "isCompleted": $0.isCompleted] }
        sharedDefaults?.set(encoded, forKey: "todayDeeds")
        sharedDefaults?.set(preferredDeedCount, forKey: "preferredDeedCount")
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
        let savedCount = sharedDefaults?.integer(forKey: "preferredDeedCount") ?? 3
        preferredDeedCount = savedCount

        loadDeedsFromSharedDefaults()
        if todayDeeds.isEmpty {
            loadInitialDeeds()
        }

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
        let count = preferredDeedCount > 0 ? preferredDeedCount : 3
        let selected = DeedSource.allDeeds.shuffled().prefix(count)
        self.todayDeeds = selected.map {
            GoodDeed(id: UUID(), title: $0, isCompleted: false)
        }
        saveDeedsToSharedDefaults()
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

        let suggestions = DeedSource.allDeeds.filter { suggestion in
            !todayDeeds.contains(where: { $0.title == suggestion }) && suggestion != deed.title
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

    func markDeedAsCompleted(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(of: deed) {
            todayDeeds[index].isCompleted = true
            saveDeedsToSharedDefaults()
        }
    }

    var allDeedsCompleted: Bool {
        todayDeeds.allSatisfy { $0.isCompleted }
    }
}

