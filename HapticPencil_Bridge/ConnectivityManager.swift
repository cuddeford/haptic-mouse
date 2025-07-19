import Foundation
import WatchConnectivity

// Define the data structure for our messages
struct HapticMessage: Codable {
    let type: String
}

class ConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = ConnectivityManager()

    @Published var receivedHapticType: HapticType? = nil

    private var session: WCSession = .default

    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - WCSessionDelegate Methods

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Begin activating a new session if the user has switched watches
        session.activate()
    }
    #endif

    // This method is called on the receiving device
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let hapticTypeString = message["hapticType"] as? String,
              let hapticType = HapticType(rawValue: hapticTypeString) else {
            print("Received unknown message: \(message)")
            return
        }

        print("Received haptic message: \(hapticType.rawValue)")
        
        // Use the main thread to trigger the haptic feedback
        DispatchQueue.main.async {
            HapticManager.trigger(type: hapticType)
        }
    }

    // MARK: - Public Sending Method

    func sendHaptic(_ type: HapticType) {
        let message = ["hapticType": type.rawValue]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
        print("Sent haptic message: \(type.rawValue)")
    }
}
