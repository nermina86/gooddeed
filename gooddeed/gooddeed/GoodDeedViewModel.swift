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
        if preferredDeedCount == 0 { preferredDeedCount = 5 }
        
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
        
        let availableAutoDeeds = allDeeds
            .filter { deed in
                !deed.isCustom &&
                !customDeeds.contains(where: { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) == deed.text.trimmingCharacters(in: .whitespacesAndNewlines) })
            }
            .shuffled()
            .prefix(needed)
        
        let newDeeds = customDeeds + availableAutoDeeds
        
        let completedDict = Dictionary(uniqueKeysWithValues: todayDeeds.map { ($0.text, $0.isCompleted) })
        
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
            // Replace with a random deed from allDeeds
            todayDeeds[index] = allDeeds.randomElement() ?? GoodDeed(text: "Do something kind!")
            saveTodayDeeds()
        }
    }
    
    func addDeed(newDeed: String) {
        let trimmed = newDeed.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let deed = GoodDeed(text: trimmed, isCustom: true)
        todayDeeds.insert(deed, at: 0)
        saveTodayDeeds()
    }
    
    func markAsDone(deed: GoodDeed) {
        if let index = todayDeeds.firstIndex(where: { $0.id == deed.id }) {
            todayDeeds[index].isCompleted.toggle()
            saveTodayDeeds()
        }
    }
    
    private func loadSavedDeeds() {
        if let data = UserDefaults.standard.data(forKey: savedDeedsKey),
           let saved = try? JSONDecoder().decode([GoodDeed].self, from: data) {
            allDeeds = saved
        } else {
            allDeeds = [
                GoodDeed(text: "Help someone with their groceries/daily tasks"),
                GoodDeed(text: "Give someone a genuine smile to brighten their day"),
                GoodDeed(text: "Call an old friend to check how he is"),
                GoodDeed(text: "Donate unused item to somebody who will rather use it"),
                GoodDeed(text: "Give a compliment to a complete stranger"),
                GoodDeed(text: "Say you are beautiful to one lonely girl/boy"),
                GoodDeed(text: "Help an elderly person or neighbor with their daily things"),
                GoodDeed(text: "Give a present to a friend or your colleague"),
                GoodDeed(text: "Smile to a kid or buy him/her a candy"),
                GoodDeed(text: "Pick up the trash in your neighborhood / in nature"),
                GoodDeed(text: "Celebrate someone’s achievements sincerely"),
                GoodDeed(text: "Cook a meal for somebody or give him supplies"),
                GoodDeed(text: "Help someone feel appreciated and valued if he/she doesn’t feel it"),
                GoodDeed(text: "Send a deep message from heart to a loved one"),
                GoodDeed(text: "Start separating recyclables, create a labeled recycling bin in your home"),
                GoodDeed(text: "Share your favorite inspirational quote with friends"),
                GoodDeed(text: "Teach a child something useful or teach new foreign words"),
                GoodDeed(text: "Plan a surprise for someone you love"),
                GoodDeed(text: "Check in with a friend who lives alone"),
                GoodDeed(text: "Help with household chores without being asked"),
                GoodDeed(text: "Help someone feel included and valued in a group/society"),
                GoodDeed(text: "Support someone in their dreams and goals"),
                GoodDeed(text: "Pray or wish someone well from your heart"),
                GoodDeed(text: "Share positive messages or quotes on social media"),
                GoodDeed(text: "Donate books to a library, school, or somebody who will have use of it"),
                GoodDeed(text: "Call your mother/father/sister/brother just to check on them"),
                GoodDeed(text: "Teach someone a new skill or share wisdom with them"),
                GoodDeed(text: "Offer emotional support to a person who needs it"),
                GoodDeed(text: "Let someone merge in traffic with a smile"),
                GoodDeed(text: "Report harmful or fake content"),
                GoodDeed(text: "Recommend someone a freelance job if they need"),
                GoodDeed(text: "Encourage others to treat everyone with respect")
                GoodDeed(text: "Show patience and understanding in difficult conversations"),
                GoodDeed(text: "Go through old memories together with someone"),
                GoodDeed(text: "Join an online support group and share kind words"),
                GoodDeed(text: "Donate money or feed the poor"),
                GoodDeed(text: "Write or speak publicly against injustice"),
                GoodDeed(text: "Spend uninterrupted quality time with a loved one"),
                GoodDeed(text: "Express appreciation for someone's goodness towards you"),
                GoodDeed(text: "Share snacks with people from narrow circle/colleagues"),
                GoodDeed(text: "Buy a plant or a tree or plant it yourself - to save the planet"),
                GoodDeed(text: "Call somebody in a foreign country so they know they are not forgotten"),
                GoodDeed(text: "Walk today instead of polluting earth with more gasoline"),
                GoodDeed(text: "Apply today to donate blood, share medicals, save health of others"),
                GoodDeed(text: "Encourage others to keep learning and growing")
                GoodDeed(text: "Pay for somebody's coffee"),
                GoodDeed(text: "Speak up when you witness unfair treatment or bullying"),
                GoodDeed(text: "Educate yourself or others about social injustice"),
                GoodDeed(text: "Offer a helping hand to someone in need"),
                GoodDeed(text: "Check in on a sick friend / call somebody who is ill"),
                GoodDeed(text: "Donate old tech devices to those in need"),
                GoodDeed(text: "Offer a genuine apology even if other person did wrong"),
                GoodDeed(text: "Be the reason someone smiles today"),
                GoodDeed(text: "Recycle plastic bottles or cardboard boxes"),
                GoodDeed(text: "Support a familiar person’s small business"),
                GoodDeed(text: "Listen actively to someone who needs to talk about their problems"),
                GoodDeed(text: "Support a charity through a donation link on social app"),
                GoodDeed(text: "Give someone a ride or share the same transportation"),
                GoodDeed(text: "Help a coworker with a project / student with their studies"),
                GoodDeed(text: "Leave a generous tip for a server"),
                GoodDeed(text: "Create or share helpful online tutorials or guides"),
                GoodDeed(text: "Donate clothes you no longer use"),
                GoodDeed(text: "Spend time playing with or reading to a child"),
                GoodDeed(text: "Write an inspirational note to someone"),
                GoodDeed(text: "Help a friend through a difficult time"),
                GoodDeed(text: "Express gratitude to people around you"),
                GoodDeed(text: "Feed an animal / give water / or cuddle it"),
                GoodDeed(text: "Share your favorite recipe with someone"),
                GoodDeed(text: "Compliment someone’s outfit or style"),
                GoodDeed(text: "Give sincere feedback on someone’s work"),
                GoodDeed(text: "Respectfully stand up for someone being mistreated"),
                GoodDeed(text: "Fix something that's broken - recycle, not throw away"),
                GoodDeed(text: "Be patient in a stressful situation"),
                GoodDeed(text: "Write or speak publicly against injustice"),
                GoodDeed(text: "Help someone find a job or get internship"),
            ]
        }
    }
    
    private func saveDeeds() {
        if let data = try? JSONEncoder().encode(allDeeds) {
            UserDefaults.standard.set(data, forKey: savedDeedsKey)
        }
    }
}

private let lastRefreshDateKey = "lastDeedRefreshDate"

private func isNewDay() -> Bool {
    guard let lastDate = UserDefaults.standard.object(forKey: lastRefreshDateKey) as? Date else {
        return true
    }
    return !Calendar.current.isDateInToday(lastDate)
}

