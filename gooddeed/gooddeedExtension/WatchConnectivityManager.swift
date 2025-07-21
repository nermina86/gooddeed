
import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityManager()

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {    }

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
        NotificationCenter.default.post(name: .didReceiveDeed, object: deed)
    }
}

