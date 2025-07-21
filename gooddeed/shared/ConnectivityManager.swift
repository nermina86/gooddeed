import Foundation
import WatchConnectivity

final class ConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = ConnectivityManager()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func send(deed: GoodDeed) {    let data: [String: Any] = [
        "id": deed.id.uuidString,
        "title": deed.title,
        "isCompleted": deed.isCompleted
    ]

        
if WCSession.default.isReachable {
    WCSession.default.sendMessage(data, replyHandler: nil, errorHandler: nil)
} else {
    WCSession.default.transferUserInfo([
        "id": deed.id.uuidString,
        "title": deed.title,
        "isCompleted": deed.isCompleted
    ])
}

    }

    // ✅ REQUIRED by WCSessionDelegate (for all platforms)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    // ✅ iOS ONLY — must be present or it will throw protocol errors
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    #endif

    // ✅ Optional but useful
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let idString = message["id"] as? String,
           let id = UUID(uuidString: idString),
           let title = message["title"] as? String,
           let isCompleted = message["isCompleted"] as? Bool {
            let deed = GoodDeed(id: id, title: title, isCompleted: isCompleted)
            NotificationCenter.default.post(name: .didReceiveDeed, object: deed)
            NotificationCenter.default.post(name: .didReceiveDeed, object: deed)
        }
    }
}

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleIncomingDeedData(message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handleIncomingDeedData(userInfo)
    }

    private func handleIncomingDeedData(_ data: [String: Any]) {
        guard let idStr = data["id"] as? String,
              let id = UUID(uuidString: idStr),
              let title = data["title"] as? String,
              let isCompleted = data["isCompleted"] as? Bool else { return }

        let deed = GoodDeed(id: id, title: title, isCompleted: isCompleted)

        // Notify app to process the deed        NotificationCenter.default.post(name: .didReceiveDeed, object: deed)
    }
