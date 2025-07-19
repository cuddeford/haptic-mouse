import Foundation
import WatchConnectivity
import WatchKit

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

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let hapticTypeString = message["hapticType"] as? String,
              let hapticType = HapticType(rawValue: hapticTypeString) else {
            print("Received unknown message: \(message)")
            return
        }

        print("Received haptic message: \(hapticType.rawValue)")
        
        // Use the main thread to trigger the haptic feedback and update UI
        DispatchQueue.main.async {
            self.receivedHapticType = hapticType
            HapticManager.trigger(type: hapticType)
        }
    }
}