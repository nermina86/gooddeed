import Foundation

class GoodDeedViewModel: ObservableObject {
    @Published var todayDeeds: [GoodDeed] = []
    @Published var preferredDeedCount: Int = 5 {
        didSet {
            UserDefaults.standard.set(preferredDeedCount, forKey: "preferredDeedCount")
            refreshDeeds()
        }
    }
    
    private(set) var allDeeds: [GoodDeed] = []
    
    private let savedDeedsKey = "savedGoodDeeds"
    
    init() {
        loadSavedDeeds()
        preferredDeedCount = UserDefaults.standard.integer(forKey: "preferredDeedCount")
        if preferredDeedCount == 0 { preferredDeedCount = 5 } // default value
        
        if isNewDay() {
            refreshDeeds()
            UserDefaults.standard.set(Date(), forKey: lastRefreshDateKey)
        } else {
            loadTodayDeeds()
        }
    }
    
    func refreshDeeds() {
        let customDeeds = todayDeeds.filter { $0.isCustom }
        let needed = max(0, preferredDeedCount - customDeeds.count)
        
        // Filter auto deeds excluding custom deeds by text
        let availableAutoDeeds = allDeeds
            .filter { deed in
                !deed.isCustom && !customDeeds.contains(where: { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) == deed.text.trimmingCharacters(in: .whitespacesAndNewlines) })
            }
            .shuffled()
            .prefix(needed)
        
        // Combine custom and auto deeds (new list)
        let newDeeds = customDeeds + availableAutoDeeds
        
        // Create a dictionary of completed deeds from old todayDeeds for quick lookup
        let completedDict = Dictionary(uniqueKeysWithValues: todayDeeds.map { ($0.text, $0.isCompleted) })
        
        // Map newDeeds but preserve completed state if previously completed
        todayDeeds = newDeeds.map { deed in
            var d = deed
            d.isCompleted = completedDict[deed.text] ?? false
            return d
        }
        
        saveTodayDeeds()
    }
    func saveTodayDeeds() {
        if let data = try? JSONEncoder().encode(todayDeeds) {
            UserDefaults.standard.set(data, forKey: "todayDeeds")
        }
        UserDefaults.standard.set(Date(), forKey: lastRefreshDateKey)
    }
    
    private func loadTodayDeeds() {
        if let data = UserDefaults.standard.data(forKey: "todayDeeds"),
           let saved = try? JSONDecoder().decode([GoodDeed].self, from: data) {
            todayDeeds = saved
        } else {
            refreshDeeds()
        }
    }
    
    func snooze(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(where: { $0.id == deed.id }) {
            todayDeeds[index] = allDeeds.randomElement() ?? GoodDeed(text: "Do something kind!")
        }
        saveTodayDeeds()
    }
    
    func addDeed(newDeed: String) {
        let trimmed = newDeed.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let deed = GoodDeed(text: trimmed, isCustom: true)
        todayDeeds.insert(deed, at: 0)
        saveTodayDeeds()
    }
    
    private func loadSavedDeeds() {
        if let data = UserDefaults.standard.data(forKey: savedDeedsKey),
           let saved = try? JSONDecoder().decode([GoodDeed].self, from: data) {
            allDeeds = saved
        } else {
            // Default deeds on first launch
            allDeeds = [
                GoodDeed(text: "Help someone with their groceries"),
                GoodDeed(text: "Call an old friend to see how he is"),
                GoodDeed(text: "Donate unused clothes or items"),
                GoodDeed(text: "Give a compliment to a stranger"),
                GoodDeed(text: "Say you are beautiful to lonely girl"),
                GoodDeed(text: "Help an elderly person with their things"),
                GoodDeed(text: "Give a present to a friend"),
                GoodDeed(text: "Cook a meal for somebody dear"),
                GoodDeed(text: "Call your mother or a father"),
                GoodDeed(text: "Donate money or feed a poor"),
                GoodDeed(text: "Pick up trash in your neighborhood"),
                GoodDeed(text: "Pay for someone's coffee"),
                GoodDeed(text: "Share noble status on social media"),
                GoodDeed(text: "Give someone a ride or help with transportation")
            ]
        }
    }
    
    private func saveDeeds() {
        if let data = try? JSONEncoder().encode(allDeeds) {
            UserDefaults.standard.set(data, forKey: savedDeedsKey)
        }
    }
}

// Helpers for daily reset
private let lastRefreshDateKey = "lastDeedRefreshDate"

private func isNewDay() -> Bool {
    guard let lastDate = UserDefaults.standard.object(forKey: lastRefreshDateKey) as? Date else {
        return true
    }
    return !Calendar.current.isDateInToday(lastDate)
}

func markAsDone(deed: GoodDeed) {
    // This is a global function but should belong inside GoodDeedViewModel, so move it there
}

