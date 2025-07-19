
import Foundation

enum HapticType: String, CaseIterable, Identifiable, Decodable {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
    case notification
    case directionUp
    case directionDown
    case failure
    case retry
    case start
    case stop
    case click

    var id: String { self.rawValue }

    static var watchOSCompatibleHaptics: [HapticType] {
        return [
            .notification,
            .directionUp,
            .directionDown,
            .success,
            .failure,
            .retry,
            .start,
            .stop,
            .click
        ]
    }
}
