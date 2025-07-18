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

    func send(deed: GoodDeed) {
        if WCSession.default.isReachable {
            let data: [String: Any] = [
                "id": deed.id.uuidString,
                "title": deed.title,
                "isCompleted": deed.isCompleted
            ]
            WCSession.default.sendMessage(data, replyHandler: nil, errorHandler: nil)
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
        }
    }
}

